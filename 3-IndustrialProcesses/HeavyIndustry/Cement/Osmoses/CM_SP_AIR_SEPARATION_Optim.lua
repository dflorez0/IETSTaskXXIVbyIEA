local osmose = require 'osmose'
local et = osmose.Model 'CM_SP_Air_SEPARATION_Optim'

-------------------------------------------------------------------------------
-- Header
-------------------------------------------------------------------------------
et.header = {
  name = 'CM_SP_AIR_SEPARATION_Optim',
  displayName = 'ASU',
  authors = {'Ivan Kantor'},
  developers = {'Korona Power Engineering'},
  contributors = {'Muhammad Salman, ULiege'},  
  creation_date = '',
  updates = {''},
  versions = {'1.1'},
  title = 'Cryogenic air separation unit (ASU)',
  description = [[Simplified model for oxygen production at minimum 95% purity through cryogenic ASU with TSA, for removal of CO2, water vapour and heavy hydrocarbons from the incoming air. The aim is to link the power grid emission factor to the O2 indirect carbon footprint : variations of the former induce changes in the latter.]],
  references = {
    'AIP Conference Proceedings 1573, 1373 (2014); https://doi.org/10.1063/1.4860866 Published Online: 17 February 2015.',
    'Edoardo De Lena, Maurizio Spinelli, Manuele Gatti, Roberto Scaccabarozzi, Stefano Campanari, Stefano Consonni, Giovanni Cinti, Matteo C. Romano, Techno-economic analysis of calcium looping processes for low CO2 emission cement plants,International Journal of Greenhouse Gas Control, Volume 82, 2019, Pages 244-260, ISSN 1750-5836, https://doi.org/10.1016/j.ijggc.2019.01.005.',
    'DECARBONISATION OPTIONS FOR THE DUTCH STEEL INDUSTRY, A. Keys, M. van Hout, B. Daniëls. PBL Netherlands Environmental Assessment Agency, The Hague, 2019.',
    'Carlo N. Hamelinck, André P.C. Faaij, Herman den Uil, Harold Boerrigter, Production of FT transportation fuels from biomass; technical options, process analysis and optimisation, and development potential, Energy, Volume 29, Issue 11, 2004, Pages 1743-1771, ISSN 0360-5442, https://doi.org/10.1016/j.energy.2004.01.002.'
  },
  notes = {'ATTENTION : If the Resource_Oxygen_sell unit in the MARKET is available, this unit produces to furnish it.'}
}
-------------------------------------------------------------------------------
et:addLayers { Electricity = {type = 'ResourceBalance', unit = 'kW' } }
et:addLayers { O2 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Nitrogen = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Compressed_Air = {type = 'ResourceBalance', unit = 'm3/h' } }
et:addLayers { DefaultImpact = {type = 'Costing',  } }
et:addLayers { DefaultHeatCascade = {type = 'HeatCascade',  } }
et:addLayers { DefaultMechPower = {type = 'Costing',  } }
et:addLayers { DefaultOpCost = {type = 'Costing',  } }
et:addLayers { DefaultInvCost = {type = 'Costing',  } }

et:addUnit('ASU',{type = 'Utility', Fmax = 1e9, addToProblem='add_ASU',  Cinv2 = 'Cinv2',Cost2 = 0,sizingStream = 'asu_O2' })
et['ASU']:addStreams{
  asu_elec = rs({ 'Electricity', 'in', "ASU_TOTAL_POWER_IN" }),
  asu_air = rs({ 'Compressed_Air', 'in', "ASU_AIR_IN_VOLF_sz" }),

  asu_O2 = rs({ 'O2', 'out', "ASU_O2_OUT" }),
  asu_N2 = rs({ 'Nitrogen', 'out', "ASU_N2_OUT" }),

  TSA_regeneration = qt{tin = 'T_AMBIENT', hin = 0, tout = 'T_REGEN', hout = 'TSA_REGEN_LP_HEAT_IN', dtmin = 'dtmin'}, -- heat requirement
}

et.inputs = {
  --
  CEM_addNGOxy = {default = 'CEM_addNGOxy', unit = '-'},
  addCement = {default = 'addCement', unit = '-'},
  --
  ASU_AIR_IN_sz = {default = 10000000, unit = 'kg/h'}, -- reference size
  ASU_AIR_IN_VOLF_sz = {default = 10000000/5.8902, unit = 'm3/h'}, -- reference size
  -- RATIO_ASU_TOTAL_POWER_IN = {default = 0.231, unit = 'kWh/kgO2' }, -- for >99% O2 purity : https://doi.org/10.1016/j.ijggc.2013.10.009
  RATIO_ASU_TOTAL_POWER_IN = {default = 0.226, unit = 'kWh/kgO2' }, -- for 95% O2 purity : https://doi.org/10.1016/j.ijggc.2017.10.005 - 0.15 claimed by only https://aip.scitation.org/doi/pdf/10.1063/1.4860866
  RATIO_ASU_O2_OUT = {default = 0.158, unit = 'kg/kg' },
  RATIO_ASU_N2_OUT = {default = 0.685, unit = 'kg/kg' },

  dtmin = {default = 15,unit = 'C'}, -- initially 15, same as dtmin_convection in furnaces
  TSA_REGEN_LP_HEAT_IN_RATIO = {default = 58.3, unit = 'kJ/kgO2' }, -- LP steam for TSA regeneration : https://doi.org/10.1016/j.ijggc.2019.01.005
  T_AMBIENT = {default = 15, unit = 'C'},  -- Tamb = To = Tchemicalreference
  T_REGEN   ={default = 200, unit = 'C'},  -- initial value, https://therootselaargroup.com/en/hadetec/hadetec/products-services/adsorption-dryer-tsa/
  
-- ECONOMIC PARAMETERS
  US_to_EUR                = {default = 0.84, unit = 'EUR/US'},
	Number_year_ws           = {default = 40,      unit = 'year', description = 'Expected investment lifetime'},
	Interest_rate_ws         = {default = 0.06,    unit = '-', description = 'Discount interest rate'},
  CEPCI_2020               = {default = 596.2,    unit = '-', description = 'actual CEPCI'},
  CEPCI_2002               = {default = 395.6,    unit = '-', description = 'CEPCI 2002'},
}

et.outputs = {

  -- add_ASU = { job=function() if (addCement == 1 and (CEM_addNGOxy + CEM_addBGOxy + CEM_addBMOxy + CEM_addCoalOxy + CEM_addMSWOxy + CEM_addHybrid) > 0) then return 1 else return 0 end end},
  add_ASU = { job=function() if (addCement * add_CCSCement ==1) and (add_CPU ==1 or add_CaL==1) then return 1 else return 0 end end},

  ASU_TOTAL_POWER_IN = {unit = 'kWh', job = 'RATIO_ASU_TOTAL_POWER_IN          *ASU_O2_OUT()'},
  ASU_O2_OUT = {unit = 'kg', job = 'RATIO_ASU_O2_OUT                           *ASU_AIR_IN_sz'},
  ASU_N2_OUT = {unit = 'kg', job = 'RATIO_ASU_N2_OUT                           *ASU_AIR_IN_sz'},
  TSA_REGEN_LP_HEAT_IN = {unit = 'kW', job = 'TSA_REGEN_LP_HEAT_IN_RATIO       *ASU_O2_OUT()/3600'},
  --
  Annuity = {unit = '-', job = '(Interest_rate_ws*(Interest_rate_ws+1)^Number_year_ws)/((Interest_rate_ws+1)^Number_year_ws-1)'},
  Cost2   = {unit = 'EUR', job = 'ASU_TOTAL_POWER_IN()*Elec_buy/annual_cap_cement'},
  -- Cinv2   = {unit = 'EUR', job = '27900000*(ASU_O2_OUT()/24000)^(0.6)*CEPCI_2020/CEPCI_2002*Annuity()/annual_cap_cement'},
  Cinv2   = {unit = 'EUR', job = '100e6*(ASU_O2_OUT()/56000)^(0.6)*CEPCI_2020/CEPCI_2002*Annuity()/annual_cap_cement'},
}


return et
