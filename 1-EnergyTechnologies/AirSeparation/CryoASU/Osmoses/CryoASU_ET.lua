local osmose = require 'osmose'
local et     = osmose.Model 'CryoASU_ET'

et.header = {
  name        = 'CryoASU_ET',
  displayName = 'Cryogenic air separation unit',
  authors     = {'Meire Ribeiro Domingos, Daniel Flórez-Orrego, EPFL IPESE research group'},
  versions    = {'1.0'},
  title       = 'Cryogenic air separation unit (ASU)',
  description = [[Cryogenic double-column air separation unit producing an oxygen-rich stream (99.5 % molar) and a
  nitrogen-rich stream at 1 bar, with four compressors that bring the oxygen to 30 bar for the process or to 200 bar
  for export, and the nitrogen to 7 bar for plasma torches or to 200 bar for export. Mass and energy balances from an
  Aspen HYSYS model. Translated from the ROSMOSE model CryoASU.Rmd.]],
  references  = {'Van der Ham, Gross, Kjelstrup, Energy 36(6) (2011) 3727-3732',
                 'Fu, Process Design and Evaluation for Chemicals Based on Renewable Resources, PhD thesis, DTU (2012)'},
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  dtmin_gas = {default = 8, unit = 'C'},  -- dTmin/2 of the compressor intercoolers

  -- Air compression to 7.45 bar, four intercooled stages, and power recovery in two expanders
  HX1_Tin = {default = 77.95, unit = 'C'}, HX1_Tout = {default = 40, unit = 'C'}, HX1_Q = {default = 1223.34, unit = 'kW'},
  HX2_Tin = {default = 96.72, unit = 'C'}, HX2_Tout = {default = 40, unit = 'C'}, HX2_Q = {default = 1834.63, unit = 'kW'},
  HX3_Tin = {default = 96.33, unit = 'C'}, HX3_Tout = {default = 40, unit = 'C'}, HX3_Q = {default = 1826.33, unit = 'kW'},
  HX4_Tin = {default = 95.64, unit = 'C'}, HX4_Tout = {default = 40, unit = 'C'}, HX4_Q = {default = 1811.04, unit = 'kW'},
  CompAir1 = {default = 1698.68, unit = 'kW'},  -- air inlet at 1 bar and 30 C
  CompAir2 = {default = 1825.90, unit = 'kW'},
  CompAir3 = {default = 1812.07, unit = 'kW'},
  CompAir4 = {default = 1788.02, unit = 'kW'},  -- air outlet at 7.45 bar and 40 C
  Turb1    = {default = 1027.85, unit = 'kW'},  -- expander 1, power recovery
  Turb2    = {default = 42.65,   unit = 'kW'},  -- expander 2, power recovery

  -- Products at 1 bar and 30 C
  OXYGEN   = {default = 21025.81, unit = 'kg/h'},  -- oxygen-rich stream, 99.5 % O2 (molar)
  NITROGEN = {default = 86417.20, unit = 'kg/h'},  -- nitrogen-rich stream, 93 % N2

  -- Nitrogen compression to the plasma torches, 1 to 7 bar
  HX13_Tin = {default = 109.8, unit = 'C'}, HX13_Tout = {default = 30, unit = 'C'}, HX13_Q = {default = 2148, unit = 'kW'},
  HX14_Tin = {default = 135.8, unit = 'C'}, HX14_Tout = {default = 30, unit = 'C'}, HX14_Q = {default = 2867, unit = 'kW'},
  CompN2Plas1 = {default = 2912, unit = 'kW'},
  CompN2Plas2 = {default = 2841, unit = 'kW'},

  -- Nitrogen compression to export, 1 to 200 bar
  HX15_Tin = {default = 129.3, unit = 'C'}, HX15_Tout = {default = 30, unit = 'C'}, HX15_Q = {default = 2678, unit = 'kW'},
  HX16_Tin = {default = 171.1, unit = 'C'}, HX16_Tout = {default = 30, unit = 'C'}, HX16_Q = {default = 3841, unit = 'kW'},
  HX17_Tin = {default = 171.2, unit = 'C'}, HX17_Tout = {default = 30, unit = 'C'}, HX17_Q = {default = 3910, unit = 'kW'},
  HX18_Tin = {default = 171.3, unit = 'C'}, HX18_Tout = {default = 30, unit = 'C'}, HX18_Q = {default = 4088, unit = 'kW'},
  HX19_Tin = {default = 170.5, unit = 'C'}, HX19_Tout = {default = 30, unit = 'C'}, HX19_Q = {default = 4415, unit = 'kW'},
  CompN2Exp1 = {default = 3440, unit = 'kW'},  -- to 2.95 bar
  CompN2Exp2 = {default = 3804, unit = 'kW'},  -- to 8.43 bar
  CompN2Exp3 = {default = 3806, unit = 'kW'},  -- to 24.32 bar
  CompN2Exp4 = {default = 3821, unit = 'kW'},  -- to 70.18 bar
  CompN2Exp5 = {default = 3905, unit = 'kW'},  -- to 200 bar and 30 C

  -- Oxygen compression to the process, 1 to 30 bar (autothermal reformers, gasifiers)
  HX5_Tin = {default = 155.6, unit = 'C'}, HX5_Tout = {default = 56, unit = 'C'}, HX5_Q = {default = 548.6, unit = 'kW'},
  HX6_Tin = {default = 198.3, unit = 'C'}, HX6_Tout = {default = 56, unit = 'C'}, HX6_Q = {default = 794.1, unit = 'kW'},
  HX7_Tin = {default = 198.7, unit = 'C'}, HX7_Tout = {default = 30, unit = 'C'}, HX7_Q = {default = 959.1, unit = 'kW'},
  CompO2Proc1 = {default = 712.3, unit = 'kW'},  -- to 3.14 bar
  CompO2Proc2 = {default = 784.7, unit = 'kW'},  -- to 9.73 bar
  CompO2Proc3 = {default = 783.8, unit = 'kW'},  -- to 30 bar and 30 C

  -- Oxygen compression to export, 1 to 200 bar
  HX8_Tin  = {default = 162,   unit = 'C'}, HX8_Tout  = {default = 30, unit = 'C'}, HX8_Q  = {default = 724.4, unit = 'kW'},
  HX9_Tin  = {default = 169,   unit = 'C'}, HX9_Tout  = {default = 30, unit = 'C'}, HX9_Q  = {default = 768.8, unit = 'kW'},
  HX10_Tin = {default = 169.1, unit = 'C'}, HX10_Tout = {default = 30, unit = 'C'}, HX10_Q = {default = 783.8, unit = 'kW'}, -- the ROSMOSE comment gives 0.035137 kWh/kg, i.e. 738.8 kW
  HX11_Tin = {default = 169.3, unit = 'C'}, HX11_Tout = {default = 30, unit = 'C'}, HX11_Q = {default = 824.4, unit = 'kW'},
  HX12_Tin = {default = 168.2, unit = 'C'}, HX12_Tout = {default = 30, unit = 'C'}, HX12_Q = {default = 909.8, unit = 'kW'},
  CompO2Exp1 = {default = 748.0, unit = 'kW'},  -- to 2.95 bar
  CompO2Exp2 = {default = 759.6, unit = 'kW'},  -- to 8.43 bar
  CompO2Exp3 = {default = 757.7, unit = 'kW'},  -- to 24.32 bar
  CompO2Exp4 = {default = 753.2, unit = 'kW'},  -- to 70.18 bar
  CompO2Exp5 = {default = 748.9, unit = 'kW'},  -- to 200 bar and 30 C

  -- Economics
  SpecInvASU = {default = 50E6/1000, unit = 'EUR/tpd'},  -- 50 MEUR per 1,000 t/day of oxygen
  i          = {default = 0.06, unit = '-'},             -- interest rate
  n          = {default = 40,   unit = 'y'},             -- lifetime
  CEPCI2020  = {default = 596.2, unit = '-'},
  CEPCI2014  = {default = 576.1, unit = '-'},
}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  W_cryoASU = {unit = 'kW', job = 'CompAir1+CompAir2+CompAir3+CompAir4-Turb1-Turb2'},       -- air compression minus expanders
  W_O2proc  = {unit = 'kW', job = 'CompO2Proc1+CompO2Proc2+CompO2Proc3'},                    -- oxygen to 30 bar
  W_O2exp   = {unit = 'kW', job = 'CompO2Exp1+CompO2Exp2+CompO2Exp3+CompO2Exp4+CompO2Exp5'}, -- oxygen to 200 bar
  W_N2plas  = {unit = 'kW', job = 'CompN2Plas1+CompN2Plas2'},                                -- nitrogen to 7 bar
  W_N2exp   = {unit = 'kW', job = 'CompN2Exp1+CompN2Exp2+CompN2Exp3+CompN2Exp4+CompN2Exp5'}, -- nitrogen to 200 bar

  Annuity       = {unit = '-',     job = '(i*(i+1)^n)/((i+1)^n-1)'},
  Cinv2_CryoASU = {unit = 'EUR/y', job = 'SpecInvASU*OXYGEN/1000*24*(CEPCI2020/CEPCI2014)*Annuity()'},
}


--========================
-- Layers --
--   oxyvent / nitrovent: oxygen and nitrogen leaving the ASU at 1 bar, to be vented or compressed
--   oxyprocess: oxygen at 30 bar; Oxygen: oxygen at 200 bar for export
--   nitroplasma: nitrogen at 7 bar for plasma torches; Nitrogen: nitrogen at 200 bar for export
--========================
  et:addLayers { Elec        = {type = 'ResourceBalance', unit = 'kW'} }
  et:addLayers { Oxygen      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { oxyprocess  = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { oxyvent     = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Nitrogen    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { nitroplasma = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { nitrovent   = {type = 'ResourceBalance', unit = 'kg/h'} }


--==============================================================================================
-- Units --
--==============================================================================================

  -- Cryogenic air separation: air compression, main heat exchanger, double column and expanders
  et:addUnit('CryoASUnit', {type = 'Utility', Fmin = 0, Fmax = 100000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2_CryoASU'})
  et['CryoASUnit']:addStreams {
    elec_in        = rs({'Elec',      'in',  'W_cryoASU'}),
    oxyvent_out    = rs({'oxyvent',   'out', 'OXYGEN'}),
    nitrovent_out  = rs({'nitrovent', 'out', 'NITROGEN'}),

    heatexchanger1 = qt({tin = 'HX1_Tin', hin = 'HX1_Q', tout = 'HX1_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger2 = qt({tin = 'HX2_Tin', hin = 'HX2_Q', tout = 'HX2_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger3 = qt({tin = 'HX3_Tin', hin = 'HX3_Q', tout = 'HX3_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger4 = qt({tin = 'HX4_Tin', hin = 'HX4_Q', tout = 'HX4_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }

  -- Nitrogen compressor to the plasma torches, 1 to 7 bar
  et:addUnit('CryoASUN2ToPlas', {type = 'Utility', Fmin = 0, Fmax = 100000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['CryoASUN2ToPlas']:addStreams {
    elec_in         = rs({'Elec',        'in',  'W_N2plas'}),
    nitrovent_in    = rs({'nitrovent',   'in',  'NITROGEN'}),
    nitroplasma_out = rs({'nitroplasma', 'out', 'NITROGEN'}),

    heatexchanger13 = qt({tin = 'HX13_Tin', hin = 'HX13_Q', tout = 'HX13_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger14 = qt({tin = 'HX14_Tin', hin = 'HX14_Q', tout = 'HX14_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }

  -- Nitrogen compressor to export, 1 to 200 bar
  et:addUnit('CryoASUN2ToExp', {type = 'Utility', Fmin = 0, Fmax = 100000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['CryoASUN2ToExp']:addStreams {
    elec_in         = rs({'Elec',      'in',  'W_N2exp'}),
    nitrovent_in    = rs({'nitrovent', 'in',  'NITROGEN'}),
    nitrogen_out    = rs({'Nitrogen',  'out', 'NITROGEN'}),

    heatexchanger15 = qt({tin = 'HX15_Tin', hin = 'HX15_Q', tout = 'HX15_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger16 = qt({tin = 'HX16_Tin', hin = 'HX16_Q', tout = 'HX16_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger17 = qt({tin = 'HX17_Tin', hin = 'HX17_Q', tout = 'HX17_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger18 = qt({tin = 'HX18_Tin', hin = 'HX18_Q', tout = 'HX18_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger19 = qt({tin = 'HX19_Tin', hin = 'HX19_Q', tout = 'HX19_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }

  -- Oxygen compressor to the process, 1 to 30 bar
  et:addUnit('CryoASUO2ToProc', {type = 'Utility', Fmin = 0, Fmax = 100000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['CryoASUO2ToProc']:addStreams {
    elec_in        = rs({'Elec',       'in',  'W_O2proc'}),
    oxyvent_in     = rs({'oxyvent',    'in',  'OXYGEN'}),
    oxyprocess_out = rs({'oxyprocess', 'out', 'OXYGEN'}),

    heatexchanger5 = qt({tin = 'HX5_Tin', hin = 'HX5_Q', tout = 'HX5_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger6 = qt({tin = 'HX6_Tin', hin = 'HX6_Q', tout = 'HX6_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger7 = qt({tin = 'HX7_Tin', hin = 'HX7_Q', tout = 'HX7_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }

  -- Oxygen compressor to export, 1 to 200 bar
  et:addUnit('CryoASUO2ToExp', {type = 'Utility', Fmin = 0, Fmax = 100000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['CryoASUO2ToExp']:addStreams {
    elec_in         = rs({'Elec',    'in',  'W_O2exp'}),
    oxyvent_in      = rs({'oxyvent', 'in',  'OXYGEN'}),
    oxygen_out      = rs({'Oxygen',  'out', 'OXYGEN'}),

    heatexchanger8  = qt({tin = 'HX8_Tin',  hin = 'HX8_Q',  tout = 'HX8_Tout',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger9  = qt({tin = 'HX9_Tin',  hin = 'HX9_Q',  tout = 'HX9_Tout',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger10 = qt({tin = 'HX10_Tin', hin = 'HX10_Q', tout = 'HX10_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger11 = qt({tin = 'HX11_Tin', hin = 'HX11_Q', tout = 'HX11_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    heatexchanger12 = qt({tin = 'HX12_Tin', hin = 'HX12_Q', tout = 'HX12_Tout', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }


return et
