-- =============================================================================
-- NOTE: 	Clinkerisation process model for a dry short kiln with integrated
--          pre-heating and pre-calcination stages. Computes heat loads, mass
--          flows, CO₂ emissions, and annualised investment costs for the full
--          kiln train:
--
--          KILNPH_DRY  — cyclone pre-heater (4-stage, two raw meal streams)
--          KILNPC_DRY  — pre-calciner (calcination reaction + tertiary air)
--          KILN_DRY    — rotary kiln (8 solid-temperature nodes)
--          KILNCC_DRY  — clinker cooler (secondary air + grate cooler)
--
--          Cement product mix (CEM I–VI) drives clinker demand, which scales
--          all downstream mass flows and heat duties.
-- =============================================================================

local osmose       = require 'osmose'
local et           = osmose.Model 'CM_SP_DRYKILN_Optim'
local cost_defaults = require 'equipmentcost.cost_defaults'

et.header = {
  name        = 'CM_SP_DRYKILN_Optim',
  displayName = 'Dry Kiln',
  Developers  = {'Shivom Sharma, EPFL; Muhammad Salman, ULiège'},
  contributors= {'Muhammad Salman, ULiège'},
  versions    = {'2.0'},
  title       = 'Dry Kiln',
  description = [[Model of the clinkerisation process in a dry (short) kiln,
                  with pre-heating and pre-calcination steps]],
}


-- =============================================================================
-- SECTION 1: RESOURCE AND COSTING LAYERS
-- =============================================================================
-- ResourceBalance layers track mass flows (kg/h) through the kiln train.
-- Costing and HeatCascade layers are required by the OSMOSE framework.

-- ── Solid streams ─────────────────────────────────────────────────────────────
et:addLayers { Raw_meal             = {type = 'ResourceBalance', unit = 'kg/h'} }   -- raw meal entering pre-heater
et:addLayers { PH_Raw_meal          = {type = 'ResourceBalance', unit = 'kg/h'} }   -- pre-heated raw meal (PH → PC)
et:addLayers { PCHT_Raw_meal        = {type = 'ResourceBalance', unit = 'kg/h'} }   -- pre-calcined raw meal (PC → kiln)
et:addLayers { PC_Raw_meal          = {type = 'ResourceBalance', unit = 'kg/h'} }   -- raw meal entering rotary kiln
et:addLayers { Clinker_ShortDry_Hot = {type = 'ResourceBalance', unit = 'kg/h'} }   -- hot clinker (kiln → cooler)
et:addLayers { Clinker_LongDry_Hot  = {type = 'ResourceBalance', unit = 'kg/h'} }   -- (reserved; long-dry kiln variant)
et:addLayers { Clinker_LongSemiWet_Hot={type='ResourceBalance', unit = 'kg/h'} }    -- (reserved; long semi-wet variant)
et:addLayers { Clinker              = {type = 'ResourceBalance', unit = 'kg/h'} }   -- cooled clinker product
et:addLayers { Ckd                  = {type = 'ResourceBalance', unit = 'kg/h'} }   -- cement kiln dust

-- ── Gas streams ───────────────────────────────────────────────────────────────
et:addLayers { Kiln_flue_gas        = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_ShortDry_flue_gas={type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_Longdry_flue_gas= {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_LongSemiWet_flue_gas={type='ResourceBalance',unit = 'kg/h'} }
et:addLayers { Kiln_exhaust_gas     = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { PC_PH_flue_gas       = {type = 'ResourceBalance', unit = 'kg/h'} }   -- pre-calciner flue gas → pre-heater
et:addLayers { PC_flue_gas          = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Fumes_diverse        = {type = 'ResourceBalance', unit = 'kg/h'} }   -- total mixed flue gas (incl. CO₂)
et:addLayers { CO2_in_flue_gas      = {type = 'ResourceBalance', unit = 'kg/h'} }   -- CO₂ virtually separated for capture modelling
et:addLayers { CO2_oxy              = {type = 'ResourceBalance', unit = 'kg/h'} }   -- CO₂ from oxy-combustion mode

-- ── Air streams ───────────────────────────────────────────────────────────────
et:addLayers { Atm_Air              = {type = 'ResourceBalance', unit = 'kg/h'} }   -- atmospheric air supply
et:addLayers { Cold_Air             = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Hot_Air              = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Secondary_Air        = {type = 'ResourceBalance', unit = 'kg/h'} }   -- kiln secondary air (from cooler)
et:addLayers { Tertiary_Air         = {type = 'ResourceBalance', unit = 'kg/h'} }   -- pre-calciner tertiary air (from cooler)

-- ── Emission component streams ────────────────────────────────────────────────
et:addLayers { Kiln_CO2             = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_CO              = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_NO              = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_NO2             = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_SO2             = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Kiln_H2O             = {type = 'ResourceBalance', unit = 'kg/h'} }
et:addLayers { Moisture_to_exhaustgas={type='ResourceBalance',   unit = 'kg/h'} }

-- ── Electrical power ──────────────────────────────────────────────────────────
et:addLayers { Electricity          = {type = 'ResourceBalance', unit = 'kW'} }

-- ── OSMOSE framework layers ───────────────────────────────────────────────────
et:addLayers { DefaultOpCost        = {type = 'Costing'} }
et:addLayers { DefaultInvCost       = {type = 'Costing'} }
et:addLayers { DefaultImpact        = {type = 'Costing'} }
et:addLayers { DefaultMechPower     = {type = 'Costing'} }
et:addLayers { DefaultHeatCascade   = {type = 'HeatCascade'} }
et:addLayers { HREC                 = {type = 'HeatCascade'} }   -- plant-wide heat recovery cascade


-- =============================================================================
-- SECTION 2: KILN TRAIN UNIT DEFINITIONS
-- =============================================================================
-- ── 2.1  Pre-heater (KILNPH_DRY) ─────────────────────────────────────────────
-- Four-stage cyclone pre-heater. Two raw meal streams (RAWMEAL and KILN_RAWMEAL)
-- are heated by rising hot gases from the pre-calciner.
-- Heat streams represent sensible heat in each temperature interval.

et:addUnit('KILNPH_DRY', {type = 'Utility', Fmin = 0, Fmax = 100000000, addToProblem = 1, Mult = nil})
et['KILNPH_DRY']:addStreams{
  -- Inflows
  kilnph_solids_IN  = rs({'Raw_meal',      'in',  'RAWMEAL_MASSF'}),
  kilnph_solids1_IN = rs({'PCHT_Raw_meal', 'in',  'KILN_RAWMEAL_MASSF'}),
  kilnph_exhaust_IN = rs({'PC_PH_flue_gas','in',  'PC_flue_gas_MASSF'}),
  -- Outflows
  kilnpc_gases_OUT  = rs({'Fumes_diverse',     'out', 'PC_flue_gas_MASSF'}),
  kilnpc_CO2_OUT    = rs({'CO2_in_flue_gas',   'out', 'PC_flue_gas_MASSF'}),
  kilnpc_solids_OUT = rs({'PH_Raw_meal',       'out', 'RAWMEAL_MASSF'}),
  kilnpc_solids1_OUT= rs({'PC_Raw_meal',       'out', 'KILN_RAWMEAL_MASSF'}),
  -- Heat streams (cold — raw meal heating intervals)
  kilnph_qt2 = qt({tin='RM_S1_T',   hin=0, tout='RM_S1_1_T', hout='PHT_HT1_LOAD', dtmin=29.871}),    -- 100 → 476°C
  kilnph_qt3 = qt({tin='RM_S1_1_T', hin=0, tout='RM_S1_2_T', hout='PHT32_LOAD',   dtmin=114.426}),   -- 476 → 704°C
  kilnph_qt4 = qt({tin='RM_S2_T',   hin=0, tout='RM_S2_1_T', hout='PH_HT2_LOAD',  dtmin=59.2795}),   -- 100 → 746°C
  kilnph_qt5 = qt({tin='PC_RM_2_T', hin=0, tout='KILN_RM_T', hout='PH_HT31_LOAD', dtmin=11.6264}),   -- 900 → 910°C
}


-- ── 2.2  Pre-calciner (KILNPC_DRY) ───────────────────────────────────────────
-- Calcination of CaCO₃ → CaO + CO₂ occurs here (~60–70% of total calcination).
-- Tertiary air from the clinker cooler supplies combustion air.
-- Hot kiln gas also provides heat to the pre-calciner.

et:addUnit('KILNPC_DRY', {type = 'Utility', Fmin = 0, Fmax = 100000000, addToProblem = 1, Mult = nil})
et['KILNPC_DRY']:addStreams{
  -- Inflows
  kilnpc_solids_IN         = rs({'PH_Raw_meal',   'in',  'RAWMEAL_MASSF'}),
  -- Outflows
  kilnpc_solids_OUT        = rs({'PCHT_Raw_meal', 'out', 'KILN_RAWMEAL_MASSF'}),
  kilnpc_gases_OUT         = rs({'PC_PH_flue_gas','out', 'PC_flue_gas_MASSF'}),
  -- Heat streams
  kilnpc_qt1               = qt({tin='PH_RM_T',        hin=0, tout='PH_RM_1_T',  hout='PC_PREHEAT_LOAD',    dtmin=0.0001}),  -- 732 → 900°C pre-heat
  kilnpc_qt2               = qt({tin='PH_RM_1_T',      hin=0, tout='PC_RM_1_T',  hout='KILN_PC_REAC_LOAD',  dtmin=0.0001}),  -- 900°C calcination reaction
  kilnpc_tairheat_qt6_HOT  = qt({tin='KILN_PC_TAIR_T', hin='KILN_DRY_TAIR_LOAD', tout='KILN_KG18_T', hout=0, dtmin=0.0001}), -- tertiary air: 1000 → 425°C (hot)
  kilnpc_kilngasheat_qt7_HOT= qt({tin='KILN_KG11_T',   hin='KILN_KILNGAS_LOAD',  tout='KILN_KG18_T', hout=0, dtmin=0.0001}), -- kiln gas:     1150 → 425°C (hot)
}


-- ── 2.3  Rotary kiln (KILN_DRY) ──────────────────────────────────────────────

et:addUnit('KILN_DRY', {type = 'Utility', Fmin = 0, Fmax = 100000000, addToProblem = 1, Mult = nil, Cost2 = 0})
et['KILN_DRY']:addStreams{
  -- Inflows
  kiln_dry_elec_IN         = rs({'Electricity',         'in',  'KILN_DRY_TOTAL_POWER'}),
  kiln_dry_rm_IN           = rs({'PC_Raw_meal',         'in',  'KILN_RAWMEAL_MASSF'}),
  -- Outflows
  kiln_dry_clkhot_OUT      = rs({'Clinker_ShortDry_Hot','out', 'KILN_CLINKERHOT_MASSF'}),
  kiln_dry_gases_OUT       = rs({'Fumes_diverse',       'out', 'KILN_KG11_MASSF'}),
  kiln_dry_CO2_OUT         = rs({'CO2_in_flue_gas',     'out', 'KILN_IMPACT'}),   -- process CO₂ (carbonate decomp.)
  -- Heat streams — 8 solid-temperature nodes
  kiln_dry_solids_qt1 = qt({tin='KILN_SOLID7_T',  hin=0, tout='KILN_SOLID8_T',  hout='KILN_QEX8_LOAD', dtmin='KILN_DTS_VAR8'}),  -- 910 → 910°C (reaction zone)
  kiln_dry_solids_qt2 = qt({tin='KILN_SOLID8_T',  hin=0, tout='KILN_SOLID11_T', hout='KILN_QEX7_LOAD', dtmin='KILN_DTS_VAR7'}),  -- 910 → 910°C
  kiln_dry_solids_qt3 = qt({tin='KILN_SOLID11_T', hin=0, tout='KILN_SOLID14_T', hout='KILN_QEX6_LOAD', dtmin='KILN_DTS_VAR6'}),  -- 910 → 910°C
  kiln_dry_solids_qt4 = qt({tin='KILN_SOLID14_T', hin=0, tout='KILN_SOLID17_T', hout='KILN_QEX5_LOAD', dtmin='KILN_DTS_VAR5'}),  -- 910 → 1026°C
  kiln_dry_solids_qt5 = qt({tin='KILN_SOLID17_T', hin=0, tout='KILN_SOLID20_T', hout='KILN_QEX4_LOAD', dtmin='KILN_DTS_VAR4'}),  -- 1026 → 1226°C
  kiln_dry_solids_qt6 = qt({tin='KILN_SOLID20_T', hin=0, tout='KILN_SOLID23_T', hout='KILN_QEX3_LOAD', dtmin='KILN_DTS_VAR3'}),  -- 1226 → 1326°C
  kiln_dry_solids_qt7 = qt({tin='KILN_SOLID23_T', hin=0, tout='KILN_SOLID25_T', hout='KILN_QEX2_LOAD', dtmin='KILN_DTS_VAR2'}),  -- 1326 → 1376°C
  kiln_dry_solids_qt8 = qt({tin='KILN_SOLID25_T', hin=0, tout='KILN_SOLID27_T', hout='KILN_QEX1_LOAD', dtmin='KILN_DTS_VAR1'}),  -- 1376 → 1444°C (sintering)
  -- Secondary air preheated in cooler (hot stream entering kiln at ~1078°C)
  kiln_dry_sairheat_qt9_HOT = qt({tin='KILNCC_SAIR_T', hin='KILN_DRY_SAIR_LOAD', tout='KILN_KG18_T', hout=0, dtmin=0.0001}),    -- 1078 → 425°C
}


-- ── 2.4  Clinker cooler (KILNCC_DRY) ─────────────────────────────────────────

et:addUnit('KILNCC_DRY', {type = 'Utility', Fmin = 0, Fmax = 10000000, addToProblem = 1, Mult = nil, Cinv2 = 'Cinv2_KILN_DRY'})
et['KILNCC_DRY']:addStreams{
  -- Inflows / Outflows
  kiln_dry_clkhot2_IN    = rs({'Clinker_ShortDry_Hot', 'in',  'KILNCC_CLINKER_MASSF'}),
  kilncc_dry_clk_OUT     = rs({'Clinker',              'out', 'KILNCC_CLINKER_MASSF'}),
  -- kiln_dry_atmair_IN     = rs({'Atm_Air',        'in',  'KILNCC_TOTAIR_MASSF'}),
  -- kilncc_dry_secair1_OUT = rs({'Secondary_Air',  'out', 'KILN_SAIR_MASSF'}),
  -- kilncc_dry_terair_OUT  = rs({'Tertiary_Air',   'out', 'KILN_PC_TAIR_MASSF'}),
  -- kilncc_dry_gg          = rs({'Hot_Air',        'out', 'KILN_G_MASSF'}),

  -- Heat streams — cooling air heated by clinker
  kilncc_dry_coldair1_qt1 = qt({tin='KILNCC_CAIR1_T', hin=0, tout='KILNCC_SAIR_T', hout='KILNCC_SAIR_LOAD', dtmin=0.0001}),  -- 20 → 1078°C (secondary air)
  kilncc_dry_coldair2_qt2 = qt({tin='KILNCC_CAIR1_T', hin=0, tout='KILNCC_G_T',    hout='KILNCC_G_LOAD',    dtmin=0.0001}),  -- 20 → 247°C  (grate exhaust)
  -- Clinker cooling — high-grade and low-grade sections
  kilncc_dry_hx2_qt4_HOT = qt({tin='KILN_SOLID27_T', hin='KILNCC_Q1_LOAD_kiln', tout='KILN_HREC1', hout=0, dtmin=50}),      -- 1444 → 300°C (above HREC threshold)
  kilncc_dry_HREC         = qt({tin='KILN_HREC1',     hin='KILNCC_Q1_LOAD_HREC', tout='KILN_HREC2', hout=0, dtmin=50, HC='HREC'}), -- 300 → 65°C (heat recovery, BAT 2013)
}


-- =============================================================================
-- SECTION 3: INPUT PARAMETERS
-- =============================================================================

et.inputs = {

  -- ── Kiln activation ───────────────────────────────────────────────────────
  KILN_DK_ACTIVATION = {default = 1,    unit = '-'},    -- 1 = dry kiln active
  linkCEM1           = {default = 1000, unit = '-'},    -- inter-cluster scaling links
  linkCEM2           = {default = 1000, unit = '-'},

  -- ── Cement product type flags (1 = active) ────────────────────────────────
  add_CEM1 = {default = 1, unit = '-'},   -- CEM I   42.5R
  add_CEM2 = {default = 1, unit = '-'},   -- CEM II  B-V 32.5R
  add_CEM3 = {default = 1, unit = '-'},   -- CEM III B-S 42.5R
  add_CEM4 = {default = 1, unit = '-'},   -- CEM II  B-M (V+LL)
  add_CEM5 = {default = 1, unit = '-'},   -- CEM III 42.5N
  add_CEM6 = {default = 1, unit = '-'},   -- LC3 (calcined clay blend)

  -- ── Cement mill reference production rate ────────────────────────────────
  MILL_CEM_MASSF = {default = 125000*0.5, unit = 'kg/h'},  -- total mill throughput

  -- ── Clinker-to-cement ratios (kg clinker / kg cement per type) ────────────
  -- Lower ratio = more supplementary cementitious materials (SCMs)
  KILNCC_CLINKER_RATIO1 = {default = 0.95, unit = '-'},   -- CEM I   (mostly clinker)
  KILNCC_CLINKER_RATIO2 = {default = 0.67, unit = '-'},   -- CEM II  B-V
  KILNCC_CLINKER_RATIO3 = {default = 0.70, unit = '-'},   -- CEM III B-S
  KILNCC_CLINKER_RATIO4 = {default = 0.65, unit = '-'},   -- CEM II  B-M
  KILNCC_CLINKER_RATIO5 = {default = 0.45, unit = '-'},   -- CEM III (blast furnace slag blend)
  KILNCC_CLINKER_RATIO6 = {default = 0.50, unit = '-'},   -- LC3

  -- ── Mass flow composition ratios (kg component / kg clinker) ──────────────
  KILN_SAIR_COMP      = {default = 0.68, unit = '-'},   -- secondary air
  KILN_G_COMP         = {default = 1.71, unit = '-'},   -- grate cooler exhaust air
  KILN_DRY_FG_COMP    = {default = 0.05, unit = '-'},   -- dry kiln flue gas (excluding secondary air)
  PC_flue_gas_COMP    = {default = 0.43, unit = '-'},   -- pre-calciner flue gas CO₂
  KILN_SOLID7_COMP    = {default = 1.05, unit = '-'},   -- solid material entering kiln node 7

  -- ── Specific energy and heat capacity values ──────────────────────────────
  DK_TOTAL_POWER_RATIO  = {default = 0.02,  unit = 'kWh/kg'},   -- specific electricity consumption
  DK_RM_CP              = {default = 1.06,  unit = 'kJ/kg/C'},  -- raw meal Cp
  DK_CLINKER_CP         = {default = 1.0,   unit = 'kJ/kg/C'},  -- clinker / air Cp
  DK_CL_WATER_EVAP      = {default = 0.51,  unit = 'kJ/kg/C'},  -- moisture evaporation

  -- ── Pre-heater (PH) temperature nodes ────────────────────────────────────
  RM_S1_T     = {default = 100,     unit = 'C'},   -- raw meal stream 1 inlet
  RM_S1_1_T   = {default = 476.007, unit = 'C'},   -- PH stage 1/2 interface
  RM_S1_2_T   = {default = 704.07,  unit = 'C'},   -- PH stage 2/3 interface
  RM_S2_T     = {default = 100,     unit = 'C'},   -- raw meal stream 2 inlet
  RM_S2_1_T   = {default = 746.52,  unit = 'C'},   -- PH stream 2 exit
  KILN_RM_T   = {default = 910,     unit = 'C'},   -- raw meal entry to kiln

  -- ── Pre-calciner (PC) temperature nodes ───────────────────────────────────
  PH_RM_T         = {default = 731.96, unit = 'C'},    -- PH exit / PC inlet (raw meal)
  PH_RM_1_T       = {default = 900,    unit = 'C'},    -- end of PC pre-heating stage
  PC_RM_1_T       = {default = 900,    unit = 'C'},    -- calcination reaction temperature
  PC_RM_2_T       = {default = 900,    unit = 'C'},    -- PC exit temperature
  KILN_PC_TAIR_T  = {default = 1000,   unit = '°C'},   -- tertiary air inlet temperature
  KILN_KG11_T     = {default = 1150,   unit = '°C'},   -- kiln gas inlet temperature to PC
  KILN_KG18_T     = {default = 425,    unit = '°C'},   -- PC gas exit temperature

  KILN_PC_REAC_ratio = {default = 0.466088, unit = 'kW'},   -- calcination heat per kg raw meal

  -- ── Rotary kiln solid-temperature nodes ───────────────────────────────────
  KILN_SOLID7_T   = {default = 910,     unit = 'C'},
  KILN_SOLID8_T   = {default = 910,     unit = 'C'},
  KILN_SOLID11_T  = {default = 910,     unit = 'C'},
  KILN_SOLID14_T  = {default = 910,     unit = 'C'},
  KILN_SOLID17_T  = {default = 1026,    unit = 'C'},
  KILN_SOLID20_T  = {default = 1226,    unit = 'C'},
  KILN_SOLID23_T  = {default = 1326,    unit = 'C'},
  KILN_SOLID25_T  = {default = 1376,    unit = 'C'},
  KILN_SOLID27_T  = {default = 1443.75, unit = 'C'},   -- sintering zone exit (BAT: 1400–1500°C)

  -- Minimum temperature differences for each kiln node (gas–solid)
  KILN_DTS_VAR8 = {default = 286.221, unit = '-'},
  KILN_DTS_VAR7 = {default = 275.909, unit = '-'},
  KILN_DTS_VAR6 = {default = 267.651, unit = '-'},
  KILN_DTS_VAR5 = {default = 279.429, unit = '-'},
  KILN_DTS_VAR4 = {default = 162.633, unit = '-'},
  KILN_DTS_VAR3 = {default = 207.923, unit = '-'},
  KILN_DTS_VAR2 = {default = 244.662, unit = '-'},
  KILN_DTS_VAR1 = {default = 284.741, unit = '-'},

  -- Heat exchange ratios for nodes 6–8 (negative = endothermic reaction in node)
  KILN_QEX8_ratio = {default = -0.00543, unit = '-'},
  KILN_QEX7_ratio = {default = -0.00448, unit = '-'},
  KILN_QEX6_ratio = {default =  0.00328, unit = '-'},

  -- ── Clinker cooler temperature nodes ──────────────────────────────────────
  KILNCC_CAIR1_T    = {default = 19.78,   unit = 'C'},   -- cold air inlet
  KILNCC_SAIR_T     = {default = 1078.36, unit = 'C'},   -- secondary air outlet (→ kiln)
  KILNCC_G_T        = {default = 246.82,  unit = 'C'},   -- grate exhaust air outlet
  KILNCC_CLINKER_T  = {default = 98.75,   unit = 'C'},   -- cooled clinker exit temperature

  -- HREC threshold temperatures for low-grade heat recovery (BAT 2013)
  KILN_HREC1 = {default = 300, unit = 'C'},   -- upper boundary of HREC window
  KILN_HREC2 = {default = 65,  unit = 'C'},   -- lower boundary of HREC window

  -- ── Economic parameters ───────────────────────────────────────────────────
  -- Ref: Cembureau — building a 1 Mt/y plant costs ~150 M€
  ref_plant   = {default = 1e6,       unit = 'Mt/y'},     -- reference plant capacity
  CAPEX_ref   = {default = 150000000, unit = 'EUR/y'},     -- reference CAPEX at ref_plant
  US_to_EUR   = {default = 0.84,      unit = 'EUR/US'},    -- USD→EUR conversion

  Number_year_ws   = {default = 40,   unit = 'year', description = 'Investment lifetime'},
  Interest_rate_ws = {default = 0.06, unit = '-',    description = 'Discount interest rate'},
  CEPCI_2024       = {default = 795.4, unit = '-', description = 'Current CEPCI (2024)'},
  CEPCI_2018       = {default = 603.1, unit = '-', description = 'Reference CEPCI (2018)'},
}


-- =============================================================================
-- SECTION 4: CALCULATED OUTPUTS
-- =============================================================================

et.outputs = {

  -- ── 4.1  Plasma flag (passed through from global scope) ───────────────────
  addPlasma = {job = 'CEM_addPlasma'},

  -- ── 4.2  Cement product mass flows (kg/h per type) ────────────────────────
  -- Each type is scaled from the reference mill throughput by its activation flag.
  MILL_CEM_I425R_MASSF    = {unit = 'kg/h', job = 'add_CEM1 * MILL_CEM_MASSF'},   -- CEM I   42.5R
  MILL_CEM_IIBV325R_MASSF = {unit = 'kg/h', job = 'add_CEM2 * MILL_CEM_MASSF'},   -- CEM II  B-V 32.5R
  MILL_CEM_IIBS425R_MASSF = {unit = 'kg/h', job = 'add_CEM3 * MILL_CEM_MASSF'},   -- CEM III B-S 42.5R
  MILL_CEM_IIBMVLL_MASSF  = {unit = 'kg/h', job = 'add_CEM4 * MILL_CEM_MASSF'},   -- CEM II  B-M (V+LL)
  MILL_CEM_III425N_MASSF  = {unit = 'kg/h', job = 'add_CEM5 * MILL_CEM_MASSF'},   -- CEM III 42.5N
  MILL_CEM_LC3_MASSF      = {unit = 'kg/h', job = 'add_CEM6 * MILL_CEM_MASSF'},   -- LC3

  -- ── 4.3  Clinker demand by type and total ────────────────────────────────
  -- Clinker = cement × clinker-to-cement ratio for each type
  KILNCC_CLINKER1_MASSF = {unit = 'kg/h', job = 'KILNCC_CLINKER_RATIO1 * MILL_CEM_I425R_MASSF()'},
  KILNCC_CLINKER2_MASSF = {unit = 'kg/h', job = 'KILNCC_CLINKER_RATIO2 * MILL_CEM_IIBV325R_MASSF()'},
  KILNCC_CLINKER3_MASSF = {unit = 'kg/h', job = 'KILNCC_CLINKER_RATIO3 * MILL_CEM_IIBS425R_MASSF()'},
  KILNCC_CLINKER4_MASSF = {unit = 'kg/h', job = 'KILNCC_CLINKER_RATIO4 * MILL_CEM_IIBMVLL_MASSF()'},
  KILNCC_CLINKER5_MASSF = {unit = 'kg/h', job = 'KILNCC_CLINKER_RATIO5 * MILL_CEM_III425N_MASSF()'},
  KILNCC_CLINKER6_MASSF = {unit = 'kg/h', job = 'KILNCC_CLINKER_RATIO6 * MILL_CEM_LC3_MASSF()'},
  KILNCC_CLINKER_MASSF  = {unit = 'kg/h', job =
    'KILNCC_CLINKER1_MASSF() + KILNCC_CLINKER2_MASSF() + KILNCC_CLINKER3_MASSF() +' ..
    'KILNCC_CLINKER4_MASSF() + KILNCC_CLINKER5_MASSF() + KILNCC_CLINKER6_MASSF()'},

  -- ── 4.4  Raw meal and kiln gas mass flows ────────────────────────────────
  -- RAWMEAL_COMP: kg raw meal / kg clinker (includes kiln FG and pre-calciner FG fractions)
  RAWMEAL_COMP        = {unit = 'kg/kg', job = '1 + KILN_DRY_FG_COMP + PC_flue_gas_COMP'},
  RAWMEAL_MASSF       = {unit = 'kg/h',  job = 'RAWMEAL_COMP() * KILNCC_CLINKER_MASSF()'},
  KILN_RAWMEAL_COMP   = {unit = '-',     job = 'RAWMEAL_COMP() - PC_flue_gas_COMP'},       -- excludes PC gas fraction
  KILN_RAWMEAL_MASSF  = {unit = 'kg/h',  job = 'KILN_RAWMEAL_COMP() * KILNCC_CLINKER_MASSF()'},
  PC_flue_gas_MASSF   = {unit = 'kg/h',  job = 'PC_flue_gas_COMP * KILNCC_CLINKER_MASSF()'},
  KILN_CLINKERHOT_MASSF = {unit = 'kg/h',job = 'KILNCC_CLINKER_MASSF()'},
  KILN_KG11_MASSF     = {unit = 'kg/h',  job = '(KILNCC_CLINKER_MASSF() * KILN_DRY_FG_COMP) + KILN_SAIR_MASSF()'},
  KILN_SAIR_MASSF     = {unit = 'kg/h',  job = 'KILNCC_CLINKER_MASSF() * KILN_SAIR_COMP'},
  KILN_G_MASSF        = {unit = 'kg/h',  job = 'KILNCC_CLINKER_MASSF() * KILN_G_COMP'},
  KILNCC_TOTAIR_MASSF = {unit = 'kg/h',  job = 'KILNCC_CLINKER_MASSF() + KILNCC_TOTAIR_COMP()'},
  KILNCC_TOTAIR_COMP  = {unit = '-',     job = 'KILN_SAIR_COMP + KILN_G_COMP'},
  KILN_DRY_TOTAL_POWER= {unit = 'kW',    job = 'DK_TOTAL_POWER_RATIO * KILNCC_CLINKER_MASSF()'},

  -- ── 4.5  Pre-heater heat loads ────────────────────────────────────────────
  -- Q = mass_flow × Cp × ΔT / 3600 (converts kg/h·kJ/kg/C → kW)
  PHT_HT1_LOAD  = {unit = 'kW', job = '(RM_S1_1_T - RM_S1_T)   * DK_RM_CP * RAWMEAL_MASSF() / 3600'},  -- 100 → 476°C
  PHT32_LOAD    = {unit = 'kW', job = '(RM_S1_2_T - RM_S1_1_T) * DK_RM_CP * RAWMEAL_MASSF() / 3600'},  -- 476 → 704°C
  PH_HT2_LOAD   = {unit = 'kW', job = '(RM_S2_1_T - RM_S2_T)   * DK_RM_CP * RAWMEAL_MASSF() / 3600'},  -- 100 → 746°C
  PH_HT31_LOAD  = {unit = 'kW', job = '(KILN_RM_T - PC_RM_2_T) * DK_RM_CP * KILN_RAWMEAL_MASSF() / 3600'},  -- 900 → 910°C

  -- ── 4.6  Pre-calciner heat loads ──────────────────────────────────────────
  PC_PREHEAT_LOAD    = {unit = 'kW', job = '(PH_RM_1_T - PH_RM_T)      * DK_RM_CP * RAWMEAL_MASSF() / 3600'},
  KILN_PC_REAC_LOAD  = {unit = 'kW', job = 'RAWMEAL_MASSF() * KILN_PC_REAC_ratio'},                          -- calcination reaction heat
  KILN_DRY_TAIR_LOAD = {unit = 'kW', job = '(KILN_PC_TAIR_T - KILN_KG18_T) * DK_RM_CP * RAWMEAL_MASSF() / 3600'},  -- tertiary air cooling
  KILN_KILNGAS_LOAD  = {unit = 'kW', job = '(KILN_KG11_T - KILN_KG18_T)    * DK_RM_CP * RAWMEAL_MASSF() / 3600'},  -- kiln gas cooling in PC

  -- ── 4.7  Rotary kiln heat loads (8 solid nodes) ───────────────────────────
  -- Nodes 8, 7, 6: ratios applied directly (include endothermic reactions)
  KILN_QEX8_LOAD = {unit = 'kW', job = 'KILNCC_CLINKER_MASSF() * KILN_QEX8_ratio'},
  KILN_QEX7_LOAD = {unit = 'kW', job = 'KILNCC_CLINKER_MASSF() * KILN_QEX7_ratio'},
  KILN_QEX6_LOAD = {unit = 'kW', job = 'KILNCC_CLINKER_MASSF() * KILN_QEX6_ratio'},
  -- Nodes 5–1: sensible heat (ΔT × Cp × mass × KILN_SOLID7_COMP)
  KILN_QEX5_LOAD = {unit = 'kW', job = '(KILN_SOLID17_T-KILN_SOLID14_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() * KILN_SOLID7_COMP / 3600'},
  KILN_QEX4_LOAD = {unit = 'kW', job = '(KILN_SOLID20_T-KILN_SOLID17_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() * KILN_SOLID7_COMP / 3600'},
  KILN_QEX3_LOAD = {unit = 'kW', job = '(KILN_SOLID23_T-KILN_SOLID20_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() * KILN_SOLID7_COMP / 3600'},
  KILN_QEX2_LOAD = {unit = 'kW', job = '(KILN_SOLID25_T-KILN_SOLID23_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() * KILN_SOLID7_COMP / 3600'},
  KILN_QEX1_LOAD = {unit = 'kW', job = '(KILN_SOLID27_T-KILN_SOLID25_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() * KILN_SOLID7_COMP / 3600'},

  -- ── 4.8  Clinker cooler heat loads ────────────────────────────────────────
  KILNCC_SAIR_LOAD       = {unit = 'kW', job = '(KILNCC_SAIR_T-KILNCC_CAIR1_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() / 3600'},  -- secondary air heating
  KILNCC_G_LOAD          = {unit = 'kW', job = '(KILNCC_G_T-KILNCC_CAIR1_T)    * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() / 3600'},  -- grate exhaust heating
  KILN_DRY_SAIR_LOAD     = {unit = 'kW', job = '(KILNCC_SAIR_T-KILN_KG18_T)   * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() / 3600'},  -- secondary air cooling in kiln
  KILNCC_Q1_LOAD         = {unit = 'kW', job = '(KILN_SOLID27_T-KILNCC_CLINKER_T) * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() / 3600'},  -- total clinker cooling duty
  KILNCC_Q1_LOAD_kiln    = {unit = 'kW', job = '(KILN_SOLID27_T-KILN_HREC1)    * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() / 3600'},  -- above HREC window
  KILNCC_Q1_LOAD_HREC    = {unit = 'kW', job = '(KILN_HREC1-KILN_HREC2)        * DK_CLINKER_CP * KILNCC_CLINKER_MASSF() / 3600'},  -- HREC window (300→65°C)

  -- ── 4.9  CO₂ emissions ────────────────────────────────────────────────────
  -- CO₂ from kiln = FG fraction of total kiln gas (carbonate decomposition + fuel combustion)
  RATIO_DRYKILN_FUMES_IMPACT = {unit = 'kg/kg', job = 'KILN_DRY_FG_COMP / (KILN_DRY_FG_COMP + KILN_SAIR_COMP)'},  -- 0.05 / (0.05 + 0.68)
  KILN_IMPACT                = {unit = 'kg/h',  job = 'RATIO_DRYKILN_FUMES_IMPACT() * KILN_KG11_MASSF()'},

  -- ── 4.10  Economics ───────────────────────────────────────────────────────
  -- Annuity factor for CAPEX annualisation over Number_year_ws at Interest_rate_ws
  Annuity = {unit = '-', job = '(Interest_rate_ws*(Interest_rate_ws+1)^Number_year_ws)/((Interest_rate_ws+1)^Number_year_ws-1)'},

  -- Plasma technology reduces kiln CAPEX by 10% (simpler combustion system)
  CAPEX_adjustment = {job = function()
    if     addPlasma == 1 then return 0.9
    elseif addPlasma == 0 then return 1.0
    else                       return 1.0
    end
  end},

  -- Cinv2 = adjustment × CAPEX_ref × (actual_Mt/y / ref_Mt/y) × CEPCI_escalation × Annuity
  Cinv2_KILN_DRY = {unit = 'EUR/y',
    job = 'CAPEX_adjustment() * CAPEX_ref * ((KILNCC_CLINKER_MASSF()*8.76) / ref_plant) * (CEPCI_2024/CEPCI_2018) * Annuity()'},
}

return et