local osmose = require 'osmose'
local et     = osmose.Model 'SOEC_ET'

et.header = {
  name        = 'SOEC_ET',
  displayName = 'High temperature electrolysis',
  authors     = {'Meire Ribeiro Domingos, Daniel Flórez-Orrego, EPFL IPESE research group'},
  versions    = {'1.0'},
  title       = 'High temperature solid oxide electrolysis (SOEC)',
  description = [[Solid oxide electrolyzer producing hydrogen from steam at about 800 C, with a sweep air that leaves
  enriched in oxygen. Mass and energy balances from an Aspen Plus model, per 1 kg/h of hydrogen. Translated from the
  ROSMOSE model SOEC.Rmd.]],
  references  = {'ISPT, Next Level Solid Oxide Electrolysis (2022), https://ispt.eu/media/20230508-FINAL-SOE-public-report-ISPT.pdf',
                 'CATF, Solid Oxide Electrolysis: A Technology Status Assessment (2023), https://cdn.catf.us/wp-content/uploads/2023/11/15092028/solid-oxide-electrolysis-report.pdf'},
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  -- Mass flows per 1 kg/h of hydrogen (Aspen Plus)
  massflowH2O      = {default = 10.78, unit = 'kg/h'},   -- water fed to the steam generator
  massflowAir      = {default = 55.66, unit = 'kg/h'},   -- sweep air
  massflowH2       = {default = 1,     unit = 'kg/h'},   -- hydrogen produced
  massflowH2O_out  = {default = 1.84,  unit = 'kg/h'},   -- water condensed and recovered in the sieves
  massflow_EnrAir  = {default = 63.59, unit = 'kg/h'},   -- enriched air, 70 % N2 and 30 % O2 (molar), at 25 C
  Elec_input       = {default = 34.217, unit = 'kW'},    -- electricity consumption, including the overpotentials

  -- Heat streams (Aspen Plus)
  hx_B3_ti  = {default = 25,    unit = 'C'}, hx_B3_to  = {default = 700,   unit = 'C'}, hx_B3_ho  = {default = 11.16, unit = 'kW'},  -- sweep air preheating
  hx_B13_ti = {default = 25,    unit = 'C'}, hx_B13_to = {default = 99,    unit = 'C'}, hx_B13_ho = {default = 0.954, unit = 'kW'},  -- water heating
  hx_B12_ti = {default = 99,    unit = 'C'}, hx_B12_to = {default = 99.64, unit = 'C'}, hx_B12_ho = {default = 6.77,  unit = 'kW'},  -- water evaporation
  hx_B11_ti = {default = 99.64, unit = 'C'}, hx_B11_to = {default = 800,   unit = 'C'}, hx_B11_ho = {default = 4.41,  unit = 'kW'},  -- steam superheating
  hx_B5_ti  = {default = 712,   unit = 'C'}, hx_B5_to  = {default = 25,    unit = 'C'}, hx_B5_ho  = {default = 12.905, unit = 'kW'}, -- enriched air cooling
  hx_B6_ti  = {default = 800,   unit = 'C'}, hx_B6_to  = {default = 200,   unit = 'C'}, hx_B6_ho  = {default = 3.11,  unit = 'kW'},  -- hydrogen and steam cooling
  hx_B17_ti = {default = 200,   unit = 'C'}, hx_B17_to = {default = 100,   unit = 'C'}, hx_B17_ho = {default = 0.5,   unit = 'kW'},
  hx_B18_ti = {default = 100,   unit = 'C'}, hx_B18_to = {default = 60,    unit = 'C'}, hx_B18_ho = {default = 0.198, unit = 'kW'},
  hx_B19_ti = {default = 60,    unit = 'C'}, hx_B19_to = {default = 25,    unit = 'C'}, hx_B19_ho = {default = 1.225, unit = 'kW'},  -- water condensation

  dtmin_liq = {default = 5, unit = 'C'},   -- dTmin/2 of liquids
  dtmin_gas = {default = 8, unit = 'C'},   -- dTmin/2 of gases
  dtmin_2ph = {default = 2, unit = 'C'},   -- dTmin/2 of two-phase streams

  costinv = {default = 1800, unit = 'EUR/kW'},  -- specific investment cost of the electrolyzer
  i       = {default = 0.06, unit = '-'},       -- interest rate
  n       = {default = 40,   unit = 'y'},       -- lifetime
}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  E_SOEC     = {unit = 'kW',    job = '1*Elec_input'},                                   -- electricity consumption of the SOEC
  Water_bal  = {unit = 'm3/h',  job = '(massflowH2O-massflowH2O_out)/1000'},             -- net water consumption
  Cinv2_SOEC = {unit = 'EUR/y', job = 'costinv*E_SOEC()*(i*((1+i)^n)/((1+i)^n-1))'},     -- annualized investment
}


--========================
-- Layers --
--========================
  et:addLayers { Enriched_air = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { hydrogen     = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { water        = {type = 'ResourceBalance', unit = 'm3/h'} }
  et:addLayers { Elec         = {type = 'ResourceBalance', unit = 'kW'} }


--==============================================================================================
-- Units --
--==============================================================================================

  et:addUnit('SOEC', {type = 'Utility', Fmin = 0, Fmax = 1000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2_SOEC'})
  et['SOEC']:addStreams {
    water_in         = rs({'water',        'in',  'Water_bal'}),
    hydrogen_out     = rs({'hydrogen',     'out', 'massflowH2'}),
    elec_in          = rs({'Elec',         'in',  'E_SOEC'}),
    enriched_air_out = rs({'Enriched_air', 'out', 'massflow_EnrAir'}),

    -- Cold streams
    qt_101 = qt({tin = 'hx_B3_ti',  hin = 0, tout = 'hx_B3_to',  hout = 'hx_B3_ho',  dtmin = 'dtmin_gas', alpha = 1}),
    qt_102 = qt({tin = 'hx_B13_ti', hin = 0, tout = 'hx_B13_to', hout = 'hx_B13_ho', dtmin = 'dtmin_liq', alpha = 1}),
    qt_103 = qt({tin = 'hx_B12_ti', hin = 0, tout = 'hx_B12_to', hout = 'hx_B12_ho', dtmin = 'dtmin_2ph', alpha = 1}),
    qt_104 = qt({tin = 'hx_B11_ti', hin = 0, tout = 'hx_B11_to', hout = 'hx_B11_ho', dtmin = 'dtmin_gas', alpha = 1}),

    -- Hot streams
    qt_105 = qt({tin = 'hx_B5_ti',  hin = 'hx_B5_ho',  tout = 'hx_B5_to',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    qt_106 = qt({tin = 'hx_B6_ti',  hin = 'hx_B6_ho',  tout = 'hx_B6_to',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    qt_107 = qt({tin = 'hx_B17_ti', hin = 'hx_B17_ho', tout = 'hx_B17_to', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    qt_108 = qt({tin = 'hx_B18_ti', hin = 'hx_B18_ho', tout = 'hx_B18_to', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    qt_109 = qt({tin = 'hx_B19_ti', hin = 'hx_B19_ho', tout = 'hx_B19_to', hout = 0, dtmin = 'dtmin_2ph', alpha = 1}),
  }


return et
