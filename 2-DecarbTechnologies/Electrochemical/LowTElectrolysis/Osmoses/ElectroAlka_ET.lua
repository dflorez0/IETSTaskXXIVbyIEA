local osmose = require 'osmose'
local et     = osmose.Model 'ElectroAlka_ET'

et.header = {
  name        = 'ElectroAlka_ET',
  displayName = 'Low temperature electrolysis',
  authors     = {'Meire Ribeiro Domingos, Daniel Flórez-Orrego, EPFL IPESE research group'},
  versions    = {'1.0'},
  title       = 'Low temperature (alkaline) water electrolysis',
  description = [[Alkaline water electrolyzer producing hydrogen and oxygen from liquid water, with two booster
  compressors that bring the oxygen to 30 bar for the process or to 200 bar for export. Translated from the
  ROSMOSE model ElectroAlka_ET.Rmd.]],
  references  = {'Domingos et al., Computers and Chemical Engineering 176 (2023) 108305, https://doi.org/10.1016/j.compchemeng.2023.108305',
                 'IEA, The Future of Hydrogen (2019), https://www.iea.org/reports/the-future-of-hydrogen'},
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  HHV_H2            = {default = 141746, unit = 'kJ/kg'},     -- higher heating value of hydrogen
  massflowH2O       = {default = 1000, unit = 'kg/h'},        -- reference mass flow of water consumed
  H2toH2O_massratio = {default = 1/9, unit = 'kg/kg'},        -- stoichiometric hydrogen to water mass ratio
  dTminw            = {default = 5, unit = 'C'},              -- dTmin/2 of the electrolyzer cooling (water)
  dtmin_gas         = {default = 8, unit = 'C'},              -- dTmin/2 of the gas streams

  E_AlkaElec_spec   = {default = 55, unit = 'kWh/kg'},        -- specific electricity consumption, per kg of H2
  Q_AlkaElec_spec   = {default = (21.90+11.90)/111.11, unit = 'kWh/kg'}, -- specific cooling duty, per kg of H2 (33.8 kW for 111 kg/h of H2 and 888 kg/h of O2)
  Thot_AlkaEle      = {default = 80, unit = 'C'},             -- outlet temperature of the electrolyzer
  Tcold_AlkaEle     = {default = 30, unit = 'C'},             -- inlet temperature of the electrolyzer

  costinv           = {default = 1200, unit = 'EUR/kW'},      -- specific investment cost of the electrolyzer
  i                 = {default = 0.06, unit = '-'},           -- interest rate
  n                 = {default = 40, unit = 'y'},             -- lifetime

  -- Oxygen compression to the process, 1 to 30 bar, three intercooled stages
  To2cp1procwsu_in  = {default = 172,   unit = 'C'},          -- intercooler inlet, 1 to 3 bar
  To2cp1procwsu_out = {default = 30,    unit = 'C'},
  To2cp2procwsu_in  = {default = 179.5, unit = 'C'},          -- intercooler inlet, 3 to 10 bar
  To2cp2procwsu_out = {default = 30,    unit = 'C'},
  To2cp3procwsu_in  = {default = 179.6, unit = 'C'},          -- intercooler inlet, 10 to 30 bar
  To2cp3procwsu_out = {default = 30,    unit = 'C'},

  -- Oxygen compression to export, 30 to 200 bar, three more intercooled stages
  To2cp1expwsu_in   = {default = 108.6, unit = 'C'},          -- intercooler inlet, 30 to 60 bar
  To2cp1expwsu_out  = {default = 30,    unit = 'C'},
  To2cp2expwsu_in   = {default = 108.3, unit = 'C'},          -- intercooler inlet, 60 to 100 bar
  To2cp2expwsu_out  = {default = 30,    unit = 'C'},
  To2cp3expwsu_in   = {default = 107,   unit = 'C'},          -- intercooler inlet, 100 to 200 bar
  To2cp3expwsu_out  = {default = 30,    unit = 'C'},
}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  waterCons      = {unit = 'm3/h', job = 'massflowH2O/1000'},                    -- volumetric flow of water consumed
  massflowH2     = {unit = 'kg/h', job = 'massflowH2O*H2toH2O_massratio'},       -- hydrogen produced
  massflowO2     = {unit = 'kg/h', job = 'massflowH2O-massflowH2()'},            -- oxygen produced
  E_AlkaElec     = {unit = 'kW',   job = 'massflowH2()*E_AlkaElec_spec'},        -- electricity consumption
  Q_AlkaElec     = {unit = 'kW',   job = 'massflowH2()*Q_AlkaElec_spec'},        -- cooling duty of the electrolyzer
  Cinv2_AlkaElec = {unit = 'EUR/y', job = 'costinv*E_AlkaElec()*(i*((1+i)^n)/((1+i)^n-1))'}, -- annualized investment

  -- Oxygen compressors: heat of each intercooler and electricity, per kg/h of oxygen
  Qo2cp1procwsu     = {unit = 'kW', job = 'massflowO2()*0.0371'},
  Qo2cp2procwsu     = {unit = 'kW', job = 'massflowO2()*0.03931'},
  Qo2cp3procwsu     = {unit = 'kW', job = 'massflowO2()*0.04025'},
  W_net_procO2wsu   = {unit = 'kW', job = 'massflowO2()*(0.03823+0.03886+0.03887)'},            -- 1 to 30 bar
  Qo2cp1expwsu      = {unit = 'kW', job = 'massflowO2()*0.02181'},
  Qo2cp2expwsu      = {unit = 'kW', job = 'massflowO2()*0.02302'},
  Qo2cp3expwsu      = {unit = 'kW', job = 'massflowO2()*0.02458'},
  W_net_exportO2wsu = {unit = 'kW', job = 'W_net_procO2wsu()+massflowO2()*(0.01984+0.01963+0.01948)'}, -- 1 to 200 bar
}


--========================
-- Layers --
--   oxyvent: oxygen leaving the electrolyzer at 1 bar, to be vented or compressed
--   oxyprocess: oxygen at 30 bar to the process; Oxygen: oxygen at 200 bar for export
--========================
  et:addLayers { Oxygen      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { oxyprocess  = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { oxyvent     = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { hydrogen    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { water       = {type = 'ResourceBalance', unit = 'm3/h'} }
  et:addLayers { Elec        = {type = 'ResourceBalance', unit = 'kW'} }


--==============================================================================================
-- Units --
--==============================================================================================

  -- Alkaline electrolyzer
  et:addUnit('AElectrolyzer', {type = 'Utility', Fmin = 0, Fmax = 1000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2_AlkaElec'})
  et['AElectrolyzer']:addStreams {
    water_in      = rs({'water',       'in',  'waterCons'}),
    hydrogen_out  = rs({'hydrogen',    'out', 'massflowH2'}),
    elec_in       = rs({'Elec',        'in',  'E_AlkaElec'}),
    oxyvent_out   = rs({'oxyvent',     'out', 'massflowO2'}),

    Heat_AlkaElec = qt({tin = 'Thot_AlkaEle', hin = 'Q_AlkaElec', tout = 'Tcold_AlkaEle', hout = 0, dtmin = 'dTminw', alpha = 1}),
  }

  -- Oxygen booster compressor to the process, 1 to 30 bar
  et:addUnit('O2ToProcWSU', {type = 'Utility', Fmin = 0, Fmax = 1000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['O2ToProcWSU']:addStreams {
    elec_in        = rs({'Elec',        'in',  'W_net_procO2wsu'}),
    oxyvent_in     = rs({'oxyvent',     'in',  'massflowO2'}),
    oxyprocess_out = rs({'oxyprocess',  'out', 'massflowO2'}),

    Qo2cw1procWSU  = qt({tin = 'To2cp1procwsu_in', hin = 'Qo2cp1procwsu', tout = 'To2cp1procwsu_out', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw2procWSU  = qt({tin = 'To2cp2procwsu_in', hin = 'Qo2cp2procwsu', tout = 'To2cp2procwsu_out', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw3procWSU  = qt({tin = 'To2cp3procwsu_in', hin = 'Qo2cp3procwsu', tout = 'To2cp3procwsu_out', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }

  -- Oxygen booster compressor to export, 1 to 200 bar
  et:addUnit('O2ToExportWSU', {type = 'Utility', Fmin = 0, Fmax = 1000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['O2ToExportWSU']:addStreams {
    elec_in        = rs({'Elec',        'in',  'W_net_exportO2wsu'}),
    oxyvent_in     = rs({'oxyvent',     'in',  'massflowO2'}),
    oxygen_out     = rs({'Oxygen',      'out', 'massflowO2'}),

    Qo2cw1procWSU  = qt({tin = 'To2cp1procwsu_in', hin = 'Qo2cp1procwsu', tout = 'To2cp1procwsu_out', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw2procWSU  = qt({tin = 'To2cp2procwsu_in', hin = 'Qo2cp2procwsu', tout = 'To2cp2procwsu_out', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw3procWSU  = qt({tin = 'To2cp3procwsu_in', hin = 'Qo2cp3procwsu', tout = 'To2cp3procwsu_out', hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw1expWSU   = qt({tin = 'To2cp1expwsu_in',  hin = 'Qo2cp1expwsu',  tout = 'To2cp1expwsu_out',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw2expWSU   = qt({tin = 'To2cp2expwsu_in',  hin = 'Qo2cp2expwsu',  tout = 'To2cp2expwsu_out',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
    Qo2cw3expWSU   = qt({tin = 'To2cp3expwsu_in',  hin = 'Qo2cp3expwsu',  tout = 'To2cp3expwsu_out',  hout = 0, dtmin = 'dtmin_gas', alpha = 1}),
  }


return et
