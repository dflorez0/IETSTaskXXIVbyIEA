local osmose = require 'osmose'
local ET = osmose.Model 'MTO_ET'

ET.header = {
  name = '',
  displayName = '',
  authors = {'Oktay BOZTAS, EPFL IPESE research group', 'Meire RIBEIRO DOMINGOS, EPFL IPESE research group',
             'Daniel FLÓREZ-ORREGO, EPFL IPESE research group'},
  developers = {''},
  contributors = {''},
  creation_date = '12.2024',
  updates = {'21.10.2026'},
  versions = {'2.3'},
  confidentiality = {'Open'},
  title = 'olefins production from methanol (MTO process) and products separation',
  description = [[Light olefins (mainly ethylene and propylene) are produced from methanol, the products are separated by cryogenic distillation, and an olefin cracker improves the light olefin yield.]],
  references = {'Hannula, I., Arpiainen, V., Light olefins and transport fuels from biomass residues via synthetic methanol: performance and cost analysis. Biomass Conversion and Biorefinery 5 (2015) 63-74. https://doi.org/10.1007/s13399-014-0123-9',
                'Boztas, O., Ribeiro-Domingos, M., Flórez-Orrego, D., Maréchal, F., Techno-economic and environmental assessment of sustainable thermochemical pathways for olefins production promoting carbon circularity. Renewable Energy (2025) 124303. https://doi.org/10.1016/j.renene.2025.124303'},
  adaptedwith = {},
  notes =  {}
}


ET.inputs = {
  
  dtmin_gas={default = 8,unit = 'C'},
  dtmin_liq={default = 5,unit = 'C'},
  dtmin_2ph={default = 2,unit = 'C'},
 
  -- Plant size: 10,000 kg/h methanol. Products: 1919.7 kg/h ethylene (99.93 mol%),
  -- 1950.7 kg/h propylene (99.91 mol%), both polymer grade.
  -- Source of all figures: Aspen Plus, NEW_Biofins_MainProcess_Final, run of 21.10.2026.

  ----------------------------
  -- Overall Material Flows --
  ----------------------------

 meoh_input = {default = 10000, unit ='kg/h'}, -- Pure methanol inlet
 ethylene_output =  {default = 1919.7, unit ='kg/h'}, -- Aspen S48, 99.93 mol%
 propylene_output =  {default = 1950.7, unit ='kg/h'}, -- Aspen S76, 99.91 mol%
 butene_output =  {default = 66.0, unit ='kg/h'}, -- Aspen S73, 99.5 mol%
 -- CO2 leaves at three points; CO2_inFlueGas below sums them. Both combustions use
 -- pure O2, so after condensing the water at 25 C the CO2 is pure (S54 keeps
 -- 10.2 kg/h saturation water, not counted here).
 CO2_regen    =  {default = 485.7,  unit ='kg/h'}, -- coke burn in the regenerator; Aspen S85
 CO2_combust  =  {default = 894.9, unit ='kg/h'}, -- oxy-combustion of the non-valuable streams; Aspen S54
 CO2_wash     =  {default = 5.2, unit ='kg/h'}, -- CO2 removed by WASH; Aspen S82
 WasteWater_output = {default = 5596, unit ='kg/h'}, -- process waste water; Aspen S74
 WasteWater_flash  = {default = 10.2, unit ='kg/h'}, -- water from flash B11; Aspen S36
 H2O_inFlueGas = {default = 571.8, unit ='kg/h'}, -- condensed from the combustor flue gas at 25 C; Aspen S83
 -- Oxygen enters at two points; Total_oxygen_inlet in ET.outputs sums them.
 -- Both are stoichiometric.
 oxygen_regen   = {default = 353.2,  unit ='kg/h'}, -- O2 for burning coke off the catalyst; Aspen S11
 oxygen_combust = {default = 1157.3, unit ='kg/h'}, -- O2 for oxy-combustion of the non-valuable streams; Aspen S49

   --------------------------------------------
   --      Heat and Electricity Streams      --
   --------------------------------------------

 -- Methanol Pump
 e_mto_1   = {default = 1.03, unit ='kW'}, 

 
 -- Pre-heating of methanol infeed --

 -- Vapor fraction 0 
 mto_c1_ti   =  {default = 25, unit = 'C'},
 mto_c1_to   =  {default = 94, unit = 'C'},
 mto_c1_ho   = {default = 705.2, unit ='kW'},

-- Vapor fraction 1

  mto_c2_ti   =  {default = 94, unit = 'C'},
  mto_c2_to   =  {default = 94, unit = 'C'},
  mto_c2_ho   = {default = 3061, unit ='kW'},

-- Pre-heating of reactor feed
 mto_c3_ti   =  {default = 107, unit = 'C'},
 mto_c3_to   =  {default = 310, unit = 'C'},
 mto_c3_ho   = {default = 1316, unit ='kW'},

-- Steam Generation --

-- Vapor fraction 0 

mto_c4_ti   =  {default = 25, unit = 'C'},
mto_c4_to   =  {default = 132.7, unit = 'C'},
mto_c4_ho   = {default = 307.0, unit ='kW'},

-- Vapor fraction 1

mto_c5_ti   =  {default = 132.7, unit = 'C'},
mto_c5_to   =  {default = 134.4, unit = 'C'},
mto_c5_ho   = {default = 1402, unit ='kW'},

-- MTO REACTOR --
-- Fluidised bed with continuous catalyst regeneration. Well mixed, so the bed is
-- isothermal at the outlet temperature and the heat is available at 410 C. Feed
-- enters at 310 C and is heated by the bed itself.
-- -1660 kW is the NET duty from Aspen: gross exotherm (-2383 kW, 27.5 kJ/mol MeOH)
-- less the 749 kW that heats the reacting stream from 310 to 410 C. That internal
-- heating is already inside this figure and must NOT be added as a cold stream.

mto_h22_ti   =  {default = 410, unit = 'C'},
mto_h22_to   =  {default = 410, unit = 'C'},
mto_h22_ho   = {default = -1660, unit ='kW'},

-- COKE COMBUSTION: FLUE GAS COOLING --

mto_h1_ti   =  {default = 1000, unit = 'C'},
mto_h1_to   =  {default = 1000, unit = 'C'},
mto_h1_ho   = {default = -1075, unit ='kW'},

mto_h18_ti   =  {default = 1000, unit = 'C'},
mto_h18_to   =  {default = 25, unit = 'C'},
mto_h18_ho   = {default = -149, unit ='kW'},


-- MTO PRODUCT QUENCH --
-- Effluent cooling + quench tower at 3 bar, 12117 kg/h reactor product.
-- Water is 78 mol% of the product, so the dew point is 126 C and 35% of the duty
-- comes out in the 8 K below it. Split into four segments because MCp runs
-- 7 -> 359 -> 84 -> 20 kW/K: a single linear stream would place this heat at
-- temperatures where it does not exist. Segments map to real hardware -- _a is the
-- effluent cooler / waste heat boiler, _b.._d are quench tower pumparounds.
-- Duties from Aspen (B60 / B61 / B62 / B1); vapour fraction shown is MOLE basis.
-- Note VF bottoms out at 0.22: the hydrocarbons never condense.

-- _a  dry gas, sensible only                                   VF 1.00 -> 1.00
mto_h2_ti_a   =  {default = 410, unit = 'C'},
mto_h2_to_a   =  {default = 126, unit = 'C'},
mto_h2_ho_a   = {default = -2052, unit ='kW'},

-- _b  bulk condensation, reaches mto_c8 C3 reboiler at 116 C   VF 1.00 -> 0.56
mto_h2_ti_b   =  {default = 126, unit = 'C'},
mto_h2_to_b   =  {default = 118, unit = 'C'},
mto_h2_ho_b   = {default = -2872, unit ='kW'},

-- _c  condensation, reaches mto_c2 MeOH vaporiser at 94 C      VF 0.56 -> 0.31
mto_h2_ti_c   =  {default = 118, unit = 'C'},
mto_h2_to_c   =  {default = 96, unit = 'C'},
mto_h2_ho_c   = {default = -1858, unit ='kW'},

-- _d  tail condensation + subcooling                           VF 0.31 -> 0.22
mto_h2_ti_d   =  {default = 96, unit = 'C'},
mto_h2_to_d   =  {default = 25, unit = 'C'},
mto_h2_ho_d   = {default = -1407, unit ='kW'},

-- MTO PRODUCT COMPRESSION: 3 BAR -> 9 BAR --

e_mto_2   = {default = 118, unit ='kW'}, 

mto_h3_ti   =  {default = 88, unit = 'C'},
mto_h3_to   =  {default = 25, unit = 'C'},
mto_h3_ho   = {default = -133, unit ='kW'},

-- MTO PRODUCT COMPRESSION: 9 BAR -> 25 BAR --


e_mto_3   = {default = 109.5, unit ='kW'}, -- Aspen block B17

mto_h4_ti   =  {default = 92, unit = 'C'},
mto_h4_to   =  {default = 25, unit = 'C'},
mto_h4_ho   = {default = -298, unit ='kW'},

-- DISTILLATION --

-- Cooling before 1st distillation column

mto_h5_ti   =  {default = 27.8, unit = 'C'},
mto_h5_to   =  {default = 10, unit = 'C'},
mto_h5_ho   = {default = -196, unit ='kW'},

-- DEETHANIZER -- 

--REBOILER

mto_c7_ti   =  {default = 69, unit = 'C'},
mto_c7_to   =  {default = 69, unit = 'C'},
mto_c7_ho   = {default = 699, unit ='kW'},

--CONDENSER

mto_h6_ti   =  {default = -24, unit = 'C'},
mto_h6_to   =  {default = -24, unit = 'C'},
mto_h6_ho   = {default = -581, unit ='kW'},

-- DEPROPANIZER distillation column -- 

--REBOILER

mto_c8_ti   =  {default = 116, unit = 'C'},
mto_c8_to   =  {default = 116, unit = 'C'},
mto_c8_ho   = {default = 517, unit ='kW'},

--CONDENSER

mto_h7_ti   =  {default = 59, unit = 'C'},
mto_h7_to   =  {default = 59, unit = 'C'},
mto_h7_ho   = {default = -499, unit ='kW'},

-- C3 split distillation column -- 

--REBOILER

mto_c9_ti   =  {default = 61, unit = 'C'},
mto_c9_to   =  {default = 61, unit = 'C'},
mto_c9_ho   = {default = 1507, unit ='kW'},

--CONDENSER

mto_h8_ti   =  {default = 59, unit = 'C'},
mto_h8_to   =  {default = 59, unit = 'C'},
mto_h8_ho   = {default = -1509, unit ='kW'},

-- DEMETHANIZER distillation column --

e_mto_4   = {default = 12.4, unit ='kW'}, -- Aspen block B38, booster 25 -> 33 bar

-- Column feed cooling
-- Dew point of the compressed deethaniser overhead at 33 bar is -9 C, so the duty is
-- strongly non-linear: 89% of it falls in the 11 K below that. Two segments (Aspen
-- B64 / B19) keep the composite curve honest -- as one straight line the model would
-- offer ~22 kW between -2 and -6 C against the -8 C reboiler mto_c10, where only
-- ~4 kW really exists. One physical exchanger, two segments for the curve shape.

-- _a  dry gas, sensible only          VF 1.00 -> 1.00
mto_h9_ti_a   =  {default = -2, unit = 'C'},
mto_h9_to_a   =  {default = -9, unit = 'C'},
mto_h9_ho_a   = {default = -9.59, unit ='kW'},

-- _b  partial condensation            VF 1.00 -> 0.57
mto_h9_ti_b   =  {default = -9, unit = 'C'},
mto_h9_to_b   =  {default = -20, unit = 'C'},
mto_h9_ho_b   = {default = -88, unit ='kW'},

-- 35 stages, 33 bar, feed stage 12, molar reflux ratio 8, D/F 0.142.

--REBOILER

mto_c10_ti   =  {default = -8.3, unit = 'C'},
mto_c10_to   =  {default = -8.3, unit = 'C'},
mto_c10_ho   = {default = 114.1, unit ='kW'},

--CONDENSER

mto_h10_ti   =  {default = -104.1, unit = 'C'},
mto_h10_to   =  {default = -104.1, unit = 'C'},
mto_h10_ho   = {default = -178.0, unit ='kW'},

-- C2SPLIT distillation column --
-- 70 stages, 33 bar, feed stage 40, molar reflux ratio 4.5, D/F 0.958.

--REBOILER

mto_c11_ti   =  {default = 32.3, unit = 'C'},
mto_c11_to   =  {default = 32.3, unit = 'C'},
mto_c11_ho   = {default = 695.8, unit ='kW'},

--CONDENSER

mto_h11_ti   =  {default = -9.7, unit = 'C'},
mto_h11_to   =  {default = -9.7, unit = 'C'},
mto_h11_ho   = {default = -694.0, unit ='kW'},

-- OLEFIN CRACKER --

-- Cracker pre-heating-- 
mpreheat_lat_ti   =  {default = 0.6, unit = 'C'}, -- depropaniser bottoms after letdown to 1 bar
mpreheat_lat_to   =  {default = 4.5, unit = 'C'},
mpreheat_lat_ho  = {default = 23.4, unit ='kW'},

mpreheat_ti   =  {default = 4.5, unit = 'C'},
mpreheat_to  =  {default = 450, unit = 'C'},
mpreheat_ho   = {default = 235, unit ='kW'},

-- Cracker -- 
mto_c12_ti   =  {default = 450, unit = 'C'},
mto_c12_to   =  {default = 600, unit = 'C'},
mto_c12_ho   = {default = 304, unit ='kW'},

-- Cracker product cooling 

mto_h12_ti_a   =  {default = 600, unit = 'C'},
mto_h12_to_a   =  {default = 25, unit = 'C'},
mto_h12_ho_a  = {default = -328, unit ='kW'},


-- Cracker product compression -- 

e_mto_5   = {default = 22.49, unit ='kW'}, 

mto_h13_ti   =  {default = 85, unit = 'C'},
mto_h13_to   =  {default = 25, unit = 'C'},
mto_h13_ho   = {default = -23, unit ='kW'},

e_mto_6   = {default = 22, unit ='kW'}, 

mto_h14_ti   =  {default = 86, unit = 'C'},
mto_h14_to   =  {default = 10, unit = 'C'},
mto_h14_ho   = {default = -30.0, unit ='kW'},

-- 1st distillation after OCM --

--REBOILER

mto_c13_ti   =  {default = 61, unit = 'C'},
mto_c13_to   =  {default = 61, unit = 'C'},
mto_c13_ho   = {default = 59, unit ='kW'},

--CONDENSER

mto_h15_ti   =  {default = -10, unit = 'C'},
mto_h15_to   =  {default = -10, unit = 'C'},
mto_h15_ho   = {default = -70.0, unit ='kW'},

-- Recycle compression --
-- The mto_h15 overhead is taken to the compressor at -10 C without superheating:
-- colder suction means ~12% less shaft work and a smaller machine.

-- No interstage cooling: the two stages run back to back.
e_mto_7   = {default = 8.87, unit ='kW'},
e_mto_8   = {default = 9.63, unit ='kW'},

-- Propylene/Propane Distillation Bottom Product

mto_c15_ti   =  {default = 12, unit = 'C'},
mto_c15_to   =  {default = 25, unit = 'C'},
mto_c15_ho   = {default = 3.85, unit ='kW'},

-- Ethylene/Ethane Distillation Bottom Product

mto_c16_ti   =  {default = 1.1, unit = 'C'},
mto_c16_to   =  {default = 25, unit = 'C'},
mto_c16_ho   = {default = 8.26, unit ='kW'},

mto_c17_ti   =  {default = 10, unit = 'C'},
mto_c17_to   =  {default = 25, unit = 'C'},
mto_c17_ho   = {default = 0.74, unit ='kW'},

-- Fuel Gas 

mto_c18_ti   =  {default = -104.1, unit = 'C'},
mto_c18_to   =  {default = 25, unit = 'C'},
mto_c18_ho   = {default = 15.56, unit ='kW'},

-- ETHYLENE PRODUCT EXPORT --
-- C2 splitter distillate is pumped from column pressure to 80 bar, i.e. above the
-- 50.42 bar critical pressure, for dense-phase pipeline export.

e_mto_9   = {default = 21.3, unit ='kW'},

-- PROPYLENE PRODUCT EXPORT --
-- Propylene/propane splitter distillate leaves the condenser (mto_h8) as saturated
-- liquid at 59 C / 24.8 bar. It is cooled to ambient for transfer to the polymer
-- plant; no letdown, since the column pressure is already the transfer pressure and
-- the receiving feed pumps need the NPSH. Single phase liquid throughout: at 25 bar
-- the bubble point is 59 C, so the rundown leaves 34 K of subcooling.
-- Duty from Peng-Robinson: dh = -105.5 kJ/kg over 59 -> 25 C (mean cp 3.10 kJ/kg.K).

mto_h20_ti   =  {default = 59, unit = 'C'},
mto_h20_to   =  {default = 25, unit = 'C'},
mto_h20_ho   = {default = -55.38, unit ='kW'},

-- BUTENE PRODUCT EXPORT --
-- Bottoms of column B32 (after the olefin cracker), saturated liquid at 61 C / 8 bar. Cooled to ambient before
-- letdown to the storage bullet (10 barg design, floating at the contents' own
-- vapour pressure, 2.97 bar at 25 C). Cooling BEFORE the letdown is what keeps this
-- single phase: at 25 C the bubble point at 8 bar is far above, so nothing flashes.
-- Duty from Peng-Robinson: dh = -88.5 kJ/kg over 61 -> 25 C (mean cp 2.46 kJ/kg.K).
-- Note the inlet is near saturation (Psat = 7.9 bar at 61 C vs the 8 bar line), so
-- inlet piping pressure drop must stay small or the feed flashes before the cooler.

mto_h21_ti   =  {default = 61, unit = 'C'},
mto_h21_to   =  {default = 25, unit = 'C'},
mto_h21_ho   = {default = -1.6, unit ='kW'},

-- OXY-COMBUSTION: FLUE GAS COOLING --
-- Heat released at 1000 C (Aspen B31), then the flue gas is cooled to 25 C at 1 bar
-- (B40, B33). It is 61 mol% water: the dew point is 88.1 C, and the condensing part
-- is split in three segments from the Aspen heat curve of B33.

mto_h17_ti   =  {default = 1000, unit = 'C'},
mto_h17_to   =  {default = 1000, unit = 'C'},
mto_h17_ho   = {default = -3579, unit ='kW'},

-- dry gas, sensible only
mto_h19_ti   =  {default = 1000, unit = 'C'},
mto_h19_to   =  {default = 88.1, unit = 'C'},
mto_h19_ho   = {default = -580.8, unit ='kW'},

-- condensation                        VF 1.00 -> 0.59
mto_h23_ti_a   =  {default = 88.1, unit = 'C'},
mto_h23_to_a   =  {default = 74.4, unit = 'C'},
mto_h23_ho_a   = {default = -265.1, unit ='kW'},

-- condensation                        VF 0.59 -> 0.43
mto_h23_ti_b   =  {default = 74.4, unit = 'C'},
mto_h23_to_b   =  {default = 48.1, unit = 'C'},
mto_h23_ho_b   = {default = -128.0, unit ='kW'},

-- condensation                        VF 0.43 -> 0.40
mto_h23_ti_c   =  {default = 48.1, unit = 'C'},
mto_h23_to_c   =  {default = 25, unit = 'C'},
mto_h23_ho_c   = {default = -42.7, unit ='kW'},

 }

ET.outputs = {

 
  -- Total demands 
 
  e_demand = {unit='kW',job='e_mto_1+e_mto_2+e_mto_3+e_mto_4+e_mto_5+e_mto_6+e_mto_7+e_mto_8+e_mto_9'}, -- Total electricity requirement

  -- Oxygen, CO2 and waste water leave or enter at several points; sum them here so
  -- the layer balance still sees one figure per resource.
  Total_oxygen_inlet = {unit='kg/h', job='oxygen_regen+oxygen_combust'},
  CO2_inFlueGas      = {unit='kg/h', job='CO2_regen+CO2_combust+CO2_wash'},
  -- process waste water, flash water and the condensate recovered from the flue gas
  WasteWater_total   = {unit='kg/h', job='WasteWater_output+WasteWater_flash+H2O_inFlueGas'},

}

-----------
-- Layers
-----------
ET:addLayers {Elec = {type= 'ResourceBalance', unit = 'kW'}} -- power consumption in the MTO plant
-- ET:addLayers {MeohMass = {type= 'ResourceBalance', unit = 'kg/h'}} -- meoh mass for olefin production process
ET:addLayers {MeohProd = {type= 'ResourceBalance', unit = 'kg/h'}} -- meoh product
ET:addLayers {Butene = {type= 'ResourceBalance', unit = 'kg/h'}} -- butene produced in MTO reaction
ET:addLayers {Propylene = {type= 'ResourceBalance', unit = 'kg/h'}} -- propene produced in MTO reaction
ET:addLayers {Ethylene = {type= 'ResourceBalance', unit = 'kg/h'}} -- ethylene produced in MTO reaction
ET:addLayers {CO2pure = {type= 'ResourceBalance', unit = 'kg/h'}}
ET:addLayers {WasteWater = {type= 'ResourceBalance', unit = 'kg/h'} }
ET:addLayers {Oxygen = {type= 'ResourceBalance', unit = 'kg/h'} }

-----------
-- Units
-----------

ET:addUnit('MTO',{type='Process', Fmin = 1, Fmax = 1, Cost1=0, Cost2=0, Cinv1=0, Cinv2=0})
ET['MTO']:addStreams{
  
  --electrical
   elec_tot = rs({'Elec', 'in', 'e_demand'}), -- check
  
  
  -- waste water production
   wastewater_out = rs({'WasteWater', 'out', 'WasteWater_total'}), -- process water + flue gas condensate

  -- oxygen required for combustion

   oxygen_in = rs({'Oxygen', 'in', 'Total_oxygen_inlet'}),


  -- Marketable products
   butene_out = rs({'Butene', 'out', 'butene_output'}), -- produced butene (kg/h) to market
   propylene_out = rs({'Propylene', 'out', 'propylene_output'}), -- produced propylene (kg/h) to market
   ethylene_out = rs({'Ethylene', 'out', 'ethylene_output'}), -- produced ethylene (kg/h) to market
    
  -- Methanol Consumed
   meoh_cons = rs({'MeohProd', 'in', 'meoh_input'}), -- updated layer unit to kg/h

   -- CO2 produced
    CO2pureout = rs({'CO2pure', 'out', 'CO2_inFlueGas'}), -- pure CO2 once the water is condensed -- in kg/h CO2 in rich fluegas, outlet, 1 bar, can go back to carbon capture unit for further olefins production
  
  ----==== mto streams ===----

   --Thermal
    --Cold Curve
    qt_c110 = qt({tin = 'mto_c1_ti', hin = 0, tout='mto_c1_to', hout='mto_c1_ho', dtmin='dtmin_liq'}), --checked
    qt_c111 = qt({tin = 'mto_c2_ti', hin = 0, tout='mto_c2_to', hout='mto_c2_ho', dtmin='dtmin_2ph'}), -- checked
    qt_c112 = qt({tin = 'mto_c3_ti', hin = 0, tout='mto_c3_to', hout='mto_c3_ho', dtmin='dtmin_gas'}), -- checked
    qt_c113 = qt({tin = 'mto_c4_ti', hin = 0, tout='mto_c4_to', hout='mto_c4_ho', dtmin='dtmin_liq'}), -- checked
    qt_c114 = qt({tin = 'mto_c5_ti', hin = 0, tout='mto_c5_to', hout='mto_c5_ho', dtmin='dtmin_2ph'}),--checked
    qt_c116 = qt({tin = 'mto_c7_ti', hin = 0, tout='mto_c7_to', hout='mto_c7_ho', dtmin='dtmin_2ph'}),--checked
    qt_c117 = qt({tin = 'mto_c8_ti', hin = 0, tout='mto_c8_to', hout='mto_c8_ho', dtmin='dtmin_2ph'}),--checked
    qt_c118 = qt({tin = 'mto_c9_ti', hin = 0, tout='mto_c9_to', hout='mto_c9_ho', dtmin='dtmin_2ph'}),--checked
    qt_c119 = qt({tin = 'mto_c10_ti', hin = 0, tout='mto_c10_to', hout='mto_c10_ho', dtmin='dtmin_2ph'}),--checked
    qt_c120 = qt({tin = 'mto_c11_ti', hin = 0, tout='mto_c11_to', hout='mto_c11_ho', dtmin='dtmin_2ph'}),--checked
    qt_c121_a = qt({tin = 'mpreheat_lat_ti', hin = 0, tout='mpreheat_lat_to', hout='mpreheat_lat_ho', dtmin='dtmin_2ph'}),--checked
    qt_c121_b = qt({tin = 'mpreheat_ti', hin = 0, tout='mpreheat_to', hout='mpreheat_ho', dtmin='dtmin_gas'}), -- vapour heating, was dtmin_liq
    qt_c121 = qt({tin = 'mto_c12_ti', hin = 0, tout='mto_c12_to', hout='mto_c12_ho', dtmin='dtmin_gas'}), -- gas-phase reactor, was dtmin_2ph
    qt_c122 = qt({tin = 'mto_c13_ti', hin = 0, tout='mto_c13_to', hout='mto_c13_ho', dtmin='dtmin_2ph'}),--checked
    qt_c124 = qt({tin = 'mto_c15_ti', hin = 0, tout='mto_c15_to', hout='mto_c15_ho', dtmin='dtmin_2ph'}),--checked
    qt_c125 = qt({tin = 'mto_c16_ti', hin = 0, tout='mto_c16_to', hout='mto_c16_ho', dtmin='dtmin_2ph'}),--checked
    qt_c126 = qt({tin = 'mto_c17_ti', hin = 0, tout='mto_c17_to', hout='mto_c17_ho', dtmin='dtmin_gas'}),--checked
    qt_c127 = qt({tin = 'mto_c18_ti', hin = 0, tout='mto_c18_to', hout='mto_c18_ho', dtmin='dtmin_gas'}),--checked



    --Hot curve
    qt_h131 = qt({tin = 'mto_h22_ti', hin = 0, tout='mto_h22_to', hout='mto_h22_ho', dtmin='dtmin_gas'}),--checked
     qt_h110 = qt({tin = 'mto_h1_ti', hin = 0, tout='mto_h1_to', hout='mto_h1_ho', dtmin='dtmin_gas'}),--checked
     qt_h111a = qt({tin = 'mto_h2_ti_a', hin = 0, tout='mto_h2_to_a', hout='mto_h2_ho_a', dtmin='dtmin_gas'}), -- quench: dry gas 410->126
     qt_h111b = qt({tin = 'mto_h2_ti_b', hin = 0, tout='mto_h2_to_b', hout='mto_h2_ho_b', dtmin='dtmin_2ph'}), -- quench: bulk condensation 126->118
     qt_h111c = qt({tin = 'mto_h2_ti_c', hin = 0, tout='mto_h2_to_c', hout='mto_h2_ho_c', dtmin='dtmin_2ph'}), -- quench: condensation 118->96
     qt_h111d = qt({tin = 'mto_h2_ti_d', hin = 0, tout='mto_h2_to_d', hout='mto_h2_ho_d', dtmin='dtmin_2ph'}), -- quench: tail 96->25
     qt_h112 = qt({tin = 'mto_h3_ti', hin = 0, tout='mto_h3_to', hout='mto_h3_ho', dtmin='dtmin_gas'}),--checked
     qt_h113 = qt({tin = 'mto_h4_ti', hin = 0, tout='mto_h4_to', hout='mto_h4_ho', dtmin='dtmin_2ph'}),--checked
     qt_h114 = qt({tin = 'mto_h5_ti', hin = 0, tout='mto_h5_to', hout='mto_h5_ho', dtmin='dtmin_2ph'}),--checked
     qt_h115 = qt({tin = 'mto_h6_ti', hin = 0, tout='mto_h6_to', hout='mto_h6_ho', dtmin='dtmin_2ph'}),--checked
     qt_h116 = qt({tin = 'mto_h7_ti', hin = 0, tout='mto_h7_to', hout='mto_h7_ho', dtmin='dtmin_2ph'}),--checked
     qt_h117 = qt({tin = 'mto_h8_ti', hin = 0, tout='mto_h8_to', hout='mto_h8_ho', dtmin='dtmin_2ph'}),--checked
     qt_h118a = qt({tin = 'mto_h9_ti_a', hin = 0, tout='mto_h9_to_a', hout='mto_h9_ho_a', dtmin='dtmin_gas'}), -- demethaniser feed: dry gas -1->-9
     qt_h118b = qt({tin = 'mto_h9_ti_b', hin = 0, tout='mto_h9_to_b', hout='mto_h9_ho_b', dtmin='dtmin_2ph'}), -- demethaniser feed: condensing -9->-20
     qt_h119 = qt({tin = 'mto_h10_ti', hin = 0, tout='mto_h10_to', hout='mto_h10_ho', dtmin='dtmin_2ph'}),--checked
     qt_h120 = qt({tin = 'mto_h11_ti', hin = 0, tout='mto_h11_to', hout='mto_h11_ho', dtmin='dtmin_2ph'}),--checked
     qt_h121a = qt({tin = 'mto_h12_ti_a', hin = 0, tout='mto_h12_to_a', hout='mto_h12_ho_a', dtmin='dtmin_gas'}),--checked
     qt_h122 = qt({tin = 'mto_h13_ti', hin = 0, tout='mto_h13_to', hout='mto_h13_ho', dtmin='dtmin_gas'}),--checked
     qt_h123 = qt({tin = 'mto_h14_ti', hin = 0, tout='mto_h14_to', hout='mto_h14_ho', dtmin='dtmin_gas'}),--checked
     qt_h124 = qt({tin = 'mto_h15_ti', hin = 0, tout='mto_h15_to', hout='mto_h15_ho', dtmin='dtmin_2ph'}),--checked
     qt_h129 = qt({tin = 'mto_h20_ti', hin = 0, tout='mto_h20_to', hout='mto_h20_ho', dtmin='dtmin_liq'}), -- propylene product rundown, subcooled liquid
     qt_h130 = qt({tin = 'mto_h21_ti', hin = 0, tout='mto_h21_to', hout='mto_h21_ho', dtmin='dtmin_liq'}), -- butene product rundown, subcooled liquid
     qt_h126 = qt({tin = 'mto_h17_ti', hin = 0, tout='mto_h17_to', hout='mto_h17_ho', dtmin='dtmin_gas'}), -- combustor flue gas, vapour only
     qt_h127 = qt({tin = 'mto_h18_ti', hin = 0, tout='mto_h18_to', hout='mto_h18_ho', dtmin='dtmin_gas'}), -- regenerator flue gas, CO2 only, no condensation
     qt_h128 = qt({tin = 'mto_h19_ti', hin = 0, tout='mto_h19_to', hout='mto_h19_ho', dtmin='dtmin_gas'}), -- combustor flue gas above its dew point
     qt_h132a = qt({tin = 'mto_h23_ti_a', hin = 0, tout='mto_h23_to_a', hout='mto_h23_ho_a', dtmin='dtmin_2ph'}), -- flue gas condensation 88.1->74.4
     qt_h132b = qt({tin = 'mto_h23_ti_b', hin = 0, tout='mto_h23_to_b', hout='mto_h23_ho_b', dtmin='dtmin_2ph'}), -- flue gas condensation 74.4->48.1
     qt_h132c = qt({tin = 'mto_h23_ti_c', hin = 0, tout='mto_h23_to_c', hout='mto_h23_ho_c', dtmin='dtmin_2ph'}), -- flue gas condensation 48.1->25

}

return ET

