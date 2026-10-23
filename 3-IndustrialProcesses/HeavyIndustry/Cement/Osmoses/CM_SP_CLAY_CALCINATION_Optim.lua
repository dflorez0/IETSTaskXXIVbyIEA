local osmose = require 'osmose'
local et = osmose.Model 'CM_SP_CLAY_CALCINATION_Optim'

-------------------------------------------------------------------------------
-- Header
-------------------------------------------------------------------------------
et.header = {
  name = 'CM_SP_CLAY_CALCINATION_Optim',
  displayName = 'KCC',
  authors = {'Muhammad Salman, University of Liège', 'Rafailia Mitraki, University of Liège', 'Daniel Flórez-Orrego, EPFL IPESE research group', 'Grégoire Léonard, University of Liège'},
  developers = {''},
  contributors = {''},
  creation_date = '',
  updates = {''},
  versions = {'1.0'},
  title = 'Kaolinite clay calcination (KCC)',
  description = [[Calcined clay: supplementary cementitious materials (SCM) to substitute part of the CO2-intensive cement clinker.]],
  references = {
    'Canut M., Miller S., Jolnæs M. (2020) Calcined Clay: Process Impact on the Reactivity and Color. In: Bishnoi S. (eds) Calcined Clays for Sustainable Concrete. RILEM Bookseries, vol 25. Springer, Singapore. https://doi.org/10.1007/978-981-15-2806-4_19.',
  'Roger S. Almenares, Leng M. Vizcaíno, Salvador Damas, Antoni Mathieu, Adrian Alujas, Fernando Martirena. Industrial calcination of kaolinitic clays to make reactive pozzolans, Case Studies in Construction Materials, Volume 6, 2017, Pages 225-232, ISSN 2214-5095, https://doi.org/10.1016/j.cscm.2017.03.005.',
  'Abraham Teklay, Chungen Yin, Lasse Rosendahl, Martin Bøjer, Calcination of kaolinite clay particles for cement production: A modeling study, Cement and Concrete Research, Volumes 61–62, 2014, Pages 11-19, ISSN 0008-8846, https://doi.org/10.1016/j.cemconres.2014.04.002.'},
  notes = {'Different calcination modes exist, e.g. Rotary kiln (soak calcination) and Flash gas suspension calciner. The latter is chosen for this model, as its product presents clinker subsitution rate of 30-40% (due to significantly higher reactivity of the calcined clay with cement), whereas the soak calcination product can only substitute 15-25%. Other advantages are no grinding requirement required after the calciner, and reduced CAPEX by 75% w.r.t. the rotary kiln option.The calcination step involves mainly 2 reactions : drying of the clay (at around 100°C), and metakaolin reaction between 400 and 600°C, producing water (gaseous) as by-product.'}
}


-------------------------------------------------------------------------------

et:addLayers { Electricity = {type = 'ResourceBalance', unit = 'kW' } }
et:addLayers { Clay = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Calcined_clay = {type = 'ResourceBalance', unit = 'kg/h' } }

et:addLayers { DefaultImpact = {type = 'Costing',  } }
et:addLayers { DefaultHeatCascade = {type = 'HeatCascade',  } }
et:addLayers { DefaultMechPower = {type = 'Costing',  } }
et:addLayers { DefaultOpCost = {type = 'Costing',  } }
et:addLayers { DefaultInvCost = {type = 'Costing',  } }


-- This ET includes all treatment steps as developed in the Flash calcination process from FLSmidth
et:addUnit('CLAY_CALICINER',{type = 'Utility', Fmax = 1000, addToProblem = 'add_ClayCal',  Cinv2 = 'Cinv2_ClayCal' })
et['CLAY_CALICINER']:addStreams{
	cca_elec_in = rs({ 'Electricity', 'in', "CCa_TOTAL_POWER" }), -- for pretreatment grinding
	cca_clay_IN = rs({ 'Clay', 'in', "CCa_CLAY_IN_sz" }),

  cca_calc_clay_OUT = rs({ 'Calcined_clay', 'out', "CCa_CALC_CLAY_OUT" }),

	cca_heating_clay = qt({tin = "CCa_FEED_T", hin = 0, tout = "CCa_CALC_T", hout = "CCa_HEATING_LOAD", dtmin = "CCa_dtmin"}),
	cca_calcination_heat = qt({tin = "CCa_CALC_T", hin = 0, tout = "CCa_CALC_T", hout = "CCa_CALC_HEAT", dtmin = "CCa_dtmin" }),
	cca_MKaol_cooling = qt({tin = "CCa_cooler_T_IN", hin = "CCa_CALC_COOLING", tout = "CCa_cooler_T_OUT", hout = 0, dtmin = "CCa_dtmin_cooler" }),
	cca_steam_cooling = qt({tin = "CCa_CALC_T", hin = "CCa_STEAM_COOLING", tout = "H2O_vaporization_T", hout = 0, dtmin = "CCa_dtmin_aircooler" }),
}

et.inputs = {
    --
add_ClayCal  = {default = 0, unit = '-'},
  --
  CCa_dtmin = {default = 200, unit = 'C' }, -- initial value set, taken because minimal dtmin in kilns heat layers
  CCa_dtmin_cooler = {default = 50, unit = 'C' }, -- initial value set, same as in clinker cooling unit
  CCa_dtmin_aircooler = {default = 10, unit = 'C' }, -- initial value set, same as in clinker cooling unit
  CP_clay = {default = 0.878, unit = 'kJ/kg/C'}, -- https://theengineeringmindset.com/specific-heat-capacity-of-materials/
  CP_MKaol = {default = 1, unit = 'kJ/kg/C'}, -- https://www.sciencedirect.com/science/article/pii/S0955221908001970?via%3Dihub
  MW_clay = {default = 258.16, unit = 'kg/kmol' }, -- kaolinite molar weight
  CP_water_l = {default = 4.19, unit = 'kJ/kg/C'},
  AE_H2O_vaporization = {default = 2260, unit = 'kJ/kg'},
  CP_water_g = {default = 2.1, unit = 'kJ/kg/C'}, -- average over T° range 100 to 800°C
  H2O_vaporization_T = {default = 100, unit = 'C' }, 


  CCa_CLAY_IN_sz = {default = 100000, unit = 'kg/h' }, -- reference size
  CCa_TOTAL_POWER_RATIO = {default = 0.017, unit = 'kWh/kg' },

  CCa_FEED_T ={default = 15, unit = '°C' }, -- ambiant T°
  CCa_CALC_T ={default = 800, unit = '°C' }, -- calciner T°

  AE_dehydroxylation = {default = 130, unit = 'MJ/kmol' }, -- https://www.sciencedirect.com/science/article/pii/S0169131713002226#bb0170

  CCa_cooler_T_IN ={default = 750, unit = '°C' }, -- calcined clay T°, slightly decreased as losses
  CCa_cooler_T_OUT  ={default = 98.75, unit = '°C' }, -- same T° as KILNCC_CLINKER_T, fed to the cement mill

  moist_ratio_clay = {default = 0.035, unit = 'kg/kg' }, -- as in Ecoinvent database
  MKaol_product_ratio = {default = 0.86, unit = 'kg/kg' }, -- kg metakaolinite per kg kaolinite clay : chemical reaction : kaolinite -> metakaolinite+2*H2O
  
  -- ECONOMIC PARAMETERS
  US_to_EUR                = {default = 0.84, unit = 'EUR/US'},
	Number_year_ws           = {default = 40,      unit = 'year', description = 'Expected investment lifetime'},
	Interest_rate_ws         = {default = 0.06,    unit = '-', description = 'Discount interest rate'},
  CEPCI_2020               = {default = 596.2,    unit = '-', description = 'actual CEPCI'},
  CEPCI_2019               = {default = 607.5,    unit = '-', description = 'CEPCI 2014'},
}

et.outputs = {
  moist_HEATING_LOAD = {unit = 'kW', job = '((H2O_vaporization_T - CCa_FEED_T)*CP_water_l + AE_H2O_vaporization +(CCa_CALC_T - H2O_vaporization_T)*CP_water_g)*CCa_CLAY_IN_sz*moist_ratio_clay/3600'},
  CCa_HEATING_LOAD = {unit = 'kW', job = '(CCa_CALC_T - CCa_FEED_T)*CP_clay*CCa_CLAY_IN_sz*(1-moist_ratio_clay)/3600  + moist_HEATING_LOAD() '},
  CCa_CALC_HEAT = {unit = 'kW', job = 'AE_dehydroxylation/MW_clay  *CCa_CLAY_IN_sz*(1-moist_ratio_clay)/3.6'}, -- endothermic reaction of kaolinite dehydroxylation
  CCa_CALC_COOLING = {unit = 'kW', job = '(CCa_cooler_T_IN - CCa_cooler_T_OUT)*CP_MKaol/3600   *CCa_CALC_CLAY_OUT()'}, -- available heat from metakaolinite cooling
  CCa_STEAM_COOLING = {unit = 'kW', job = '(CCa_CALC_T - H2O_vaporization_T)*CP_water_g/3600   *CCa_CLAY_IN_sz*moist_ratio_clay'}, -- available heat from generated steam

  CCa_TOTAL_POWER = {unit = 'kWh', job = 'CCa_CLAY_IN_sz*CCa_TOTAL_POWER_RATIO'},

  CCa_steam_OUT = {unit = 'kg', job = 'CCa_CLAY_IN_sz*(1-moist_ratio_clay)*(1-MKaol_product_ratio) + CCa_CLAY_IN_sz*moist_ratio_clay'},
  CCa_CALC_CLAY_OUT = {unit = 'kg', job = 'CCa_CLAY_IN_sz*(1-moist_ratio_clay)*MKaol_product_ratio'},
  
  -- COST
  Annuity = {unit = '-', job = '(Interest_rate_ws*(Interest_rate_ws+1)^Number_year_ws)/((Interest_rate_ws+1)^Number_year_ws-1)'},
  Cinv2_ClayCal   = {unit = 'EUR', job = '(10300000*US_to_EUR)*(CCa_CLAY_IN_sz/(34247))^(0.6)*CEPCI_2020/CEPCI_2019*Annuity()/annual_cap_cement'},
}


return et
