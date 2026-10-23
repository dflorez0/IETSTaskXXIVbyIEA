local osmose = require 'osmose'
local et = osmose.Model 'CM_SP_RAWMILL_DOUBLEROTATOR_Optim'

-------------------------------------------------------------------------------
-- Header
-------------------------------------------------------------------------------
et.header = {
  name = 'CM_SP_RAWMILL_DOUBLEROTATOR_Optim',
  displayName = 'RMDR',
  authors = {'Muhammad Salman, University of Liège', 'Rafailia Mitraki, University of Liège', 'Daniel Flórez-Orrego, EPFL IPESE research group', 'Grégoire Léonard, University of Liège'},
  creation_date = '',
  updates = {''},
  versions = {'1.0'},
  title = 'Raw mill double rotator (RMDR)',
  description = [[Double rotator is used for grinding even the hardest and most abrasive material]],
  references = {},
  notes = {}
}

et:addLayers { linkCEM1 = {type = 'ResourceBalance' } }
et:addLayers { linkCEM2 = {type = 'ResourceBalance' } }
et:addLayers { linkCEM3 = {type = 'ResourceBalance' } }
et:addLayers { linkCEM4 = {type = 'ResourceBalance' } }


et:addLayers { CO2_in_flue_gas = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { CO2_oxy = {type = 'ResourceBalance', unit = 'kg/h' }}

et:addLayers { Sand = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { BF_Slag_Granulated = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Sludge_cement = {type= 'ResourceBalance', unit = 'kg'}}
et:addLayers { DefaultInvCost = {type = 'Costing',  }}
et:addLayers { DefaultMechPower = {type = 'Costing',  }}
et:addLayers { Ckd = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Lig_fly_ash = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { DefaultOpCost = {type = 'Costing',  }}
et:addLayers { Limemeal = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { DefaultImpact = {type = 'Costing',  }}
et:addLayers { Kiln_CO = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Kiln_gas = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Limestone = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Kiln_CO2 = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Atm_Air = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { DefaultHeatCascade = {type = 'HeatCascade',  }}
et:addLayers { Clay = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Rm_mat = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Electricity = {type = 'ResourceBalance', unit = 'kW' }}
et:addLayers { Raw_meal = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Bessemer_Slag = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Moisture_to_exhaustgas = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Coal = {type = 'ResourceBalance', unit = 'kg/h' }}
et:addLayers { Light_fuel_oil = {type = 'ResourceBalance', unit = 'kg/h' }}


et:addUnit('RAWMILL_DOUBLEROTATOR',{type='Utility', Fmin = 0, Fmax = 1000000, addToProblem = 1, Mult = nil, Cost2 = 0, Cinv2 = 0 })
et['RAWMILL_DOUBLEROTATOR']:addStreams{

	------------- IN -------------
	rawmill_sand_IN = rs({ 'Sand', 'in', "DR_SAND_MASSF" }),
	rawmill_oxide_IN = rs({ 'BF_Slag_Granulated', 'in', "DR_GBFS_MASSF" }),
	rawmill_clay_IN = rs({ 'Clay', 'in', "DR_CLAY_MASSF" }),
	rawmill_lmsn_IN = rs({ 'Limestone', 'in', "DR_LMSN_MASSF" }),
  rawmill_sludge_IN = rs ({ 'Sludge_cement', 'in', "DR_SLUDGE_MASSF" }),
	rawmill_totelec_IN = rs({ 'Electricity', 'in', "DR_TOTAL_POWER" }),		

	------------- OUT -------------
	rawmill_prodrm_OUT = rs({ 'Raw_meal', 'out', "DOUBLEROTATOR_RAWMEAL_MASSF" }),
	rawmill_moisture_OUT = rs({'CO2_in_flue_gas', 'out', "DR_MOIST_MASSF"}),

	------------- HEAT -------------
	rawmill_dr_solidsheat_qt1 = qt({tin = "DR_LMSN_T", hin = 0, tout = "DR_RM3_T", hout = "DR_Q1_LOAD", dtmin = 0.0001 }),
	rawmill_dr_solidsheat_qt2 = qt({tin = "DR_RM3_T", hin = 0, tout = "DR_RM4_T", hout = "DR_Q2_LOAD", dtmin = 0.0001 }),
	rawmill_dr_solidsheat_qt3 = qt({tin = "DR_RM4_T", hin = 0, tout = "DR_RM5_T", hout = "DR_Q3_LOAD", dtmin = 0.0001 }),
	rawmill_dr_solidsheat_qt4 = qt({tin = "DR_RM5_T", hin = 0, tout = "DR_RM6_T", hout = "DR_Q4_LOAD", dtmin = 0.0001 }),
	rawmill_dr_solidsheat_qt5 = qt({tin = "DR_RM6_T", hin = 0, tout = "DR_RM7_T", hout = "DR_Q5_LOAD", dtmin = 0.0001 }),
	rawmill_dr_solidsheat_qt6 = qt({tin = "DR_RM7_T", hin = 0, tout = "DR_RM7_T", hout = "DR_Q6_LOAD", dtmin = 0.0001 }),

}

et.inputs = {
	Correction_factor         = {default = 0.10, unit = '-'}, -- average CO2 fraction on flue gas (assumption)
  --
  addCement = {default = 'addCement'},
  --
--  productFlow1 = { default = MC.MILL_CEM_I425R_MASSF, unit = 'kg/h' , },
--  productFlow2 = { default = MC.MILL_CEM_IIBMVLL_MASSF, unit = 'kg/h' , },
--  productFlow3 = { default = MC.MILL_CEM_IIBV325R_MASSF, unit = 'kg/h' , },
--  productFlow4 = { default = MC.MILL_CEM_IIBS425R_MASSF, unit = 'kg/h' , },
--  productFlow5 = { default = MC.MILL_CEM_III425N_MASSF , unit = 'kg/h'},
  
--  DOUBLEROTATOR_RAWMEAL_RATIO1 = {default = 1.43545, unit = 'kg/h' },
--  DOUBLEROTATOR_RAWMEAL_RATIO2 = {default = 1.01237, unit = 'kg/h' },
--  DOUBLEROTATOR_RAWMEAL_RATIO3 = {default = 1.0577, unit = 'kg/h' },
--  DOUBLEROTATOR_RAWMEAL_RATIO4 = {default = 0.98215, unit = 'kg/h' },
--  DOUBLEROTATOR_RAWMEAL_RATIO5 = {default = 0.67995, unit = 'kg/h' },

	DOUBLEROTATOR_RAWMEAL_MASSF = {default = 792000, unit = 'kg/h' },  
	DR_SAND_COMP = {default = 0.05, unit = '-'},
	DR_GBFS_COMP = {default = 0.02, unit = '-' },
	DR_CLAY_COMP = {default = 0.1, unit = '-' },
  	DR_SLUDGE_COMP = {default = 0.02, unit = '-' },
	DR_MOISTURE_MRATIO = {default = 0.056, unit = '-'},

	DR_TOTAL_POWER_RATIO = {default = 0.02, unit = 'kWh/kg'},

	DR_LMSN_T = {default = 18, unit = 'C'},
	DR_RM3_T = {default = 36.66, unit = 'C'},
	DR_RM4_T = {default = 56.10, unit = 'C'},
	DR_RM5_T = {default = 73.15, unit = 'C'},
	DR_RM6_T = {default = 89.86, unit = 'C'},
	DR_RM7_T = {default = 99.5, unit = 'C'},
	DR_PAIR2_T = {default = 18, unit = 'C'},
	DR_PAIR1_T = {default = 150, unit = 'C'},

	DR_RM_CP = {default = 1.06, unit = 'kJ/kg/C'},
	DR_RM_WATER_EVAP = {default = 0.51, unit = 'kWh/kg'},
	DR_RM_RECYCLE_MRATIO = {default = 0.07, unit = '-'}, -- recycle only for doublerotator
 
	------------------
	--- COMBUSTION ---
	------------------
	dtmin_radiation={default = 2,unit = 'C'}, -- initially 2
  	dtmin_convection={default = 15,unit = 'C'}, -- initially 15
  	To = {default = 15, unit = 'C'},  -- Tamb = To = Tchemicalreference
  	MWair={default = 29, unit = 'g/mol'},  -- dry air = 79% N2 + 21% O2 
	losses={default = 0.03, unit = nil}, -- 3% of losses
	cpair = {default=1.068, unit='kJ/kg/K'}, --kJ/kg.K heat capacity @400¡C,1bar
 	Tprin = {default = 500, unit='C'}, -- To+1<=Air preheating temperature < Trad. OBS: Taking the heat for preheating from above the pinch has no net useful effect. Thus, temperature of preheating must be maximum equal to the pinch of the remaining process.
 	AIR_ALPHA = {default = 0.051, unit = 'kW/m^2/K'}, -- from Incropera
  
	Tstack = {default = 55, unit = 'C'},  -- DOUBLEROTATOR_FG_T & same for LFO

-- ECONOMIC PARAMETERS
  US_to_EUR                = {default = 0.84, unit = 'EUR/US'},
	Number_year_ws           = {default = 40,      unit = 'year', description = 'Expected investment lifetime'},
	Interest_rate_ws         = {default = 0.06,    unit = '-', description = 'Discount interest rate'},
  CEPCI_2020               = {default = 596.2,    unit = '-', description = 'actual CEPCI'},
  CEPCI_2014              = {default = 576.1,    unit = '-', description = 'CEPCI 2014'},

}

et.outputs = {
	-- add_RMDR = {job = '1', unit = '-'},


--    DOUBLEROTATOR_RAWMEAL_MASSF1 = {unit = 'kg/h', job ='DOUBLEROTATOR_RAWMEAL_RATIO1*productFlow1'},
  
--  DOUBLEROTATOR_RAWMEAL_MASSF2 = {unit = 'kg/h', job ='DOUBLEROTATOR_RAWMEAL_RATIO2*productFlow2'},
  
--  DOUBLEROTATOR_RAWMEAL_MASSF3 = {unit = 'kg/h', job ='DOUBLEROTATOR_RAWMEAL_RATIO3*productFlow3'},
  
--  DOUBLEROTATOR_RAWMEAL_MASSF4 = {unit = 'kg/h', job ='DOUBLEROTATOR_RAWMEAL_RATIO4*productFlow4'},
  
--  DOUBLEROTATOR_RAWMEAL_MASSF5 = {unit = 'kg/h', job ='DOUBLEROTATOR_RAWMEAL_RATIO5*productFlow5'},
  
--  DOUBLEROTATOR_RAWMEAL_MASSF = {unit = 'kg/h', job ='DOUBLEROTATOR_RAWMEAL_MASSF1()+DOUBLEROTATOR_RAWMEAL_MASSF2()+DOUBLEROTATOR_RAWMEAL_MASSF3()+DOUBLEROTATOR_RAWMEAL_MASSF4()+DOUBLEROTATOR_RAWMEAL_MASSF5()'},
  
  
	DR_SAND_MASSF = {unit = 'kg/h', job = 'DR_SAND_COMP*DOUBLEROTATOR_RAWMEAL_MASSF'},
	DR_GBFS_MASSF = {unit = 'kg/h', job = 'DR_GBFS_COMP*DOUBLEROTATOR_RAWMEAL_MASSF'},
	DR_CLAY_MASSF = {unit = 'kg/h', job = 'DR_CLAY_COMP*DOUBLEROTATOR_RAWMEAL_MASSF'},
	DR_LMSN_MASSF = {unit = 'kg/h', job = 'DR_LMSN_COMP()*DOUBLEROTATOR_RAWMEAL_MASSF'},
  DR_SLUDGE_MASSF = {unit = 'kg/h', job = 'DR_SLUDGE_COMP*DOUBLEROTATOR_RAWMEAL_MASSF'},
	DR_LMSN_COMP = {unit = '-', job = '1 + DR_MOISTURE_MRATIO - (DR_SAND_COMP+DR_SLUDGE_COMP+DR_GBFS_COMP+DR_CLAY_COMP)'},
  
	DR_TOTAL_POWER = {unit = 'kW', job = 'DR_TOTAL_POWER_RATIO*DOUBLEROTATOR_RAWMEAL_MASSF'},

	DR_Q1_LOAD = {unit = 'kW', job = '(DR_RM3_T-DR_LMSN_T)*DR_RM_CP*DOUBLEROTATOR_RAWMEAL_MASSF*(DR_CLAY_COMP+DR_SAND_COMP+DR_LMSN_COMP()+DR_GBFS_COMP+DR_RM_RECYCLE_MRATIO)/3600'},
	DR_Q2_LOAD = {unit = 'kW', job = '(DR_RM4_T-DR_RM3_T)*DR_RM_CP*DOUBLEROTATOR_RAWMEAL_MASSF*(DR_CLAY_COMP+DR_SAND_COMP+DR_LMSN_COMP()+DR_GBFS_COMP+DR_RM_RECYCLE_MRATIO)/3600'},
	DR_Q3_LOAD = {unit = 'kW', job = '(DR_RM5_T-DR_RM4_T)*DR_RM_CP*DOUBLEROTATOR_RAWMEAL_MASSF*(DR_CLAY_COMP+DR_SAND_COMP+DR_LMSN_COMP()+DR_GBFS_COMP+DR_RM_RECYCLE_MRATIO)/3600'},
	DR_Q4_LOAD = {unit = 'kW', job = '(DR_RM6_T-DR_RM5_T)*DR_RM_CP*DOUBLEROTATOR_RAWMEAL_MASSF*(DR_CLAY_COMP+DR_SAND_COMP+DR_LMSN_COMP()+DR_GBFS_COMP+DR_RM_RECYCLE_MRATIO)/3600'},
	DR_Q5_LOAD = {unit = 'kW', job = '(DR_RM7_T-DR_RM6_T)*DR_RM_CP*DOUBLEROTATOR_RAWMEAL_MASSF*(DR_CLAY_COMP+DR_SAND_COMP+DR_LMSN_COMP()+DR_GBFS_COMP+DR_RM_RECYCLE_MRATIO)/3600'},
	DR_Q6_LOAD = {unit = 'kW', job = 'DR_RM_WATER_EVAP*DR_MOIST_MASSF()'},
	DR_MOIST_MASSF = {unit = 'kg/h', job = 'Correction_factor*DOUBLEROTATOR_RAWMEAL_MASSF*DR_MOISTURE_MRATIO'},	

    -- COST
  Annuity = {unit = '-', job = '(Interest_rate_ws*(Interest_rate_ws+1)^Number_year_ws)/((Interest_rate_ws+1)^Number_year_ws-1)'},
  Cost2DR = {unit = '-', job = 'DR_TOTAL_POWER()*Elec_buy/annual_cap_cement'},
  Cinv2_DOUBLEROT   = {unit = 'EUR', job = '(39406249*US_to_EUR)*(DOUBLEROTATOR_RAWMEAL_MASSF/(41.67*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
}

return et
