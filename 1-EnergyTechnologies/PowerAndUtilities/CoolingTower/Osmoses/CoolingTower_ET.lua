local osmose = require 'osmose'
local et = osmose.Model 'CoolingTower_ET'

et.header = {
    name = '',
    displayName = '',
    authors = {'Daniel Flórez-Orrego, EPFL IPESE research group'},
    developers = {''},
    contributors = {''},
    creation_date = '01.06.2025',
    updates = {'21.10.2026'},
    versions = {'1.0.2'},
    confidentiality = {'Open'},
    title = 'Cooling tower utility',
    description = [[Cooling tower utility]],
    references = {'Int. J. Environ. Sci. Tech., 5 (2), 251-262, Spring 2008',
                  'ECOS2015, Florez-Orrego, et al.',
                  'Stull, Wet-Bulb Temperature from Relative Humidity and Air Temperature, 2011, DOI: https://doi.org/10.1175/JAMC-D-11-0143.1',
                  'Perry Chemical Engineers Handbook',
                  'https://spxcooling.com/coolingtowers',
                  'MARLEY, Cooling Tower energy and its management'},
    adaptedwith = {},
    notes =  {}
  }

----------
-- User parameters
----------

et.inputs = {
    -- Heat 
    Cool_Tin = {default=16.32, unit='°C'},  -- supply water temperature, 4 K above the ambient wet-bulb temperature; ECOS2015, Florez-Orrego, et al.
    Cool_Tout = {default=30, unit='°C'},  -- return water temperature; ECOS2015, Florez-Orrego, et al.
    Cool_Qmax = {default=100000, unit='kW'}, -- reference value of heat
    cp_water = {default=4.2, unit='kJ/kgK'}, -- heat capacity of water at 25 °C
    Tdrybulb =  {default=20, unit='C'}, -- dry-bulb temperature of the ambient air at the site, at design conditions
    RelatHum =  {default=40, unit='%'}, -- relative humidity of the ambient air at the site, at design conditions
            
    -- Electricity consumption
    Cool_Elec = {default=0.021, unit='kW_el/kW_th' },-- MARLEY, Cooling Tower energy and its management. Energy for 400tons -30kW
    
    dtmin_gas={default = 8,unit = 'C'},
    dtmin_liq={default = 5,unit = 'C'},
    dtmin_2ph={default = 2,unit = 'C'},
------------------------------
------- ECONOMICS ------------
------------------------------
    
    n  = {default = 40, unit = 'year', description = 'Lifetime'},
    i  = {default = 0.06, unit = '-', description = 'interest rate'},
    CEPCI_2020  = {default = 596.2,    unit = '-', description = 'actual CEPCI'},
    CEPCI_2008  = {default = 575.4,    unit = '-', description = 'CEPCI 2008'},
}

-----------
-- Calculated parameters
-----------

et.outputs = {
    -- wet-bulb temperature of the ambient air, Stull (2011) apud ECOS2015, Florez-Orrego, et al.,
    -- rounded to 0.01 °C as in the workbook
    Twetbulb = {job='math.floor((Tdrybulb*math.atan(0.151977*math.sqrt(RelatHum+8.313659)) + math.atan(Tdrybulb+RelatHum) - math.atan(RelatHum-1.676331) + 0.00391838*RelatHum^1.5*math.atan(0.023101*RelatHum) - 4.686035)*100 + 0.5)/100', unit='C'},
    -- Electricity consumption
    E_ref_CT = {job='Cool_Elec*Cool_Qmax',unit='kW',},
    range = {job='Cool_Tout-Cool_Tin', unit='K'}, 
    approach = {job='Cool_Tin-Twetbulb()', unit='K'}, -- difference between the cold-water supply temperature and the ambient wet-bulb temperature
    water_flow = {job='Cool_Qmax/cp_water/range()*3600/1000', unit='t/h'}, -- water flow rate
    water_vflow = {job='water_flow()*1', unit='m^3/h'}, -- water volume flow rate for 1 t/m3
    watermu_CT = {job='0.00085*1.8*water_vflow()*(Cool_Tout-Cool_Tin)', unit='m3/h'}, -- makeup water in the CT system

------------------------------
------- ECONOMICS ------------
------------------------------ 
    Annuity = {job = '(i*(i+1)^n)/((i+1)^n-1)',unit = '-', },
    CTCost = {job = '746.49/0.066*(water_flow()^0.79)*(range()^0.57)*(approach()^-0.9924)*(0.022*Twetbulb()+0.39)^2.447', unit = 'Eur'},
    Cinv2_CT = {job = 'CTCost()*(CEPCI_2020/CEPCI_2008)*Annuity()', unit = 'Eur/y'}, 
     

}

-----------
-- Layers
-----------

et:addLayers {Elec = {type= 'ResourceBalance', unit = 'kW'} }
et:addLayers {water = {type= 'ResourceBalance', unit = 'm3/h'} } -- makeup water

-----------
-- Units
-----------

et:addUnit('CoolingTower',{type='Utility', Fmin = 0, Fmax = 100, Cost1=0, Cost2=0, Cinv1=0, Cinv2='Cinv2_CT'})
et['CoolingTower']:addStreams{
    -- Heat
    qt = qt({tin = 'Cool_Tin', hin = 0, tout='Cool_Tout', hout='Cool_Qmax', dtmin='dtmin_liq', alpha=1}),
    -- Electricity consumption
    elec_CT = rs({'Elec', 'in', 'E_ref_CT'}),
    -- Water makeup
    watermakeup_CT = rs({'water', 'in', 'watermu_CT'})
}


return et