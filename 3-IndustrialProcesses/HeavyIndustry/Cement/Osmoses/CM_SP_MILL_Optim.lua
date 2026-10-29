local osmose = require 'osmose'
local et = osmose.Model 'CM_SP_MILL_Optim'

et.header = {
  name = 'CM_SP_MILL_Optim',
  displayName = 'Mill',
  authors = {'Muhammad Salman, University of Liège', 'Rafailia Mitraki, University of Liège', 'Daniel Flórez-Orrego, EPFL IPESE research group', 'Grégoire Léonard, University of Liège'},
  versions = {'2.0'},
  title = 'Mill',
  description = [[Model for the cement mill, with 6 different products (CEM I, CEM II/B-W, CEM II/B-S, CEM II/B-LL, CEM III/A and LC3) and a common feed]],
}

et:addLayers { millprod2_mix = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Sand = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { BF_Slag_Granulated = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { R_Shale = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Industrial_Water = {type = 'ResourceBalance', unit = 'm3/h' } }
et:addLayers { Clinker = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Fly_ash = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Lig_fly_ash = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { CementProduct3 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { CementProduct2 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { E_Clinker = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { CementProduct1 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { millprod5_mix = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { millprod4_mix = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { millprod1_mix = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Limestone = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { CementProduct4 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { G_Aid = {type = 'ResourceBalance', unit = 'm3/h' } }
et:addLayers { Scrap_Gyps = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { millprod3_mix = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Gyps = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { CementProduct5 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Elec = {type = 'ResourceBalance', unit = 'kW' } }
et:addLayers { FBC_ash = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Bessemer_Slag = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { CementProduct6 = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { millprod6_mix = {type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Calcined_clay = {type = 'ResourceBalance', unit = 'kg/h' } }

et:addLayers { DefaultInvCost = {type = 'Costing',  } }
et:addLayers { DefaultHeatCascade = {type = 'HeatCascade',  } }
et:addLayers { DefaultImpact = {type = 'Costing',  } }
et:addLayers { DefaultMechPower = {type = 'Costing',  } }
et:addLayers { DefaultOpCost = {type = 'Costing',  } }

-- CEM 1 (Holcim - CEM1) --------------------------------
et:addUnit('Mill_CEMPROD1_FEED',{type = 'Utility', Fmax = 1000000, addToProblem = 1, Mult = nil })
et['Mill_CEMPROD1_FEED']:addStreams{
	millprod1_gyps_IN = rs({ 'Gyps', 'in', "MILL_CEMPROD1_GYPSUM_MASSF" }),
	millprod1_rmat = rs({ 'millprod1_mix', 'out', "MILL_CEMPROD1_MASSF" }),
	millprod1_scrap_gyps_IN = rs({ 'Scrap_Gyps', 'in', "MILL_CEMPROD1_SCRAP_GYPSUM_MASSF" }),
	millprod1_clk_IN = rs({ 'Clinker', 'in', "MILL_CEMPROD1_CLINKER_MASSF" }),
}
et:addUnit('Mill_CEMPROD1',{type = 'Utility', Fmax = 10000000, addToProblem = 1, Cost2 = 0, Cinv2 = 0 })
et['Mill_CEMPROD1']:addStreams{
	millprod1_gaid_IN = rs({ 'G_Aid', 'in', "MILL_CEMPROD1_GAID_VOLF" }),
	millprod1_rm_IN = rs({ 'millprod1_mix', 'in', "MILL_CEMPROD1_MASSF" }),
	millprod1_elec_IN = rs({ 'Elec', 'in', "MILL_CEMPROD1_POWER" }),
	millprod1_h2o_IN = rs({ 'Industrial_Water', 'in', "MILL_CEMPROD1_H2O_VOLF" }),
	millprod1_OUT = rs({ 'CementProduct1', 'out', "MILL_CEMPROD1_MASSF" }),
}
-- CEM 2 (Holcim - CEM II/B-W) --------------------------------
et:addUnit('Mill_CEMPROD2_FEED',{type = 'Utility', Fmax = 10000000, addToProblem = 1, Mult = nil})
et['Mill_CEMPROD2_FEED']:addStreams{
	millprod2_fash_IN = rs({ 'Fly_ash', 'in', "MILL_CEMPROD2_FASH_MASSF" }),
	millprod2_gyps_IN = rs({ 'Gyps', 'in', "MILL_CEMPROD2_GYPSUM_MASSF" }),
	millprod2_clk_IN = rs({ 'Clinker', 'in', "MILL_CEMPROD2_CLINKER_MASSF" }),
	millprod2_scrap_IN = rs({ 'Scrap_Gyps', 'in', "MILL_CEMPROD2_SCRAP_GYPSUM_MASSF" }),
	millprod2_rmat = rs({ 'millprod2_mix', 'out', "MILL_CEMPROD2_MASSF" }),
}
et:addUnit('Mill_CEMPROD2',{type = 'Utility', Fmax = 10000000, addToProblem = 1, Mult = nil, Cost2 = 0, Cinv2 = 0 })
et['Mill_CEMPROD2']:addStreams{
	millprod2_cem_OUT = rs({ 'CementProduct2', 'out', "MILL_CEMPROD2_MASSF" }),
	millprod2_rm_IN = rs({ 'millprod2_mix', 'in', "MILL_CEMPROD2_MASSF" }),
	millprod2_h2o_IN = rs({ 'Industrial_Water', 'in', "MILL_CEMPROD2_H2O_VOLF" }),
	millprod2_elec_IN = rs({ 'Elec', 'in', "MILL_CEMPROD2_POWER" }),
	millprod2_gaid_IN = rs({ 'G_Aid', 'in', "MILL_CEMPROD2_GAID_VOLF" }),
}
-- CEM 3 (Holcim - CEM II/B-S) --------------------------------
et:addUnit('Mill_CEMPROD3_FEED',{type = 'Utility', Fmax = 1, addToProblem = 1, Mult = nil,})
et['Mill_CEMPROD3_FEED']:addStreams{
	millprod3_clk_IN = rs({ 'Clinker', 'in', "MILL_CEMPROD3_CLINKER_MASSF" }),
	millprod3_rmat = rs({ 'millprod3_mix', 'out', "MILL_CEMPROD3_MASSF" }),
	millprod3_gbfs_IN = rs({ 'BF_Slag_Granulated', 'in', "MILL_CEMPROD3_GBFS_MASSF" }),
	millprod3_fash_IN = rs({ 'Fly_ash', 'in', "MILL_CEMPROD3_FASH_MASSF" }),
	millprod3_fbc_IN = rs({ 'FBC_ash', 'in', "MILL_CEMPROD3_FBCASH_MASSF" }),
}
et:addUnit('Mill_CEMPROD3',{type = 'Utility', Fmax = 1, addToProblem = 1, Mult = nil, Cost2 = 0, Cinv2 = 0 })
et['Mill_CEMPROD3']:addStreams{
	millprod3_rm_IN = rs({ 'millprod3_mix', 'in', "MILL_CEMPROD3_MASSF" }),
	millprod3_elec_IN = rs({ 'Elec', 'in', "MILL_CEMPROD3_POWER" }),
	millprod3_OUT = rs({ 'CementProduct3', 'out', "MILL_CEMPROD3_MASSF" }),
	millprod3_h2o_IN = rs({ 'Industrial_Water', 'in', "MILL_CEMPROD3_H2O_VOLF" }),
	millprod3_gaid_IN = rs({ 'G_Aid', 'in', "MILL_CEMPROD3_GAID_VOLF" }),
}
-- CEM 4 (Holcim - CEM II/B-LL) --------------------------------
et:addUnit('Mill_CEMPROD4_FEED',{type = 'Utility', Fmax = 1, addToProblem = 1, Mult = nil })
et['Mill_CEMPROD4_FEED']:addStreams{
	millprod4_clk_IN = rs({ 'Clinker', 'in', "MILL_CEMPROD4_CLINKER_MASSF" }),
	millprod4_lmsn_IN = rs({ 'Limestone', 'in', "MILL_CEMPROD4_LMSN_MASSF" }),
	millprod4_gyps_IN = rs({ 'Gyps', 'in', "MILL_CEMPROD4_GYPSUM_MASSF" }),
	millprod4_scrap_gyps_IN = rs({ 'Scrap_Gyps', 'in', "MILL_CEMPROD4_SCRAP_GYPSUM_MASSF" }),
	millprod4_rmat = rs({ 'millprod4_mix', 'out', "MILL_CEMPROD4_MASSF" }),
}
et:addUnit('Mill_CEMPROD4',{type = 'Utility', Fmax = 1, addToProblem = 1, Cost2 = 0, Mult = nil, Cinv2 = 0})
et['Mill_CEMPROD4']:addStreams{
	millprod4_elec_IN = rs({ 'Elec', 'in', "MILL_CEMPROD4_POWER" }),
	millprod4_gaid_IN = rs({ 'G_Aid', 'in', "MILL_CEMPROD4_GAID_VOLF" }),
	millprod4_rm_IN = rs({ 'millprod4_mix', 'in', "MILL_CEMPROD4_MASSF" }),
	millprod4_cem_OUT = rs({ 'CementProduct4', 'out', "MILL_CEMPROD4_MASSF" }),
	millprod4_h2o_IN = rs({ 'Industrial_Water', 'in', "MILL_CEMPROD4_H2O_VOLF" }),
}
-- CEM 5 (Holcim - CEM III/A) --------------------------------
et:addUnit('Mill_CEMPROD5_FEED',{type = 'Utility', Fmax = 1, addToProblem = 1, Mult = nil })
et['Mill_CEMPROD5_FEED']:addStreams{
	millprod5_gyps_IN = rs({ 'Gyps', 'in', "MILL_CEMPROD5_GYPSUM_MASSF" }),
	millprod5_rmat = rs({ 'millprod5_mix', 'out', "MILL_CEMPROD5_MASSF" }),
	millprod5_clk_IN = rs({ 'Clinker', 'in', "MILL_CEMPROD5_CLINKER_MASSF" }),
	millprod5_scrap_gyps_IN = rs({ 'Scrap_Gyps', 'in', "MILL_CEMPROD5_SCRAP_GYPSUM_MASSF" }),
	millprod5_gbfs_IN = rs({ 'BF_Slag_Granulated', 'in', "MILL_CEMPROD5_GBFS_MASSF" }),
	millprod5_fbc_IN = rs({ 'FBC_ash', 'in', "MILL_CEMPROD5_FBCASH_MASSF" }),
}
et:addUnit('Mill_CEMPROD5',{type = 'Utility', Fmax = 1, addToProblem = 1, Mult = nil, Cost2 = 0, Cinv2 = 0})
et['Mill_CEMPROD5']:addStreams{
	millprod5_gaid_IN = rs({ 'G_Aid', 'in', "MILL_CEMPROD5_GAID_VOLF" }),
	millprod5_elec_IN = rs({ 'Elec', 'in', "MILL_CEMPROD5_POWER" }),
	millprod5_rm_IN = rs({ 'millprod5_mix', 'in', "MILL_CEMPROD5_MASSF" }),
	millprod5_h2o_IN = rs({ 'Industrial_Water', 'in', "MILL_CEMPROD5_H2O_VOLF" }),
	millprod5_OUT = rs({ 'CementProduct5', 'out', "MILL_CEMPROD5_MASSF" }),
}
-- CEM 6 --------------------------------
et:addUnit('Mill_CEMPROD6_FEED',{type = 'Utility', Fmax = 1000000, addToProblem = 1})
et['Mill_CEMPROD6_FEED']:addStreams{
	millprod6_gyps_IN = rs({ 'Gyps', 'in', "MILL_CEMPROD6_GYPSUM_MASSF" }),
	millprod6_rmat = rs({ 'millprod6_mix', 'out', "MILL_CEMPROD6_MASSF" }),
	millprod6_clk_IN = rs({'Clinker', 'in', "MILL_CEMPROD6_CLINKER_MASSF" }),
	millprod6_calc_clay_IN = rs({ 'Calcined_clay', 'in', "MILL_CEMPROD6_CALCINED_CLAY_MASSF" }),
	millprod6_lmsn_IN = rs({ 'Limestone', 'in', "MILL_CEMPROD6_LMSN_MASSF" }),
}
et:addUnit('Mill_CEMPROD6',{type = 'Utility', Fmax = 1000000, addToProblem = 1,  Mult = nil, Cost2 = 0, Cinv2 =0})
et['Mill_CEMPROD6']:addStreams{
	millprod6_rm_IN = rs({ 'millprod6_mix', 'in', "MILL_CEMPROD6_MASSF" }),
	millprod6_elec_IN = rs({ 'Elec', 'in', "MILL_CEMPROD6_POWER" }),
	millprod6_OUT = rs({ 'CementProduct6', 'out', "MILL_CEMPROD6_MASSF" }),
	millprod6_h2o_IN = rs({ 'Industrial_Water', 'in', "MILL_CEMPROD6_H2O_VOLF" }),
	millprod6_gaid_IN = rs({ 'G_Aid', 'in', "MILL_CEMPROD6_GAID_VOLF" }),
}


et.inputs = {
 add_CEM1    = {default = 0, unit = '-' },
 add_CEM2    = {default = 0, unit = '-' },
 add_CEM3    = {default = 0, unit = '-' },
 add_CEM4    = {default = 0, unit = '-' },
 add_CEM5    = {default = 0, unit = '-' },
 add_CEM6    = {default = 0, unit = '-' },
  
 MILL_CEMPROD1_D80                       ={default = 35, unit = 'um' },
 MILL_CEMPROD1_SP_GAID                   ={default = 0.000000054, unit = 'm3/kg' },
 MILL_CEMPROD1_SP_H2O                    ={default = 5.1e-05, unit = 'm3/kg' },
 MILL_CEMPROD1_FEED_D80                  ={default = 5800, unit = '' },
 CEMPROD1_CLINKER_RATIO                  ={default = 0.95, unit = '' },
 CEMPROD1_GYPSUM_RATIO                   ={default = 0.05, unit = '' },
 MILL_CEMPROD1_MASSF                     ={default = 450000, unit = 'kg/h' },
 MILL_CEMPROD1_BINARY                    ={default = 1, unit = '' },
 MILL_CEMPROD1_MASSF_MAX                 ={default = 450000, unit = 'kg/h' },
 cem1a                                   ={default = -0.000455, unit = '' },
 cem1b                                   ={default = 0.0088, unit = '' },
 cem1c                                   ={default = 402000000, unit = '' },
 cem1e                                   ={default = 0.623, unit = '' },
 Wi_CEMI                                 ={default = 15.9, unit = '' },

 MILL_CEMPROD2_SP_GAID                   ={default = 0.000000054, unit = 'm3/kg' },
 MILL_CEMPROD2_BINARY                    ={default = 0, unit = '' },
 CEMPROD2_GYPSUM_RATIO                   ={default = 0.05, unit = '' },
 MILL_CEMPROD2_FEED_D80                  ={default = 3100, unit = '' },
 MILL_CEMPROD2_D80                       ={default = 35, unit = 'um' },
 MILL_CEMPROD2_SP_H2O                    ={default = 4.8e-05, unit = 'm3/kg' },
 CEMPROD2_CLINKER_RATIO                  ={default = 0.7, unit = '' },
 CEMPROD2_FASH_RATIO                     ={default = 0.25, unit = '' },
 MILL_CEMPROD2_MASSF                     ={default = 450000, unit = 'kg/h' },
 cem2a                                   ={default = 1.35e-05, unit = '' },
 cem2b                                   ={default = 0.00386, unit = '' },
 cem2c                                   ={default = -7800000000, unit = '' },
 cem2e                                   ={default = 0.0968, unit = '' },
 Wi_CEMII                                ={default = 16.2, unit = '' },

 MILL_CEMPROD3_FEED_D80                  ={default = 3500, unit = '' },
 CEMPROD3_FASH_RATIO                     ={default = 0.05, unit = '' },
 MILL_CEMPROD3_SP_GAID                   ={default = 0.000000054, unit = 'm3/kg' },
 CEMPROD3_FBCASH_RATIO                   ={default = 0.05, unit = '' },
 MILL_CEMPROD3_MASSF_MAX                 ={default = 450000, unit = 'kg/h' },
 MILL_CEMPROD3_SP_H2O                    ={default = 4.8e-05, unit = 'm3/kg' },
 MILL_CEMPROD3_D80                       ={default = 36, unit = 'um' },
 MILL_CEMPROD3_MASSF                     ={default = 450000, unit = 'kg/h' },
 CEMPROD3_GBFS_RATIO                     ={default = 0.25, unit = '' },
 CEMPROD3_CLINKER_RATIO                  ={default = 0.65, unit = '' },
 MILL_CEMPROD3_BINARY                    ={default = 0, unit = '' },
 cem3a                                   ={default = 1.35e-05, unit = '' },
 cem3b                                   ={default = 0.00386, unit = '' },
 cem3c                                   ={default = -7800000000, unit = '' },
 cem3e                                   ={default = 0.0968, unit = '' },
 Wi_CEMIII                               ={default = 16.4, unit = '' },

 MILL_CEMPROD4_FEED_D80                  ={default = 3500, unit = '' },
 MILL_CEMPROD4_D80                       ={default = 36, unit = 'um' },
 MILL_CEMPROD4_SP_GAID                   ={default = 0.000000054, unit = 'm3/kg' },
 CEMPROD4_LMSN_RATIO                     ={default = 0.25, unit = '' },
 CEMPROD4_CLINKER_RATIO                  ={default = 0.67, unit = '' },
 MILL_CEMPROD4_MASSF                     ={default = 450000, unit = 'kg/h' },
 CEMPROD4_GYPSUM_RATIO                   ={default = 0.08, unit = '' },
 MILL_CEMPROD4_BINARY                    ={default = 0, unit = '' },
 MILL_CEMPROD4_SP_H2O                    ={default = 4.8e-05, unit = 'm3/kg' },
 cem4a                                   ={default = 1.35e-05, unit = '' },
 cem4b                                   ={default = 0.00386, unit = '' },
 cem4c                                   ={default = -7800000000, unit = '' },
 cem4e                                   ={default = 0.0968, unit = '' },

 CEMPROD5_FBCASH_RATIO                   ={default = 0.02, unit = '' },
 cem5a                                   ={default = 0.00044, unit = '' },
 cem5b                                   ={default = 0.0104, unit = '' },
 cem5c                                   ={default = 154000, unit = '' },
 cem5e                                   ={default = 0.689, unit = '' },
 MILL_CEMPROD5_BINARY                    ={default = 0, unit = '' },
 MILL_CEMPROD5_SP_H2O                    ={default = 5.5e-05, unit = 'm3/kg' },
 MILL_CEMPROD5_FEED_D80                  ={default = 3100, unit = '' },
 CEMPROD5_GYPSUM_RATIO                   ={default = 0.08, unit = '' },
 CEMPROD5_GBFS_RATIO                     ={default = 0.45, unit = '' },
 CEMPROD5_CLINKER_RATIO                  ={default = 0.45, unit = '' },
 MILL_CEMPROD5_D80                       ={default = 35, unit = 'um' },
 MILL_CEMPROD5_MASSF                     ={default = 450000, unit = 'kg/h'},
 MILL_CEMPROD5_MASSF_MAX                 ={default = 450000, unit = 'kg/h' },
 MILL_CEMPROD5_SP_GAID                   ={default = 0.000000054, unit = 'm3/kg' },

 -- LC3 cement - reference : Karen Scrivener et al. Calcined clay limestone cements (LC3) : EPFL, 2017.
 RATIO_MILL_CEMPROD6_GYPSUM_MASSF        ={default = 0.05, unit = '' },
 RATIO_MILL_CEMPROD6_CLINKER_MASSF       ={default = 0.50, unit = '' },
 RATIO_MILL_CEMPROD6_CALCINED_CLAY_MASSF ={default = 0.30, unit = '' },
 RATIO_MILL_CEMPROD6_LMSN_MASSF          ={default = 0.15, unit = '' },
 MILL_CEMPROD6_MASSF                     ={default = 450000, unit = 'kg/h' },
 MILL_CEMPROD6_SP_H2O                    ={default = 4.8e-05, unit = 'm3/kg' }, -- same as product 2, 3 and 4 for now
 MILL_CEMPROD6_SP_GAID                   ={default = 0.000000054, unit = 'm3/kg' }, -- same as all other cement products

 GLOBAL_SCRAP_GYPSUM_RATIO               ={default = 0.2, unit = '' },
 
-- ECONOMIC PARAMETERS
  US_to_EUR                = {default = 0.84, unit = 'EUR/US'},
	Number_year_ws           = {default = 40,      unit = 'year', description = 'Expected investment lifetime'},
	Interest_rate_ws         = {default = 0.06,    unit = '-', description = 'Discount interest rate'},
  CEPCI_2020               = {default = 596.2,    unit = '-', description = 'actual CEPCI'},
  CEPCI_2014               = {default = 576.1,    unit = '-', description = 'CEPCI 2014'},
}

et.outputs = {
	MILL_CEMPROD4_POWER ={unit = 'kW', job = "MILL_SP_CEMPROD4_POWER()*MILL_CEMPROD4_MASSF" },
	MILL_SP_CEMPROD4_POWER_COARSE ={unit = 'kWh/kg', job = "4*Wi_CEMII*cem4a*(750^(-(cem4e+750/cem4c))-MILL_CEMPROD4_FEED_D80^(-(cem4e+MILL_CEMPROD4_FEED_D80/cem4c)))" },
	MILL_CEMPROD3_CLINKER_MASSF ={unit = 'kg/h', job = "CEMPROD3_CLINKER_RATIO*MILL_CEMPROD3_MASSF" },
	MILL_CEMPROD3_GBFS_MASSF ={unit = 'kg/h', job = "CEMPROD3_GBFS_RATIO*MILL_CEMPROD3_MASSF" },
	MILL_CEMPROD3_FASH_MASSF ={unit = 'kg/h', job = "CEMPROD3_FASH_RATIO*MILL_CEMPROD3_MASSF" },
	MILL_SP_CEMPROD1_POWER_FINE ={unit = 'kWh/kg', job = "4*Wi_CEMI*cem1b*(MILL_CEMPROD1_D80^(-(cem1e+MILL_CEMPROD1_D80/cem1c))-750^(-(cem1e+750/cem1c)))" },
	MILL_CEMPROD1_SCRAP_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD1_SCRAP_GYPSUM_RATIO()*MILL_CEMPROD1_MASSF" },
	MILL_CEMPROD4_CLINKER_MASSF ={unit = 'kg/h', job = "CEMPROD4_CLINKER_RATIO*MILL_CEMPROD4_MASSF" },
	MILL_CEMPROD5_GAID_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD5_SP_GAID*MILL_CEMPROD5_MASSF" },
	CEMPROD5_SCRAP_GYPSUM_RATIO ={unit = '-', job = "CEMPROD5_GYPSUM_RATIO*GLOBAL_SCRAP_GYPSUM_RATIO" },
	MILL_SP_CEMPROD2_POWER_FINE ={unit = 'kWh/kg', job = "4*Wi_CEMII*cem2b*(MILL_CEMPROD2_D80^(-(cem2e+MILL_CEMPROD2_D80/cem2c))-750^(-(cem2e+750/cem2c)))" },
	CEMPROD5_NATURAL_GYPSUM_RATIO ={unit = '-', job = "CEMPROD5_GYPSUM_RATIO*(1-GLOBAL_SCRAP_GYPSUM_RATIO)" },
	CEMPROD4_SCRAP_GYPSUM_RATIO ={unit = '-', job = "CEMPROD4_GYPSUM_RATIO*GLOBAL_SCRAP_GYPSUM_RATIO" },
	MILL_CEMPROD5_H2O_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD5_SP_H2O*MILL_CEMPROD5_MASSF" },
	CEMPROD2_SCRAP_GYPSUM_RATIO ={unit = '-', job = "CEMPROD2_GYPSUM_RATIO*GLOBAL_SCRAP_GYPSUM_RATIO" },
	CEMPROD4_NATURAL_GYPSUM_RATIO ={unit = '-', job = "CEMPROD4_GYPSUM_RATIO*(1-GLOBAL_SCRAP_GYPSUM_RATIO)" },
	MILL_CEMPROD4_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD4_NATURAL_GYPSUM_RATIO()*MILL_CEMPROD4_MASSF" },
	CEMPROD2_NATURAL_GYPSUM_RATIO ={unit = '-', job = "CEMPROD2_GYPSUM_RATIO*(1-GLOBAL_SCRAP_GYPSUM_RATIO)" },
	MILL_CEMPROD4_H2O_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD4_SP_H2O*MILL_CEMPROD4_MASSF" },
	CEMPROD1_NATURAL_GYPSUM_RATIO ={unit = '-', job = "CEMPROD1_GYPSUM_RATIO*(1-GLOBAL_SCRAP_GYPSUM_RATIO)" },
	MILL_CEMPROD5_FBCASH_MASSF ={unit = 'kg/h', job = "CEMPROD5_FBCASH_RATIO*MILL_CEMPROD5_MASSF" },
	MILL_CEMPROD5_SCRAP_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD5_SCRAP_GYPSUM_RATIO()*MILL_CEMPROD5_MASSF" },
	MILL_CEMPROD5_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD5_NATURAL_GYPSUM_RATIO()*MILL_CEMPROD5_MASSF" },
	MILL_CEMPROD5_GBFS_MASSF ={unit = 'kg/h', job = "CEMPROD5_GBFS_RATIO*MILL_CEMPROD5_MASSF" },
	MILL_SP_CEMPROD3_POWER ={unit = 'kWh/kg', job = "(MILL_SP_CEMPROD3_POWER_COARSE()+MILL_SP_CEMPROD3_POWER_FINE())" },
	MILL_SP_CEMPROD5_POWER_COARSE ={unit = 'kWh/kg', job = "4*Wi_CEMIII*cem5a*(750^(-(cem5e+750/cem5c))-MILL_CEMPROD5_FEED_D80^(-(cem5e+MILL_CEMPROD5_FEED_D80/cem5c)))" },
	MILL_CEMPROD3_H2O_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD3_SP_H2O*MILL_CEMPROD3_MASSF" },
	MILL_CEMPROD1_GAID_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD1_SP_GAID*MILL_CEMPROD1_MASSF" },
	MILL_CEMPROD2_CLINKER_MASSF ={unit = 'kg/h', job = "CEMPROD2_CLINKER_RATIO*MILL_CEMPROD2_MASSF" },
	MILL_CEMPROD2_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD2_NATURAL_GYPSUM_RATIO()*MILL_CEMPROD2_MASSF" },
	MILL_CEMPROD3_GAID_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD3_SP_GAID*MILL_CEMPROD3_MASSF" },
	MILL_SP_CEMPROD5_POWER_FINE ={unit = 'kWh/kg', job = "4*Wi_CEMIII*cem5b*(MILL_CEMPROD5_D80^(-(cem5e+MILL_CEMPROD5_D80/cem5c))-750^(-(cem5e+750/cem5c)))" },
	MILL_SP_CEMPROD3_POWER_FINE ={unit = 'kWh/kg', job = "4*Wi_CEMII*cem3b*(MILL_CEMPROD3_D80^(-(cem3e+MILL_CEMPROD3_D80/cem3c))-750^(-(cem3e+750/cem3c)))" },
	CEMPROD1_SCRAP_GYPSUM_RATIO ={unit = '-', job = "CEMPROD1_GYPSUM_RATIO*GLOBAL_SCRAP_GYPSUM_RATIO" },
	MILL_SP_CEMPROD5_POWER ={unit = 'kWh/kg', job = "(MILL_SP_CEMPROD5_POWER_COARSE()+MILL_SP_CEMPROD5_POWER_FINE())" },
	MILL_CEMPROD1_H2O_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD1_SP_H2O*MILL_CEMPROD1_MASSF" },
	MILL_CEMPROD3_POWER ={unit = 'kW', job = "MILL_SP_CEMPROD3_POWER()*MILL_CEMPROD3_MASSF" },
	MILL_CEMPROD2_FASH_MASSF ={unit = 'kg/h', job = "CEMPROD2_FASH_RATIO*MILL_CEMPROD2_MASSF" },
	MILL_CEMPROD4_GAID_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD4_SP_GAID*MILL_CEMPROD4_MASSF" },
	MILL_SP_CEMPROD2_POWER ={unit = 'kWh/kg', job = "(MILL_SP_CEMPROD2_POWER_COARSE()+MILL_SP_CEMPROD2_POWER_FINE())" },
	MILL_CEMPROD5_POWER ={unit = 'kW', job = "MILL_SP_CEMPROD5_POWER()*MILL_CEMPROD5_MASSF" },
	MILL_CEMPROD4_SCRAP_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD4_SCRAP_GYPSUM_RATIO()*MILL_CEMPROD4_MASSF" },
	MILL_CEMPROD2_SCRAP_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD2_SCRAP_GYPSUM_RATIO()*MILL_CEMPROD2_MASSF" },
	MILL_CEMPROD2_POWER ={unit = 'kW', job = "MILL_SP_CEMPROD2_POWER()*MILL_CEMPROD2_MASSF" },
	MILL_SP_CEMPROD2_POWER_COARSE ={unit = 'kWh/kg', job = "4*Wi_CEMII*cem2a*(750^(-(cem2e+750/cem2c))-MILL_CEMPROD2_FEED_D80^(-(cem2e+MILL_CEMPROD2_FEED_D80/cem2c)))" },
	MILL_SP_CEMPROD4_POWER_FINE ={unit = 'kWh/kg', job = "4*Wi_CEMII*cem4b*(MILL_CEMPROD4_D80^(-(cem4e+MILL_CEMPROD4_D80/cem4c))-750^(-(cem4e+750/cem4c)))" },
	MILL_CEMPROD2_GAID_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD2_SP_GAID*MILL_CEMPROD2_MASSF" },
	MILL_SP_CEMPROD4_POWER ={unit = 'kWh/kg', job = "(MILL_SP_CEMPROD4_POWER_COARSE()+MILL_SP_CEMPROD4_POWER_FINE())" },
	MILL_CEMPROD4_LMSN_MASSF ={unit = 'kg/h', job = "CEMPROD4_LMSN_RATIO*MILL_CEMPROD4_MASSF" },
	MILL_CEMPROD2_H2O_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD2_SP_H2O*MILL_CEMPROD2_MASSF" },
	MILL_SP_CEMPROD3_POWER_COARSE ={unit = 'kWh/kg', job = "4*Wi_CEMII*cem3a*(750^(-(cem3e+750/cem3c))-MILL_CEMPROD3_FEED_D80^(-(cem3e+MILL_CEMPROD3_FEED_D80/cem3c)))" },
	MILL_CEMPROD5_CLINKER_MASSF ={unit = 'kg/h', job = "CEMPROD5_CLINKER_RATIO*MILL_CEMPROD5_MASSF" },
	MILL_CEMPROD3_FBCASH_MASSF ={unit = 'kg/h', job = "CEMPROD3_FBCASH_RATIO*MILL_CEMPROD3_MASSF" },
	MILL_CEMPROD1_POWER ={unit = 'kW', job = "MILL_SP_CEMPROD1_POWER()*MILL_CEMPROD1_MASSF" },
	MILL_SP_CEMPROD1_POWER ={unit = 'kWh/kg', job = "(MILL_SP_CEMPROD1_POWER_COARSE()+MILL_SP_CEMPROD1_POWER_FINE())" },
	MILL_CEMPROD1_GYPSUM_MASSF ={unit = 'kg/h', job = "CEMPROD1_NATURAL_GYPSUM_RATIO()*MILL_CEMPROD1_MASSF" },
	MILL_SP_CEMPROD1_POWER_COARSE ={unit = 'kWh/kg', job = "4*Wi_CEMI*cem1a*(750^(-(cem1e+750/cem1c))-MILL_CEMPROD1_FEED_D80^(-(cem1e+MILL_CEMPROD1_FEED_D80/cem1c)))" },
	MILL_CEMPROD1_CLINKER_MASSF ={unit = 'kg/h', job = "CEMPROD1_CLINKER_RATIO*MILL_CEMPROD1_MASSF" },

	MILL_CEMPROD6_GYPSUM_MASSF ={unit = 'kg/h', job = "RATIO_MILL_CEMPROD6_GYPSUM_MASSF*MILL_CEMPROD6_MASSF" },
	MILL_CEMPROD6_CLINKER_MASSF ={unit = 'kg/h', job = "RATIO_MILL_CEMPROD6_CLINKER_MASSF*MILL_CEMPROD6_MASSF" },
	MILL_CEMPROD6_CALCINED_CLAY_MASSF ={unit = 'kg/h', job = "RATIO_MILL_CEMPROD6_CALCINED_CLAY_MASSF*MILL_CEMPROD6_MASSF" },
	MILL_CEMPROD6_LMSN_MASSF ={unit = 'kg/h', job = "RATIO_MILL_CEMPROD6_LMSN_MASSF*MILL_CEMPROD6_MASSF" },
	MILL_CEMPROD6_POWER ={unit = 'kW', job = "MILL_SP_CEMPROD1_POWER()*MILL_CEMPROD6_MASSF" }, -- based on another type for now
	MILL_CEMPROD6_H2O_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD6_SP_H2O*MILL_CEMPROD6_MASSF" },
	MILL_CEMPROD6_GAID_VOLF ={unit = 'm3/h', job = "MILL_CEMPROD6_SP_GAID*MILL_CEMPROD6_MASSF" },
      -- COST 22156250
  Annuity = {unit = '-', job = '(Interest_rate_ws*(Interest_rate_ws+1)^Number_year_ws)/((Interest_rate_ws+1)^Number_year_ws-1)'},
  Cost2Elec_Mill1 = {job = '(MILL_CEMPROD1_POWER()*Elec_buy)/annual_cap_cement', unit = 'eur/t/h'},
  Cost2Elec_Mill2 = {job = '(MILL_CEMPROD2_POWER()*Elec_buy)/annual_cap_cement', unit = 'eur/t/h'},
  Cost2Elec_Mill3 = {job = '(MILL_CEMPROD3_POWER()*Elec_buy)/annual_cap_cement', unit = 'eur/t/h'},
  Cost2Elec_Mill4 = {job = '(MILL_CEMPROD4_POWER()*Elec_buy)/annual_cap_cement', unit = 'eur/t/h'},
  Cost2Elec_Mill5 = {job = '(MILL_CEMPROD5_POWER()*Elec_buy)/annual_cap_cement', unit = 'eur/t/h'},
  Cost2Elec_Mill6 = {job = '(MILL_CEMPROD6_POWER()*Elec_buy)/annual_cap_cement', unit = 'eur/t/h'},
  Cinv2_prod1   = {unit = 'EUR', job = '(22156250*US_to_EUR)*(MILL_CEMPROD1_MASSF/(20.886*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
  Cinv2_prod2   = {unit = 'EUR', job = '(22156250*US_to_EUR)*(MILL_CEMPROD2_MASSF/(20.886*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
  Cinv2_prod3   = {unit = 'EUR', job = '(22156250*US_to_EUR)*(MILL_CEMPROD3_MASSF/(20.886*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
  Cinv2_prod4   = {unit = 'EUR', job = '(22156250*US_to_EUR)*(MILL_CEMPROD4_MASSF/(20.886*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
  Cinv2_prod5   = {unit = 'EUR', job = '(22156250*US_to_EUR)*(MILL_CEMPROD5_MASSF/(20.886*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
  Cinv2_prod6   = {unit = 'EUR', job = '(22156250*US_to_EUR)*(MILL_CEMPROD6_MASSF/(20.886*3600))^(0.6)*CEPCI_2020/CEPCI_2014*Annuity()/annual_cap_cement'},
}

return et
