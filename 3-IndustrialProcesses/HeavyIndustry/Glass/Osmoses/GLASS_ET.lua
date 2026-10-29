local osmose = require 'osmose'
local et     = osmose.Model 'GLASS_float'

-- =============================================================================
-- METADATA
-- =============================================================================
et.header = {
  name          = 'GLASS_float',
  displayName   = 'Glass float',
  authors       = { 'Muhammad Salman, ULiege' },
  Contact       = { 'salman3692@yahoo.com' },
  developers    = { '' },
  contributors  = { '' },
  creation_date = '',
  updates       = { '' },
  versions      = { '1.0' },
  title         = 'Glass float',
  description   = [[]],
  references    = {},
  notes         = {},
}

-- =============================================================================
-- LAYERS
-- =============================================================================

-- Raw material inputs
et:addLayers { Sand               = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Soda               = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Dolomite           = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Limestone          = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { NaSO4              = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Feldspar           = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { NaCl               = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Slag               = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Coal               = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { water              = { type = 'ResourceBalance', unit = 'kg/h' } }

-- Cullet (internal and external recycling)
et:addLayers { Cullet_int         = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Cullet_ext         = { type = 'ResourceBalance', unit = 'kg/h' } }

-- Gases
et:addLayers { Oxygen             = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Nitrogen           = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { hydrogen           = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Flue_gas           = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { Naturalgas         = { type = 'ResourceBalance', unit = 'kg/h' } }

-- Energy
et:addLayers { Elec               = { type = 'ResourceBalance', unit = 'kW'   } }

-- Products and wastes
et:addLayers { Float_glass_product = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { melted_glass        = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { wastewater          = { type = 'ResourceBalance', unit = 'kg/h' } }
et:addLayers { solid_waste         = { type = 'ResourceBalance', unit = 'kg/h' } }

-- Heat cascades
et:addLayers { Liqbath = { type = 'HeatCascade', unit = 'kW' } }  -- liquid bath (tin bath) cooling
et:addLayers { Forming = { type = 'HeatCascade', unit = 'kW' } }  -- forming and finishing zone cooling
et:addLayers { HREC    = { type = 'HeatCascade', unit = 'kW' } }  -- heat recovery cascade

-- Debug / test layer
et:addLayers { test1 = { type = 'ResourceBalance', unit = 'kg/h' } }

-- =============================================================================
-- UNIT: glass_melting_cullet
-- Heats and melts internal + external cullet (recycled glass)
-- =============================================================================
et:addUnit('glass_melting_cullet', {type='Utility', Fmax=1, addToProblem=1, Cost1=0, Cost2=0, Cinv1=0, Cinv2=0})

et['glass_melting_cullet']:addStreams {
  Cullet_int          = rs({ 'Cullet_int',   'in',  'Cullet_int_in'      }),
  Cullet_ext          = rs({ 'Cullet_ext',   'in',  'Cullet_ext_in'      }),
  melted_glass_out    = rs({ 'melted_glass', 'out', 'melted_glass_cullet' }),

  -- Preheating: 25 → 200°C (HREC cascade)
  cullet_heating      = qt({ tin='cullet_in_temp', hin=0,         tout='prep_temp',    hout='cullet_q',         dtmin='dtmin', HC='HREC' }),
  -- Melting: 200 → 1600°C
  melting_heat_cullet = qt({ tin='prep_temp',      hin=0,         tout='melting_temp', hout='cullet_melting_q', dtmin='dtmin'           }),
}

-- =============================================================================
-- UNIT: glass_melting_solids
-- Heats and melts all solid raw material inputs
-- =============================================================================
et:addUnit('glass_melting_solids', {type='Utility', Fmax=1e9, addToProblem=1, Cost1=0, Cost2=0, Cinv1=0, Cinv2=0})

et['glass_melting_solids']:addStreams {
  -- Raw material inputs
  Sand                = rs({ 'Sand',        'in',  'Sand_in'        }),
  Soda                = rs({ 'Soda',        'in',  'Soda_in'        }),
  Dolomite            = rs({ 'Dolomite',    'in',  'Dolomite_in'    }),
  Limestone           = rs({ 'Limestone',   'in',  'Limestone_in'   }),
  NaSO4               = rs({ 'NaSO4',       'in',  'NaSO4_in'       }),
  Feldspar            = rs({ 'Feldspar',    'in',  'Feldspar_in'    }),
  Nitrogen            = rs({ 'Nitrogen',    'in',  'Nitrogen_in'    }),
  Hydrogen            = rs({ 'hydrogen',    'in',  'Hydrogen_in'    }),
  NaCl                = rs({ 'NaCl',        'in',  'NaCl_in'        }),
  Slag                = rs({ 'Slag',        'in',  'Slag_in'        }),
  Coal                = rs({ 'Coal',        'in',  'Coal_in'        }),
  Water               = rs({ 'water',       'in',  'Water_in'       }),

  -- Outputs
  wastewater          = rs({ 'wastewater',  'out', 'wastewater_out'      }),
  solid_waste         = rs({ 'solid_waste', 'out', 'solid_waste_out'     }),
  CO2_emissions       = rs({ 'Flue_gas',    'out', 'CO2emissions'        }),
  melted_glass_out    = rs({ 'melted_glass','out', 'melted_glass_solids' }),

  -- Preheating: 25 → 200°C (HREC cascade)
  prep_heating        = qt({ tin='material_in_temp', hin=0, tout='prep_temp',    hout='prep_heating', dtmin='dtmin', HC='HREC' }),
  -- Melting: 200 → 1600°C
  melting_heat        = qt({ tin='prep_temp',        hin=0, tout='melting_temp', hout='melting_q',    dtmin='dtmin'           }),
  -- Flue gas cooling (disabled; needs oxy-CCS context to activate):
  -- hot_gases = qt({ tin='hotgases_temp', hin='hot_gases_cooling_q', tout='T_stack_furnace', hout=0, dtmin='dtmin', HC='HREC' }),
  -- Source: https://www.oxyfuel-heatrecovery.com/sites/oxyfuel_heatrecovery/files/2017/03/15/layman7567941198777235687.pdf
}

-- =============================================================================
-- UNIT: glass_float
-- Forming, finishing, and cooling of the molten glass ribbon
-- =============================================================================
et:addUnit('glass_float', {type='Process', Fmax=1e9, addToProblem=1, Cost1=0, Cost2=0, Cinv1=0, Cinv2='Cinv2_float'})

et['glass_float']:addStreams {
  Electricity         = rs({ 'Elec',               'in',  'Electricity_in' }),
  melted_glass_in     = rs({ 'melted_glass',        'in',  'float_product'  }),
  Float_glass_product = rs({ 'Float_glass_product', 'out', 'float_product'  }),

  -- Latent heat of solidification (1600°C → 1350°C phase transition)
  latent_q1           = qt({ tin='melting_temp', hin=0,           tout='melting_temp', hout='latent_heat', dtmin='dtmin'         }),
  latent_q2           = qt({ tin='solid_temp',   hin='latent_heat', tout='solid_temp', hout=0,             dtmin='dtmin'         }),

  -- Sensible cooling: 1600 → 600°C (tin bath / Liqbath cascade)
  forming_cooling     = qt({ tin='melting_temp', hin='forming_q',   tout='forming_temp',   hout=0, dtmin='dtmin',   HC='Liqbath' }),
  -- Sensible cooling: 600 → 350°C (annealing lehr / Forming cascade)
  finishing_cooling   = qt({ tin='forming_temp', hin='finishing_q', tout='finishing_temp',  hout=0, dtmin=5,         HC='Forming' }),
  -- Final cooling: 350 → 30°C (disabled; glass left to cool in open air — difficult to recover)
  -- glass_cooling    = qt({ tin='finishing_temp', hin='glass_cooling', tout='T_ambient', hout=0, dtmin=5, HC='Forming' }),

  -- Endothermic reactions (1300–1600°C zone)
  reaction_q          = qt({ tin=1300, hin=0,           tout=1600, hout='heat_rx',    dtmin='dtmin' }),
  -- Annealing reheat (500–600°C zone)
  annealing_q         = qt({ tin=500,  hin=0,           tout=600,  hout='annealing_q', dtmin='dtmin' }),

  -- Debug: total batch mass flow check
  tot_massq           = rs({ 'test1', 'out', 'test1' }),
}

-- =============================================================================
-- UNIT: air_twin
-- with heat recovered into HREC above 200°C
-- =============================================================================
et:addUnit('air_twin', {type='Utility', Fmax=1e5, addToProblem=1, Cost1=0, Cost2=0, Cinv1=0, Cinv2=0})

et['air_twin']:addStreams {
  -- Air heated by glass: 25 → 200°C (Forming cascade, cold side)
  glass_cooling_twin = qt({ tin=25,  hin=0, tout=200, hout=1, dtmin=5, HC='Forming' }),
  glass_cooling_HREC = qt({ tin=200, hin=1, tout=25,  hout=0, dtmin=5, HC='HREC'   }),
  -- Note: 200°C is the final air temperature after cooling glass from 350°C,
  -- assuming air mass ≈ 2× melted glass mass
}

-- =============================================================================
-- INPUTS
-- =============================================================================
et.inputs = {

  -- ---------------------------------------------------------------------------
  -- Plant sizing
  -- ---------------------------------------------------------------------------
  -- Typical European float glass plant: 500 t/day
  -- Source: https://blog.marketresearch.com/flat-glass-manufacturers-expand-into-developing-areas
  float_product = { default = 'float_product', unit = 'kg/h' },

  -- ---------------------------------------------------------------------------
  -- Mass ratios (t input / t float glass product)
  -- ---------------------------------------------------------------------------
  Sand_in_r        = { default = 0.65,     unit = 't/t' },
  Soda_in_r        = { default = 0.20,     unit = 't/t' },
  Dolomite_in_r    = { default = 0.17,     unit = 't/t' },
  -- Updated per Luc communication (14/02/2022); previous value was 0.04 for both
  Cullet_int_in_r  = { default = 0.10,     unit = 't/t' },
  Cullet_ext_in_r  = { default = 0.16,     unit = 't/t' },
  Limestone_in_r   = { default = 0.04,     unit = 't/t' },
  NaSO4_in_r       = { default = 0.01,     unit = 't/t' },
  Feldspar_in_r    = { default = 4.38e-3,  unit = 't/t' },
  Oxygen_in_r      = { default = 0.01,     unit = 't/t' },
  Nitrogen_in_r    = { default = 0.09,     unit = 't/t' },
  Hydrogen_in_r    = { default = 3.67e-4,  unit = 't/t' },
  NaCl_in_r        = { default = 5.4e-5,   unit = 't/t' },
  Slag_in_r        = { default = 0.02,     unit = 't/t' },
  Coal_in_r        = { default = 7.53e-5,  unit = 't/t' },
  Water_in_r       = { default = 1.44,     unit = 't/t' },
  NG_in_r          = { default = 25,       unit = 't/t' },  -- to fix
  Fuel_oil_in_r    = { default = 25,       unit = 't/t' },  -- to fix
  Electricity_in_r = { default = 0.222,    unit = 'kWh/kg' },
  wastewater_r     = { default = 0.77,     unit = 't/t' },
  solid_waste_r    = { default = 3.7e-3,   unit = 't/t' },

  -- ---------------------------------------------------------------------------
  -- Specific heat capacities (J/g·°C)
  -- ---------------------------------------------------------------------------
  -- Source: https://www.engineeringtoolbox.com/specific-heat-capacity-d_391.html
  Sand_cp      = { default = 0.83,    unit = 'J/gC' },
  -- Source: https://en.wikipedia.org/wiki/Sodium_carbonate
  Soda_cp      = { default = 1.06,    unit = 'J/gC' },
  -- Source: https://www.engineeringtoolbox.com/specific-heat-solids-d_154.html
  Dolomite_cp  = { default = 0.92,    unit = 'J/gC' },
  -- Source: https://www.engineeringtoolbox.com/specific-heat-capacity-d_391.html
  Cullet_int_cp = { default = 0.7,   unit = 'J/gC' },
  Cullet_ext_cp = { default = 0.7,   unit = 'J/gC' },
  Limestone_cp = { default = 0.909,  unit = 'J/gC' },
  NaSO4_cp     = { default = 0.902,  unit = 'J/gC' },
  -- Source: https://pubs.usgs.gov/of/1988/0441/report.pdf
  Feldspar_cp  = { default = 0.75,   unit = 'J/gC' },
  Oxygen_cp    = { default = 0.918,  unit = 'J/gC' },
  Nitrogen_cp  = { default = 1.040,  unit = 'J/gC' },
  Hydrogen_cp  = { default = 14.304, unit = 'J/gC' },
  -- Source: https://www.engineeringtoolbox.com/specific-heat-capacity-d_391.html
  NaCl_cp      = { default = 0.88,   unit = 'J/gC' },
  -- Source: https://benthamopen.com/contents/pdf/TOEFJ/TOEFJ-8-356.pdf
  Slag_cp      = { default = 1.05,   unit = 'J/gC' },
  -- Source: https://www.engineeringtoolbox.com/specific-heat-capacity-d_391.html
  Coal_cp      = { default = 1.02,   unit = 'J/gC' },
  Water_cp     = { default = 4.18,   unit = 'J/gC' },
  CO2_cp       = { default = 1.014,  unit = 'J/gC' },
  glass_cp     = { default = 1.5,    unit = 'J/gC' },

  -- ---------------------------------------------------------------------------
  -- Process temperatures (°C)
  -- ---------------------------------------------------------------------------
  material_in_temp = { default = 25,   unit = 'C' },   -- ambient batch inlet temperature
  cullet_in_temp   = { default = 25,   unit = 'C' },   -- cullet inlet temperature
  prep_temp        = { default = 200,  unit = 'C' },   -- preheating target temperature
  melting_temp     = { default = 1600, unit = 'C' },   -- melting zone temperature
  solid_temp       = { default = 1350, unit = 'C' },   -- solidification temperature (latent heat release)
  hotgases_temp    = { default = 1100, unit = 'C' },   -- flue gas temperature at furnace exit
  T_stack_furnace  = { default = 230,  unit = 'C' },   -- minimum stack temperature (dewpoint limit)
  forming_temp     = { default = 600,  unit = 'C' },   -- end of forming zone (tin bath exit)
  finishing_temp   = { default = 350,  unit = 'C' },   -- end of finishing/annealing zone
  T_ambient        = { default = 30,   unit = 'C' },   -- ambient temperature

  -- ---------------------------------------------------------------------------
  -- Heat demand parameters
  -- ---------------------------------------------------------------------------
  melting_sl  = { default = 0.136,  unit = 'kWh'    },   -- specific latent heat of glass solidification
  heat_rx_r   = { default = 0.05,   unit = 'kWh/kg' },   -- specific endothermic reaction heat (original: 0.101 kWh/kg)
  cullet_int_rec = { default = 0.1, unit = '-'      },   -- internal cullet recovery fraction

  -- ---------------------------------------------------------------------------
  -- Heat exchanger ΔT_min values
  -- ---------------------------------------------------------------------------
  dtmin          = { default = 150, unit = 'C' },
  dtmin_finishing = { default = 10, unit = 'C' },

  -- ---------------------------------------------------------------------------
  -- Economic parameters
  -- ---------------------------------------------------------------------------
  Number_year_ws    = { default = 40,        unit = 'year', description = 'Expected investment lifetime' },
  Interest_rate_ws  = { default = 0.06,      unit = '-',    description = 'Discount interest rate'      },
  year2hour         = { default = 8760,      unit = 'h/y',  description = 'Year-to-hour conversion'     },

  -- Reference plant: 500 t/day ≈ 150–200 M$ (175 M$ used)
  -- Source: https://blog.marketresearch.com/flat-glass-manufacturers-expand-into-developing-areas
  -- Cinv2 derived from 175 M$, 40-year operation, 330 operating days/year
  Cinv2_glass_float = { default = 162430000, unit = 'EUR'   },  -- 175 MUSD converted to EUR
  ref_size          = { default = 20833.33,  unit = 'kg/h'  },  -- 500 t/day reference size

  CEPCI_2020 = { default = 596.2, unit = '-', description = 'CEPCI index 2020' },
  CEPCI_2008 = { default = 575.4, unit = '-', description = 'CEPCI index 2008' },
  CEPCI_2024 = { default = 795.4, unit = '-', description = 'CEPCI index 2024' },
  CEPCI_2018 = { default = 603.1, unit = '-', description = 'CEPCI index 2018' },
}

-- =============================================================================
-- OUTPUTS
-- =============================================================================
et.outputs = {

  -- ---------------------------------------------------------------------------
  -- Mass flows (scaled from float_product)
  -- ---------------------------------------------------------------------------
  Sand_in        = { unit = 'kg/h', job = 'Sand_in_r       * float_product' },
  Soda_in        = { unit = 'kg/h', job = 'Soda_in_r       * float_product' },
  Dolomite_in    = { unit = 'kg/h', job = 'Dolomite_in_r   * float_product' },
  Cullet_int_in  = { unit = 'kg/h', job = 'Cullet_int_in_r * float_product' },
  Cullet_ext_in  = { unit = 'kg/h', job = 'Cullet_ext_in_r * float_product' },
  Limestone_in   = { unit = 'kg/h', job = 'Limestone_in_r  * float_product' },
  NaSO4_in       = { unit = 'kg/h', job = 'NaSO4_in_r      * float_product' },
  Feldspar_in    = { unit = 'kg/h', job = 'Feldspar_in_r   * float_product' },
  Oxygen_in      = { unit = 'kg/h', job = 'Oxygen_in_r     * float_product' },
  Nitrogen_in    = { unit = 'kg/h', job = 'Nitrogen_in_r   * float_product' },
  Hydrogen_in    = { unit = 'kg/h', job = 'Hydrogen_in_r   * float_product' },
  NaCl_in        = { unit = 'kg/h', job = 'NaCl_in_r       * float_product' },
  Slag_in        = { unit = 'kg/h', job = 'Slag_in_r       * float_product' },
  Coal_in        = { unit = 'kg/h', job = 'Coal_in_r       * float_product' },
  Water_in       = { unit = 'kg/h', job = 'Water_in_r      * float_product' },
  NG_in          = { unit = 'kg/h', job = 'NG_in_r         * float_product' },
  Fuel_oil_in    = { unit = 'kg/h', job = 'Fuel_oil_in_r   * float_product' },
  Electricity_in = { unit = 'kW',   job = 'Electricity_in_r * float_product' },
  wastewater_out = { unit = 'kg/h', job = 'wastewater_r    * float_product' },
  solid_waste_out= { unit = 'kg/h', job = 'solid_waste_r   * float_product' },

  -- ---------------------------------------------------------------------------
  -- Process CO2 emissions from carbonate decomposition
  -- Soda (Na2CO3): 44/106 kg CO2/kg | Dolomite (CaMg(CO3)2): 88/184.4 | Limestone (CaCO3): 44/100
  -- ---------------------------------------------------------------------------
  CO2emissions = { unit = 'kg/h', job = 'Soda_in()*44/106 + Dolomite_in()*88/184.4 + Limestone_in()*44/100' },

  -- ---------------------------------------------------------------------------
  -- Glass mass balance
  -- ---------------------------------------------------------------------------
  melted_glass_cullet = { unit = 'kg/h', job = 'Cullet_int_in() + Cullet_ext_in()'                                                                                  },
  melted_glass_solids = { unit = 'kg/h', job = 'Sand_in() + Dolomite_in() + Limestone_in() + NaSO4_in() + Feldspar_in() + NaCl_in() + Slag_in() - CO2emissions() - solid_waste_out()' },
  glass_product       = { unit = 'kg/h', job = 'melted_glass_cullet() + melted_glass_solids()'                                                                       },

  -- ---------------------------------------------------------------------------
  -- Batch heat demand
  -- ---------------------------------------------------------------------------
  -- Weighted mass × Cp sum for solid raw materials (excludes cullet)
  tot_mass         = { unit = 'kg/h', job = 'Sand_in() + Dolomite_in() + Limestone_in() + NaSO4_in() + Feldspar_in() + NaCl_in() + Slag_in() + Cullet_ext_in() + Cullet_int_in()' },
  tot_mass_with_cp = { unit = '',     job = 'Sand_in()*Sand_cp + Dolomite_in()*Dolomite_cp + Limestone_in()*Limestone_cp + NaSO4_in()*NaSO4_cp + Feldspar_in()*Feldspar_cp + NaCl_in()*NaCl_cp + Slag_in()*Slag_cp' },

  -- Preheating: 25 → 200°C (solid batch)
  prep_heating        = { unit = 'kW', job = 'tot_mass_with_cp() * (prep_temp - material_in_temp) / 3600'                              },
  -- Melting: 200 → 1600°C (solid batch)
  melting_q           = { unit = 'kW', job = 'tot_mass_with_cp() * (melting_temp - prep_temp) / 3600'                                  },
  -- Flue gas sensible heat (for future use with oxy-CCS)
  hot_gases_cooling_q = { unit = 'kW', job = 'CO2emissions() * CO2_cp * (hotgases_temp - T_stack_furnace) / 3600'                      },

  -- Cullet preheating and melting
  cullet_q            = { unit = 'kW', job = '(Cullet_int_in() + Cullet_ext_in()) * Cullet_int_cp * (prep_temp    - material_in_temp) / 3600' },
  cullet_melting_q    = { unit = 'kW', job = '(Cullet_int_in() + Cullet_ext_in()) * Cullet_int_cp * (melting_temp - prep_temp)        / 3600' },

  -- ---------------------------------------------------------------------------
  -- Forming, finishing, and cooling heat
  -- ---------------------------------------------------------------------------
  latent_heat    = { unit = 'kW', job = 'glass_product() * melting_sl / 3600'                                   },  -- latent heat of solidification
  heat_rx        = { unit = 'kW', job = 'glass_product() * heat_rx_r'                                           },  -- endothermic batch reactions
  annealing_q    = { unit = 'kW', job = 'glass_product() * glass_cp * (600 - 500) / 3600'                       },  -- annealing zone reheat
  forming_q      = { unit = 'kW', job = 'glass_product() * glass_cp * (melting_temp  - forming_temp)  / 3600'   },  -- tin bath cooling: 1600 → 600°C
  finishing_q    = { unit = 'kW', job = 'glass_product() * glass_cp * (forming_temp  - finishing_temp) / 3600'  },  -- lehr cooling: 600 → 350°C
  glass_cooling  = { unit = 'kW', job = 'glass_product() * glass_cp * (finishing_temp - T_ambient)     / 3600'  },  -- final cooling: 350 → 30°C (open air, not recovered)

  -- ---------------------------------------------------------------------------
  -- Economics — annualised CAPEX
  -- ---------------------------------------------------------------------------
  Annuity = { unit = '-', job = '(Interest_rate_ws * (Interest_rate_ws + 1) ^ Number_year_ws) / ((Interest_rate_ws + 1) ^ Number_year_ws - 1)' },

  -- Power-of-0.6 scaling with CEPCI escalation
  -- ×0.65 factor: 35% of plant cost attributed to furnace heating (modelled separately in furnace ETs)
  Cinv2_float = { unit = 'EUR', job = 'Cinv2_glass_float * Annuity() * ((float_product / ref_size) ^ 0.6) * (CEPCI_2024 / CEPCI_2018) * 0.65' },

  -- ---------------------------------------------------------------------------
  -- Debug
  -- ---------------------------------------------------------------------------
  test1 = { unit = 'kW', job = 'tot_mass()' },
}

return et