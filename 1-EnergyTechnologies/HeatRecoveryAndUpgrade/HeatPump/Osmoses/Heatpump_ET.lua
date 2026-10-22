local osmose = require 'osmose'
local et = osmose.Model 'Heatpump_ET'


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
    title = 'Heat Pump',
    description = [[Heat Pump]],
    references = {'Florez-Orrego et al. Journal of Cleaner Production 244 (2020) 118647'},
    adaptedwith = {},
    notes =  {}
  }

et.inputs = {
    -- Evaporator temperatures
    Evap_Tin = {default=96, unit='°C'},-- previously 100
    Evap_Tout = {default=96, unit='°C'}, -- previously 100
    -- Condenser temperatures
    Cond_Tin = {default=110, unit='°C'}, -- a T, Psat selected for using CW initially 140
    Cond_Tout = {default=110, unit='°C'}, -- Florez-Orrego, et al. 2015 initially 140
    -- Heat pumping duty
    Cond_Qmax = {default=3500, unit='kW'},-- Florez-Orrego, et al. 2015 initially 6000
    exeff = {default = 0.5,unit = ''}, -- exergy efficiency
    -- dtmin contribution
    dtmin_gas={default = 8,unit = 'C'},
    dtmin_liq={default = 5,unit = 'C'},
    dtmin_2ph={default = 2,unit = 'C'},

---------------
-- ECONOMICS ---
---------------

    n   = {default = 40, unit = 'year', description = 'Lifetime'},
    i = {default = 0.06, unit = '-', description = 'Discount interest rate'},
    CEPCI_2020   = {default = 596.2,    unit = '-', description = 'actual CEPCI'},
    CEPCI_2008   = {default = 575.4,    unit = '-', description = 'CEPCI 2008'},


}


---------------
-- OUTPUTS ---
---------------

et.outputs = {
    -- COP calculation
    COPcarnot = {unit='kW',job='(Cond_Tin+273)/(Cond_Tin-Evap_Tin)' },
    COP = {unit='kW',job='exeff*COPcarnot()' },
    -- Electricity consumption
    W_heatpump = {unit='kW',job='Cond_Qmax/COP()' },
    -- Evaporator
    Evap_Qmax = {unit='kW',job='Cond_Qmax*(COP()-1)/COP()' },

---------------
-- ECONOMICS ---
---------------
Annuity = {job = '(i*(i+1)^n)/((i+1)^n-1)',unit = '-'},

Cinv2_HP = {unit='kW', job=
    function()
        if Cond_Qmax < 500 then -- if heat duty is less than 500 kW
            HP_Cinv2= (750*Cond_Qmax)*(CEPCI_2020/CEPCI_2008)*Annuity() -- Eur/y  -- 750 Eur/kWth at cond
        else
            HP_Cinv2= (300*Cond_Qmax)*(CEPCI_2020/CEPCI_2008)*Annuity() -- Eur/y -- 300 Eur/kWth at cond
        end
    return HP_Cinv2
    end
 }
    
}

---------------
---- LAYERS ---
---------------

et:addLayers {Elec = {type= 'ResourceBalance', unit = 'kW'} }



---------------
----- UNITS ---
---------------

et:addUnit('Heatpump',{type='Utility', Fmin = 0, Fmax = 1, Cost1=0, Cost2=0, Cinv1=0, Cinv2='Cinv2_HP', Impact1=0, Impact2=0})
et['Heatpump']:addStreams{
    -- Heat
    qt_evap = qt({tin = 'Evap_Tin', hin = 0, tout='Evap_Tout', hout='Evap_Qmax', dtmin='dtmin_2ph', alpha=1}),
    qt_cond = qt({tin = 'Cond_Tin', hin = 'Cond_Qmax', tout='Cond_Tout', hout=0, dtmin='dtmin_2ph', alpha=1}),
    -- Electricity consumption
    elec_in = rs({'Elec', 'in', 'W_heatpump'})     
}

return et