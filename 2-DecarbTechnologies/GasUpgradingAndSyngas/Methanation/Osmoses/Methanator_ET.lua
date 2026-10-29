local osmose = require 'osmose'
local et = osmose.Model 'Methanathor'


et.header = {
    name = '',
    displayName = '',
    authors = {'Daniel Flórez-Orrego, EPFL IPESE research group'},
    developers = {''},
    contributors = {''},
    creation_date = '',
    updates = {''},
    versions = {'1.0'},
    confidentiality = {''},
    title = 'Methanator',
    description = [[Methanation reactor]],
    references = {'https://www.frontiersin.org/articles/10.3389/fenrg.2018.00005; Florez-Orrego et al. Journal of Cleaner Production 244 (2020) 118647'},
    adaptedwith = {},
    notes =  {}
  }

et.inputs = {

--=========================----
----- Methanator Utility ------
--=========================----

  ---------------------
  -- Mass flows reference --
  ---------------------
    CO2_input    = {default = 44, unit = 'kg/h'},
    H2_input     = {default = 8, unit = 'kg/h'},
    CH4_ouput    = {default = 16, unit = 'kg/h'},
    Water_output = {default = 0.036, unit = 'm3/h'}, -- 36 kg/h
    LHV_CH4      = {default = 50000, unit = 'kJ/kg'},
  ---------------------
  -- Heat stream --
  ---------------------
    -- methanator operating at 30 bar - pure methanation TREMP hysys model

    Tin_hot1 = {default = 542, unit = 'C'},
    Q_hot1_spec = {default = 1.961, unit = 'kWh/kgCH4'},
    Tout_hot1 = {default = 300, unit = 'C'},

    Tin_hot2 = {default = 411, unit = 'C'},
    Q_hot2_spec = {default = 0.799, unit = 'kWh/kgCH4'},
    Tout_hot2 = {default = 200, unit = 'C'},

    Tin_hot3 = {default = 202, unit = 'C'},
    Q_hot3_spec = {default = 1.095, unit = 'kWh/kgCH4'},
    Tout_hot3 = {default = 40, unit = 'C'},

    dtmin_intercool = {default = 5, unit = 'C'},
  ---------------------
  ----- Economics -----
  ---------------------
    i   = {default = 0.06, unit = nil},
    n   = {default = 40, unit = nil},
    --Cop_meth_spec = {default = 0.005, unit = 'Eur/kWh_CH4'},
    Cinv2_meth_spec = {default = 300, unit = 'Eur/kW_CH4'},
    Cinv2_compr_spec = {default = 900, unit = 'Eur/kW_comp'}, -- BareMC from Turton, linearizing from 450 - 3000 kW centrifugal compressor


--=================================----
----- CO2 compress to Methanator ------
--=================================----
-- Compression 3 stages 1 bar to 30 bar (independent of CO2 storage unit)
    spec_work_kwh = {default = 0.02655+0.02672+0.02588, unit = 'kWh/kgCO2'}, -- power from 1 bar CO2 to 30 bar Comp_CO2 methanator
    spec_cool_kwh = {default = 0.02586+0.02842+0.03190, unit = 'kWh/kgCO2'} -- heat from 1 bar CO2 to 30 bar Comp_CO2 methanator

}

et.outputs = {

    Q_hot1 = {job = 'Q_hot1_spec*CH4_ouput', unit = 'kW'},
    Q_hot2 = {job = 'Q_hot2_spec*CH4_ouput', unit = 'kW'},
    Q_hot3 = {job = 'Q_hot3_spec*CH4_ouput', unit = 'kW'},

    CH4_outputkW = {job = 'CH4_ouput*LHV_CH4/3600', unit = 'kW'},

    --Cop_meth = {job = 'Cop_meth_spec*CH4_outputkW()', unit = 'Eur/h'},
    Cinv2_meth = {job = 'Cinv2_meth_spec*CH4_outputkW()*(i*((1+i)^n)/((1+i)^n-1))', unit = 'EUR/yr'},


    Cinv2_compr = {job = 'Cinv2_compr_spec*spec_work_kwh*1*(i*((1+i)^n)/((1+i)^n-1))', unit = 'EUR/y'}, -- Eur/kW * kWh/kgCO2 * 1kgCO2/h * 1/y

}

et:addLayers {CO2  = {type ='ResourceBalance', unit ='kg/h'}}
et:addLayers { Comp_CO2 = { type='ResourceBalance', unit = 'kg/h' }} -- compressed CO2 from CO2 storage or from CO2 at low pressure (bypass storage)
et:addLayers { hydrogen  = { type='ResourceBalance', unit = 'kg/h' }}
et:addLayers { CH4 = { type='ResourceBalance', unit = 'kW' }}
et:addLayers {water = {type= 'ResourceBalance', unit = 'm3/h'} }
et:addLayers {Elec = {type ='ResourceBalance', unit ='kW'}}


et:addUnit('MethanatorUtil', {type = 'Utility', Fmin = 0, Fmax = 100000000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2_meth'}) -- Fmax = 10000
et['MethanatorUtil']:addStreams({
    H2_in = rs({'hydrogen','in', 'H2_input'}),
    CO2_in = rs({'Comp_CO2','in', 'CO2_input'}),
    water_out = rs({'water','out','Water_output'}),
    CH4_out = rs({'CH4','out','CH4_outputkW'}), -- methanator operating at 30 bar - pure methanation TREMP hysys model

    q_meth1 = qt({tin = 'Tin_hot1' , hin = 'Q_hot1', tout = 'Tout_hot1', hout = 0, dtmin = 'dtmin_intercool', alpha = 1}),
    q_meth2 = qt({tin = 'Tin_hot2' , hin = 'Q_hot2', tout = 'Tout_hot2', hout = 0, dtmin = 'dtmin_intercool', alpha = 1}),
    q_meth3 = qt({tin = 'Tin_hot3' , hin = 'Q_hot3', tout = 'Tout_hot3', hout = 0, dtmin = 'dtmin_intercool', alpha = 1}),     

})


-- Compression 3 stages 1 bar to 30 bar (independent of CO2 storage unit)
et:addUnit('Compress_CO2', {type = 'Utility', Fmin = 0, Fmax = 1000000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2_compr'})
et['Compress_CO2']:addStreams({
  --Intercool = qt({tin = 90 , hin = 'spec_cool_kwh', tout = 40, hout = 0, dtmin = 'dtmin_intercool', alpha = 1}), -- heat kW per kg/h
  Elec_in   = rs({'Elec', 'in', 'spec_work_kwh'}), -- power kW per kg/h
  CO2_gas_in = rs({'CO2', 'in', 1}), -- 1 kg/h CO2
  CO2_comp_out  = rs({'Comp_CO2', 'out', 1}) -- 1 kg/h Comp_CO2 to methanator
}) 


return et