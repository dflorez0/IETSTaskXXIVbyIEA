--[[ OSMOSE energy-technology (ET) model: Dairy plant V2: cheese and whey soft drink
  Basis: all flows and heat loads per 1 t/h of fresh milk (input) (kg/h = kg/t; kW = kWh/t).
  Reference plant: 28.8 t/h of fresh milk. Set CAPACITY (t/h) to scale the process units; operating time 8,760 h/y (set op_time in the frontend).
  Source: DWSIM dairy model of Bhatnagar, Flórez-Orrego, Boztas and Dardor; Dardor et al. 2024; IPESE case-study workbook DairyRivella_V2_rs_qt.xlsx.
  Heat streams: cold streams hin = 0, hout = Q; hot streams hin = Q, hout = 0; dTmin is the dTmin/2 contribution of each stream (K).
  Utilities (steam, hot water, refrigeration, cooling water, burners) are not part of this model; refrigeration demands are hot streams at process temperature.
  Reference MER targets at CAPACITY = 1 (problem table of the case study): Qh = 235.95 kW, Qc = 213.13 kW, shifted pinch = 67.3 C.
  Generated from the case-study workbook on 2026-10-20; 30 heat streams, 16 material streams.
]]
local osmose = require 'osmose'
local et = osmose.Model 'Dairy_V2'

et.header = {
  name = 'Dairy_V2',
  displayName = 'Dairy plant V2: cheese and whey soft drink',
  authors = {'Sophia Wallerand, EPFL IPESE research group', 'Daniel Flórez-Orrego, EPFL IPESE research group',
             'Pullah Bhatnagar, EPFL IPESE research group', 'Oktay Boztas, EPFL IPESE research group',
             'Dareen Dardor, EPFL IPESE research group'},
  developers = {''},
  contributors = {''},
  creation_date = '2026-10-20',
  updates = {''},
  versions = {'1.0'},
  confidentiality = {'Open'},
  title = 'Dairy plant V2: cheese and whey soft drink',
  description = 'Process data (material flows and heat streams) per 1 t/h of fresh milk (input). Source: DWSIM dairy model of Bhatnagar, Flórez-Orrego, Boztas and Dardor; Dardor et al. 2024; IPESE case-study workbook DairyRivella_V2_rs_qt.xlsx',
}

-- ========== LAYERS ==========
et:addLayers { FRESH_MILK = {type = 'ResourceBalance', unit = 'kg/h'} } -- Fresh milk
et:addLayers { SALT = {type = 'ResourceBalance', unit = 'kg/h'} } -- Salt
et:addLayers { WATER_FOR_BRINING = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water for brining
et:addLayers { WATER_FOR_CLEANING_CIP = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water for cleaning (CIP)
et:addLayers { SUGAR = {type = 'ResourceBalance', unit = 'kg/h'} } -- Sugar
et:addLayers { AROMA = {type = 'ResourceBalance', unit = 'kg/h'} } -- Aroma
et:addLayers { CO2 = {type = 'ResourceBalance', unit = 'kg/h'} } -- CO2
et:addLayers { WATER_FOR_THE_DRINK = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water for the drink
et:addLayers { CREAM = {type = 'ResourceBalance', unit = 'kg/h'} } -- Cream
et:addLayers { CHEESE = {type = 'ResourceBalance', unit = 'kg/h'} } -- Cheese
et:addLayers { WHEY_SOFT_DRINK = {type = 'ResourceBalance', unit = 'kg/h'} } -- Whey soft drink
et:addLayers { WATER_VAPOUR_FROM_WHEY_EVAPORATION = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water vapour from whey evaporation
et:addLayers { EVAPORATOR_CONDENSATE_WATER = {type = 'ResourceBalance', unit = 'kg/h'} } -- Evaporator condensate water
et:addLayers { TREATED_WATER_DISCHARGE = {type = 'ResourceBalance', unit = 'kg/h'} } -- Treated water discharge
et:addLayers { CIP_WATER_DISCHARGE = {type = 'ResourceBalance', unit = 'kg/h'} } -- CIP water discharge
et:addLayers { SLUDGE_FROM_WASTEWATER_TREATMENT = {type = 'ResourceBalance', unit = 'kg/h'} } -- Sludge from wastewater treatment
et:addLayers { Elec = {type = 'ResourceBalance', unit = 'kW'} }

-- ========== PROCESS UNITS (heat streams by section) ==========
et:addUnit('Pasteurisation', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Pasteurisation']:addStreams({
  C1_Fresh_milk_heating_to_pasteurisa = qt{tin = 'C1_Fresh_milk_heating_to_pasteurisa_Tin', hin = 'C1_Fresh_milk_heating_to_pasteurisa_hin', tout = 'C1_Fresh_milk_heating_to_pasteurisa_Tout', hout = 'C1_Fresh_milk_heating_to_pasteurisa_hout', dtmin = 'C1_Fresh_milk_heating_to_pasteurisa_dTmin', alpha = 'C1_Fresh_milk_heating_to_pasteurisa_alpha'}, -- cold: Fresh milk heating to pasteurisation
  H1_Raw_milk_cooling_on_reception = qt{tin = 'H1_Raw_milk_cooling_on_reception_Tin', hin = 'H1_Raw_milk_cooling_on_reception_hin', tout = 'H1_Raw_milk_cooling_on_reception_Tout', hout = 'H1_Raw_milk_cooling_on_reception_hout', dtmin = 'H1_Raw_milk_cooling_on_reception_dTmin', alpha = 'H1_Raw_milk_cooling_on_reception_alpha'}, -- hot: Raw milk cooling on reception
  H2_Pasteurised_milk_cooling = qt{tin = 'H2_Pasteurised_milk_cooling_Tin', hin = 'H2_Pasteurised_milk_cooling_hin', tout = 'H2_Pasteurised_milk_cooling_Tout', hout = 'H2_Pasteurised_milk_cooling_hout', dtmin = 'H2_Pasteurised_milk_cooling_dTmin', alpha = 'H2_Pasteurised_milk_cooling_alpha'}, -- hot: Pasteurised milk cooling
})

et:addUnit('Evaporation', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Evaporation']:addStreams({
  C2_Skimmed_milk_preheating = qt{tin = 'C2_Skimmed_milk_preheating_Tin', hin = 'C2_Skimmed_milk_preheating_hin', tout = 'C2_Skimmed_milk_preheating_Tout', hout = 'C2_Skimmed_milk_preheating_hout', dtmin = 'C2_Skimmed_milk_preheating_dTmin', alpha = 'C2_Skimmed_milk_preheating_alpha'}, -- cold: Skimmed milk preheating
  C3_Effect_1_boiling_steam_heated = qt{tin = 'C3_Effect_1_boiling_steam_heated_Tin', hin = 'C3_Effect_1_boiling_steam_heated_hin', tout = 'C3_Effect_1_boiling_steam_heated_Tout', hout = 'C3_Effect_1_boiling_steam_heated_hout', dtmin = 'C3_Effect_1_boiling_steam_heated_dTmin', alpha = 'C3_Effect_1_boiling_steam_heated_alpha'}, -- cold: Effect 1, boiling (steam-heated)
  C4_Effect_2_boiling = qt{tin = 'C4_Effect_2_boiling_Tin', hin = 'C4_Effect_2_boiling_hin', tout = 'C4_Effect_2_boiling_Tout', hout = 'C4_Effect_2_boiling_hout', dtmin = 'C4_Effect_2_boiling_dTmin', alpha = 'C4_Effect_2_boiling_alpha'}, -- cold: Effect 2, boiling
  C5_Effect_3_boiling = qt{tin = 'C5_Effect_3_boiling_Tin', hin = 'C5_Effect_3_boiling_hin', tout = 'C5_Effect_3_boiling_Tout', hout = 'C5_Effect_3_boiling_hout', dtmin = 'C5_Effect_3_boiling_dTmin', alpha = 'C5_Effect_3_boiling_alpha'}, -- cold: Effect 3, boiling
  H3_Effect_1_vapour_condensing = qt{tin = 'H3_Effect_1_vapour_condensing_Tin', hin = 'H3_Effect_1_vapour_condensing_hin', tout = 'H3_Effect_1_vapour_condensing_Tout', hout = 'H3_Effect_1_vapour_condensing_hout', dtmin = 'H3_Effect_1_vapour_condensing_dTmin', alpha = 'H3_Effect_1_vapour_condensing_alpha'}, -- hot: Effect 1 vapour, condensing
  H4_Effect_2_vapour_condensing = qt{tin = 'H4_Effect_2_vapour_condensing_Tin', hin = 'H4_Effect_2_vapour_condensing_hin', tout = 'H4_Effect_2_vapour_condensing_Tout', hout = 'H4_Effect_2_vapour_condensing_hout', dtmin = 'H4_Effect_2_vapour_condensing_dTmin', alpha = 'H4_Effect_2_vapour_condensing_alpha'}, -- hot: Effect 2 vapour, condensing
  H5_Effect_3_vapour_condensing = qt{tin = 'H5_Effect_3_vapour_condensing_Tin', hin = 'H5_Effect_3_vapour_condensing_hin', tout = 'H5_Effect_3_vapour_condensing_Tout', hout = 'H5_Effect_3_vapour_condensing_hout', dtmin = 'H5_Effect_3_vapour_condensing_dTmin', alpha = 'H5_Effect_3_vapour_condensing_alpha'}, -- hot: Effect 3 vapour, condensing
  H6_Condensate_cooling = qt{tin = 'H6_Condensate_cooling_Tin', hin = 'H6_Condensate_cooling_hin', tout = 'H6_Condensate_cooling_Tout', hout = 'H6_Condensate_cooling_hout', dtmin = 'H6_Condensate_cooling_dTmin', alpha = 'H6_Condensate_cooling_alpha'}, -- hot: Condensate cooling
  H7_Concentrated_milk_cooling = qt{tin = 'H7_Concentrated_milk_cooling_Tin', hin = 'H7_Concentrated_milk_cooling_hin', tout = 'H7_Concentrated_milk_cooling_Tout', hout = 'H7_Concentrated_milk_cooling_hout', dtmin = 'H7_Concentrated_milk_cooling_dTmin', alpha = 'H7_Concentrated_milk_cooling_alpha'}, -- hot: Concentrated milk cooling
})

et:addUnit('Cheese', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Cheese']:addStreams({
  C6_Concentrated_milk_heating_for_cu = qt{tin = 'C6_Concentrated_milk_heating_for_cu_Tin', hin = 'C6_Concentrated_milk_heating_for_cu_hin', tout = 'C6_Concentrated_milk_heating_for_cu_Tout', hout = 'C6_Concentrated_milk_heating_for_cu_hout', dtmin = 'C6_Concentrated_milk_heating_for_cu_dTmin', alpha = 'C6_Concentrated_milk_heating_for_cu_alpha'}, -- cold: Concentrated milk heating for curdling
  C7_Brining_water_warming = qt{tin = 'C7_Brining_water_warming_Tin', hin = 'C7_Brining_water_warming_hin', tout = 'C7_Brining_water_warming_Tout', hout = 'C7_Brining_water_warming_hout', dtmin = 'C7_Brining_water_warming_dTmin', alpha = 'C7_Brining_water_warming_alpha'}, -- cold: Brining water warming
  H8_Curd_and_whey_cooling = qt{tin = 'H8_Curd_and_whey_cooling_Tin', hin = 'H8_Curd_and_whey_cooling_hin', tout = 'H8_Curd_and_whey_cooling_Tout', hout = 'H8_Curd_and_whey_cooling_hout', dtmin = 'H8_Curd_and_whey_cooling_dTmin', alpha = 'H8_Curd_and_whey_cooling_alpha'}, -- hot: Curd and whey cooling
  H9_Brining_cooling_side_lumped = qt{tin = 'H9_Brining_cooling_side_lumped_Tin', hin = 'H9_Brining_cooling_side_lumped_hin', tout = 'H9_Brining_cooling_side_lumped_Tout', hout = 'H9_Brining_cooling_side_lumped_hout', dtmin = 'H9_Brining_cooling_side_lumped_dTmin', alpha = 'H9_Brining_cooling_side_lumped_alpha'}, -- hot: Brining, cooling side (lumped)
})

et:addUnit('CIP', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['CIP']:addStreams({
  C8_Make_up_water_heating = qt{tin = 'C8_Make_up_water_heating_Tin', hin = 'C8_Make_up_water_heating_hin', tout = 'C8_Make_up_water_heating_Tout', hout = 'C8_Make_up_water_heating_hout', dtmin = 'C8_Make_up_water_heating_dTmin', alpha = 'C8_Make_up_water_heating_alpha'}, -- cold: Make-up water heating
  C9_Cleaning_water_heating = qt{tin = 'C9_Cleaning_water_heating_Tin', hin = 'C9_Cleaning_water_heating_hin', tout = 'C9_Cleaning_water_heating_Tout', hout = 'C9_Cleaning_water_heating_hout', dtmin = 'C9_Cleaning_water_heating_dTmin', alpha = 'C9_Cleaning_water_heating_alpha'}, -- cold: Cleaning water heating
  H10_Cleaning_circuits_cooling = qt{tin = 'H10_Cleaning_circuits_cooling_Tin', hin = 'H10_Cleaning_circuits_cooling_hin', tout = 'H10_Cleaning_circuits_cooling_Tout', hout = 'H10_Cleaning_circuits_cooling_hout', dtmin = 'H10_Cleaning_circuits_cooling_dTmin', alpha = 'H10_Cleaning_circuits_cooling_alpha'}, -- hot: Cleaning circuits, cooling
  H11_Returned_water_cooling_before_re = qt{tin = 'H11_Returned_water_cooling_before_re_Tin', hin = 'H11_Returned_water_cooling_before_re_hin', tout = 'H11_Returned_water_cooling_before_re_Tout', hout = 'H11_Returned_water_cooling_before_re_hout', dtmin = 'H11_Returned_water_cooling_before_re_dTmin', alpha = 'H11_Returned_water_cooling_before_re_alpha'}, -- hot: Returned water cooling before reuse
  H12_Spent_water_cooling_before_disch = qt{tin = 'H12_Spent_water_cooling_before_disch_Tin', hin = 'H12_Spent_water_cooling_before_disch_hin', tout = 'H12_Spent_water_cooling_before_disch_Tout', hout = 'H12_Spent_water_cooling_before_disch_hout', dtmin = 'H12_Spent_water_cooling_before_disch_dTmin', alpha = 'H12_Spent_water_cooling_before_disch_alpha'}, -- hot: Spent water cooling before discharge
})

et:addUnit('Soft_drink', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Soft_drink']:addStreams({
  C10_Whey_heating_to_boiling = qt{tin = 'C10_Whey_heating_to_boiling_Tin', hin = 'C10_Whey_heating_to_boiling_hin', tout = 'C10_Whey_heating_to_boiling_Tout', hout = 'C10_Whey_heating_to_boiling_hout', dtmin = 'C10_Whey_heating_to_boiling_dTmin', alpha = 'C10_Whey_heating_to_boiling_alpha'}, -- cold: Whey heating to boiling
  C11_Whey_boiling_water_evaporation = qt{tin = 'C11_Whey_boiling_water_evaporation_Tin', hin = 'C11_Whey_boiling_water_evaporation_hin', tout = 'C11_Whey_boiling_water_evaporation_Tout', hout = 'C11_Whey_boiling_water_evaporation_hout', dtmin = 'C11_Whey_boiling_water_evaporation_dTmin', alpha = 'C11_Whey_boiling_water_evaporation_alpha'}, -- cold: Whey boiling, water evaporation
  C12_Blending_heating_side_lumped = qt{tin = 'C12_Blending_heating_side_lumped_Tin', hin = 'C12_Blending_heating_side_lumped_hin', tout = 'C12_Blending_heating_side_lumped_Tout', hout = 'C12_Blending_heating_side_lumped_hout', dtmin = 'C12_Blending_heating_side_lumped_dTmin', alpha = 'C12_Blending_heating_side_lumped_alpha'}, -- cold: Blending, heating side (lumped)
  H13_Vapour_condensation = qt{tin = 'H13_Vapour_condensation_Tin', hin = 'H13_Vapour_condensation_hin', tout = 'H13_Vapour_condensation_Tout', hout = 'H13_Vapour_condensation_hout', dtmin = 'H13_Vapour_condensation_dTmin', alpha = 'H13_Vapour_condensation_alpha'}, -- hot: Vapour, condensation
  H14_Condensate_cooling = qt{tin = 'H14_Condensate_cooling_Tin', hin = 'H14_Condensate_cooling_hin', tout = 'H14_Condensate_cooling_Tout', hout = 'H14_Condensate_cooling_hout', dtmin = 'H14_Condensate_cooling_dTmin', alpha = 'H14_Condensate_cooling_alpha'}, -- hot: Condensate cooling
  H15_Vapour_leaving_the_evaporator = qt{tin = 'H15_Vapour_leaving_the_evaporator_Tin', hin = 'H15_Vapour_leaving_the_evaporator_hin', tout = 'H15_Vapour_leaving_the_evaporator_Tout', hout = 'H15_Vapour_leaving_the_evaporator_hout', dtmin = 'H15_Vapour_leaving_the_evaporator_dTmin', alpha = 'H15_Vapour_leaving_the_evaporator_alpha'}, -- hot: Vapour leaving the evaporator
  H16_Whey_concentrate_and_syrup_cooli = qt{tin = 'H16_Whey_concentrate_and_syrup_cooli_Tin', hin = 'H16_Whey_concentrate_and_syrup_cooli_hin', tout = 'H16_Whey_concentrate_and_syrup_cooli_Tout', hout = 'H16_Whey_concentrate_and_syrup_cooli_hout', dtmin = 'H16_Whey_concentrate_and_syrup_cooli_dTmin', alpha = 'H16_Whey_concentrate_and_syrup_cooli_alpha'}, -- hot: Whey concentrate and syrup cooling
  H17_Aroma_condensation_and_cooling_l = qt{tin = 'H17_Aroma_condensation_and_cooling_l_Tin', hin = 'H17_Aroma_condensation_and_cooling_l_hin', tout = 'H17_Aroma_condensation_and_cooling_l_Tout', hout = 'H17_Aroma_condensation_and_cooling_l_hout', dtmin = 'H17_Aroma_condensation_and_cooling_l_dTmin', alpha = 'H17_Aroma_condensation_and_cooling_l_alpha'}, -- hot: Aroma condensation and cooling (lumped)
  H18_Blending_cooling_side_lumped = qt{tin = 'H18_Blending_cooling_side_lumped_Tin', hin = 'H18_Blending_cooling_side_lumped_hin', tout = 'H18_Blending_cooling_side_lumped_Tout', hout = 'H18_Blending_cooling_side_lumped_hout', dtmin = 'H18_Blending_cooling_side_lumped_dTmin', alpha = 'H18_Blending_cooling_side_lumped_alpha'}, -- hot: Blending, cooling side (lumped)
})

-- ========== MATERIAL BOUNDARY AND PROCESS ELECTRICITY ==========
et:addUnit('Plant_boundary', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Plant_boundary']:addStreams({
  FRESH_MILK_in = rs{'FRESH_MILK', 'in', 'FRESH_MILK_flow'}, -- Fresh milk
  SALT_in = rs{'SALT', 'in', 'SALT_flow'}, -- Salt
  WATER_FOR_BRINING_in = rs{'WATER_FOR_BRINING', 'in', 'WATER_FOR_BRINING_flow'}, -- Water for brining
  WATER_FOR_CLEANING_CIP_in = rs{'WATER_FOR_CLEANING_CIP', 'in', 'WATER_FOR_CLEANING_CIP_flow'}, -- Water for cleaning (CIP)
  SUGAR_in = rs{'SUGAR', 'in', 'SUGAR_flow'}, -- Sugar
  AROMA_in = rs{'AROMA', 'in', 'AROMA_flow'}, -- Aroma
  CO2_in = rs{'CO2', 'in', 'CO2_flow'}, -- CO2
  WATER_FOR_THE_DRINK_in = rs{'WATER_FOR_THE_DRINK', 'in', 'WATER_FOR_THE_DRINK_flow'}, -- Water for the drink
  CREAM_out = rs{'CREAM', 'out', 'CREAM_flow'}, -- Cream
  CHEESE_out = rs{'CHEESE', 'out', 'CHEESE_flow'}, -- Cheese
  WHEY_SOFT_DRINK_out = rs{'WHEY_SOFT_DRINK', 'out', 'WHEY_SOFT_DRINK_flow'}, -- Whey soft drink
  WATER_VAPOUR_FROM_WHEY_EVAPORATION_out = rs{'WATER_VAPOUR_FROM_WHEY_EVAPORATION', 'out', 'WATER_VAPOUR_FROM_WHEY_EVAPORATION_flow'}, -- Water vapour from whey evaporation
  EVAPORATOR_CONDENSATE_WATER_out = rs{'EVAPORATOR_CONDENSATE_WATER', 'out', 'EVAPORATOR_CONDENSATE_WATER_flow'}, -- Evaporator condensate water
  TREATED_WATER_DISCHARGE_out = rs{'TREATED_WATER_DISCHARGE', 'out', 'TREATED_WATER_DISCHARGE_flow'}, -- Treated water discharge
  CIP_WATER_DISCHARGE_out = rs{'CIP_WATER_DISCHARGE', 'out', 'CIP_WATER_DISCHARGE_flow'}, -- CIP water discharge
  SLUDGE_FROM_WASTEWATER_TREATMENT_out = rs{'SLUDGE_FROM_WASTEWATER_TREATMENT', 'out', 'SLUDGE_FROM_WASTEWATER_TREATMENT_flow'}, -- Sludge from wastewater treatment
  ELECTRICITY_process = rs{'Elec', 'in', 'ELEC_process'}, -- process electricity, refrigeration excluded
})

-- ========== INPUTS (values per 1 t/h of fresh milk (input)) ==========
et.inputs = {
  CAPACITY = {default = 1, unit = 't/h'}, -- reference plant: 28.8 t/h
  -- Pasteurisation
  C1_Fresh_milk_heating_to_pasteurisa_Tin = {default = 4, unit = 'C'},
  C1_Fresh_milk_heating_to_pasteurisa_Tout = {default = 75, unit = 'C'},
  C1_Fresh_milk_heating_to_pasteurisa_hin = {default = 0, unit = 'kW'},
  C1_Fresh_milk_heating_to_pasteurisa_hout = {default = 76.3785, unit = 'kW'},
  C1_Fresh_milk_heating_to_pasteurisa_dTmin = {default = 5, unit = 'K'},
  C1_Fresh_milk_heating_to_pasteurisa_alpha = {default = 1, unit = 'kW/m2K'},
  H1_Raw_milk_cooling_on_reception_Tin = {default = 6, unit = 'C'},
  H1_Raw_milk_cooling_on_reception_Tout = {default = 4, unit = 'C'},
  H1_Raw_milk_cooling_on_reception_hin = {default = 2.18403, unit = 'kW'},
  H1_Raw_milk_cooling_on_reception_hout = {default = 0, unit = 'kW'},
  H1_Raw_milk_cooling_on_reception_dTmin = {default = 5, unit = 'K'},
  H1_Raw_milk_cooling_on_reception_alpha = {default = 1, unit = 'kW/m2K'},
  H2_Pasteurised_milk_cooling_Tin = {default = 75, unit = 'C'},
  H2_Pasteurised_milk_cooling_Tout = {default = 4, unit = 'C'},
  H2_Pasteurised_milk_cooling_hin = {default = 73.1285, unit = 'kW'},
  H2_Pasteurised_milk_cooling_hout = {default = 0, unit = 'kW'},
  H2_Pasteurised_milk_cooling_dTmin = {default = 5, unit = 'K'},
  H2_Pasteurised_milk_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  -- Evaporation
  C2_Skimmed_milk_preheating_Tin = {default = 4, unit = 'C'},
  C2_Skimmed_milk_preheating_Tout = {default = 70.2, unit = 'C'},
  C2_Skimmed_milk_preheating_hin = {default = 0, unit = 'kW'},
  C2_Skimmed_milk_preheating_hout = {default = 45.1944, unit = 'kW'},
  C2_Skimmed_milk_preheating_dTmin = {default = 5, unit = 'K'},
  C2_Skimmed_milk_preheating_alpha = {default = 1, unit = 'kW/m2K'},
  C3_Effect_1_boiling_steam_heated_Tin = {default = 70.2, unit = 'C'},
  C3_Effect_1_boiling_steam_heated_Tout = {default = 70.3, unit = 'C'},
  C3_Effect_1_boiling_steam_heated_hin = {default = 0, unit = 'kW'},
  C3_Effect_1_boiling_steam_heated_hout = {default = 122.014, unit = 'kW'},
  C3_Effect_1_boiling_steam_heated_dTmin = {default = 2, unit = 'K'},
  C3_Effect_1_boiling_steam_heated_alpha = {default = 1, unit = 'kW/m2K'},
  C4_Effect_2_boiling_Tin = {default = 65.3, unit = 'C'},
  C4_Effect_2_boiling_Tout = {default = 65.6, unit = 'C'},
  C4_Effect_2_boiling_hin = {default = 0, unit = 'kW'},
  C4_Effect_2_boiling_hout = {default = 102.319, unit = 'kW'},
  C4_Effect_2_boiling_dTmin = {default = 2, unit = 'K'},
  C4_Effect_2_boiling_alpha = {default = 1, unit = 'kW/m2K'},
  C5_Effect_3_boiling_Tin = {default = 60.7, unit = 'C'},
  C5_Effect_3_boiling_Tout = {default = 61.3, unit = 'C'},
  C5_Effect_3_boiling_hin = {default = 0, unit = 'kW'},
  C5_Effect_3_boiling_hout = {default = 64.2743, unit = 'kW'},
  C5_Effect_3_boiling_dTmin = {default = 2, unit = 'K'},
  C5_Effect_3_boiling_alpha = {default = 1, unit = 'kW/m2K'},
  H3_Effect_1_vapour_condensing_Tin = {default = 70.2, unit = 'C'},
  H3_Effect_1_vapour_condensing_Tout = {default = 69.1, unit = 'C'},
  H3_Effect_1_vapour_condensing_hin = {default = 122.146, unit = 'kW'},
  H3_Effect_1_vapour_condensing_hout = {default = 0, unit = 'kW'},
  H3_Effect_1_vapour_condensing_dTmin = {default = 2, unit = 'K'},
  H3_Effect_1_vapour_condensing_alpha = {default = 1, unit = 'kW/m2K'},
  H4_Effect_2_vapour_condensing_Tin = {default = 65.6, unit = 'C'},
  H4_Effect_2_vapour_condensing_Tout = {default = 65, unit = 'C'},
  H4_Effect_2_vapour_condensing_hin = {default = 104.58, unit = 'kW'},
  H4_Effect_2_vapour_condensing_hout = {default = 0, unit = 'kW'},
  H4_Effect_2_vapour_condensing_dTmin = {default = 2, unit = 'K'},
  H4_Effect_2_vapour_condensing_alpha = {default = 1, unit = 'kW/m2K'},
  H5_Effect_3_vapour_condensing_Tin = {default = 61.3, unit = 'C'},
  H5_Effect_3_vapour_condensing_Tout = {default = 60.1, unit = 'C'},
  H5_Effect_3_vapour_condensing_hin = {default = 65.6076, unit = 'kW'},
  H5_Effect_3_vapour_condensing_hout = {default = 0, unit = 'kW'},
  H5_Effect_3_vapour_condensing_dTmin = {default = 2, unit = 'K'},
  H5_Effect_3_vapour_condensing_alpha = {default = 1, unit = 'kW/m2K'},
  H6_Condensate_cooling_Tin = {default = 69.9, unit = 'C'},
  H6_Condensate_cooling_Tout = {default = 25, unit = 'C'},
  H6_Condensate_cooling_hin = {default = 21.1875, unit = 'kW'},
  H6_Condensate_cooling_hout = {default = 0, unit = 'kW'},
  H6_Condensate_cooling_dTmin = {default = 5, unit = 'K'},
  H6_Condensate_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  H7_Concentrated_milk_cooling_Tin = {default = 61.3, unit = 'C'},
  H7_Concentrated_milk_cooling_Tout = {default = 4, unit = 'C'},
  H7_Concentrated_milk_cooling_hin = {default = 9.31597, unit = 'kW'},
  H7_Concentrated_milk_cooling_hout = {default = 0, unit = 'kW'},
  H7_Concentrated_milk_cooling_dTmin = {default = 5, unit = 'K'},
  H7_Concentrated_milk_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  -- Cheese
  C6_Concentrated_milk_heating_for_cu_Tin = {default = 4, unit = 'C'},
  C6_Concentrated_milk_heating_for_cu_Tout = {default = 56, unit = 'C'},
  C6_Concentrated_milk_heating_for_cu_hin = {default = 0, unit = 'kW'},
  C6_Concentrated_milk_heating_for_cu_hout = {default = 8.27083, unit = 'kW'},
  C6_Concentrated_milk_heating_for_cu_dTmin = {default = 5, unit = 'K'},
  C6_Concentrated_milk_heating_for_cu_alpha = {default = 1, unit = 'kW/m2K'},
  C7_Brining_water_warming_Tin = {default = 12, unit = 'C'},
  C7_Brining_water_warming_Tout = {default = 15.2, unit = 'C'},
  C7_Brining_water_warming_hin = {default = 0, unit = 'kW'},
  C7_Brining_water_warming_hout = {default = 0.114583, unit = 'kW'},
  C7_Brining_water_warming_dTmin = {default = 5, unit = 'K'},
  C7_Brining_water_warming_alpha = {default = 1, unit = 'kW/m2K'},
  H8_Curd_and_whey_cooling_Tin = {default = 56, unit = 'C'},
  H8_Curd_and_whey_cooling_Tout = {default = 16, unit = 'C'},
  H8_Curd_and_whey_cooling_hin = {default = 2.1875, unit = 'kW'},
  H8_Curd_and_whey_cooling_hout = {default = 0, unit = 'kW'},
  H8_Curd_and_whey_cooling_dTmin = {default = 5, unit = 'K'},
  H8_Curd_and_whey_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  H9_Brining_cooling_side_lumped_Tin = {default = 25, unit = 'C'},
  H9_Brining_cooling_side_lumped_Tout = {default = 13, unit = 'C'},
  H9_Brining_cooling_side_lumped_hin = {default = 0.326389, unit = 'kW'},
  H9_Brining_cooling_side_lumped_hout = {default = 0, unit = 'kW'},
  H9_Brining_cooling_side_lumped_dTmin = {default = 5, unit = 'K'},
  H9_Brining_cooling_side_lumped_alpha = {default = 1, unit = 'kW/m2K'},
  -- CIP
  C8_Make_up_water_heating_Tin = {default = 25, unit = 'C'},
  C8_Make_up_water_heating_Tout = {default = 60, unit = 'C'},
  C8_Make_up_water_heating_hin = {default = 0, unit = 'kW'},
  C8_Make_up_water_heating_hout = {default = 6.10069, unit = 'kW'},
  C8_Make_up_water_heating_dTmin = {default = 5, unit = 'K'},
  C8_Make_up_water_heating_alpha = {default = 1, unit = 'kW/m2K'},
  C9_Cleaning_water_heating_Tin = {default = 60, unit = 'C'},
  C9_Cleaning_water_heating_Tout = {default = 80, unit = 'C'},
  C9_Cleaning_water_heating_hin = {default = 0, unit = 'kW'},
  C9_Cleaning_water_heating_hout = {default = 11.6285, unit = 'kW'},
  C9_Cleaning_water_heating_dTmin = {default = 5, unit = 'K'},
  C9_Cleaning_water_heating_alpha = {default = 1, unit = 'kW/m2K'},
  H10_Cleaning_circuits_cooling_Tin = {default = 80, unit = 'C'},
  H10_Cleaning_circuits_cooling_Tout = {default = 75, unit = 'C'},
  H10_Cleaning_circuits_cooling_hin = {default = 2.90972, unit = 'kW'},
  H10_Cleaning_circuits_cooling_hout = {default = 0, unit = 'kW'},
  H10_Cleaning_circuits_cooling_dTmin = {default = 5, unit = 'K'},
  H10_Cleaning_circuits_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  H11_Returned_water_cooling_before_re_Tin = {default = 75, unit = 'C'},
  H11_Returned_water_cooling_before_re_Tout = {default = 60, unit = 'C'},
  H11_Returned_water_cooling_before_re_hin = {default = 6.10764, unit = 'kW'},
  H11_Returned_water_cooling_before_re_hout = {default = 0, unit = 'kW'},
  H11_Returned_water_cooling_before_re_dTmin = {default = 5, unit = 'K'},
  H11_Returned_water_cooling_before_re_alpha = {default = 1, unit = 'kW/m2K'},
  H12_Spent_water_cooling_before_disch_Tin = {default = 75, unit = 'C'},
  H12_Spent_water_cooling_before_disch_Tout = {default = 30, unit = 'C'},
  H12_Spent_water_cooling_before_disch_hin = {default = 7.84375, unit = 'kW'},
  H12_Spent_water_cooling_before_disch_hout = {default = 0, unit = 'kW'},
  H12_Spent_water_cooling_before_disch_dTmin = {default = 5, unit = 'K'},
  H12_Spent_water_cooling_before_disch_alpha = {default = 1, unit = 'kW/m2K'},
  -- Soft_drink
  C10_Whey_heating_to_boiling_Tin = {default = 27.2, unit = 'C'},
  C10_Whey_heating_to_boiling_Tout = {default = 97.3, unit = 'C'},
  C10_Whey_heating_to_boiling_hin = {default = 0, unit = 'kW'},
  C10_Whey_heating_to_boiling_hout = {default = 27.4554, unit = 'kW'},
  C10_Whey_heating_to_boiling_dTmin = {default = 5, unit = 'K'},
  C10_Whey_heating_to_boiling_alpha = {default = 1, unit = 'kW/m2K'},
  C11_Whey_boiling_water_evaporation_Tin = {default = 97.3, unit = 'C'},
  C11_Whey_boiling_water_evaporation_Tout = {default = 100, unit = 'C'},
  C11_Whey_boiling_water_evaporation_hin = {default = 0, unit = 'kW'},
  C11_Whey_boiling_water_evaporation_hout = {default = 165.263, unit = 'kW'},
  C11_Whey_boiling_water_evaporation_dTmin = {default = 8, unit = 'K'},
  C11_Whey_boiling_water_evaporation_alpha = {default = 1, unit = 'kW/m2K'},
  C12_Blending_heating_side_lumped_Tin = {default = 25, unit = 'C'},
  C12_Blending_heating_side_lumped_Tout = {default = 45.2, unit = 'C'},
  C12_Blending_heating_side_lumped_hin = {default = 0, unit = 'kW'},
  C12_Blending_heating_side_lumped_hout = {default = 1.72484, unit = 'kW'},
  C12_Blending_heating_side_lumped_dTmin = {default = 5, unit = 'K'},
  C12_Blending_heating_side_lumped_alpha = {default = 1, unit = 'kW/m2K'},
  H13_Vapour_condensation_Tin = {default = 100, unit = 'C'},
  H13_Vapour_condensation_Tout = {default = 99.9, unit = 'C'},
  H13_Vapour_condensation_hin = {default = 41.1884, unit = 'kW'},
  H13_Vapour_condensation_hout = {default = 0, unit = 'kW'},
  H13_Vapour_condensation_dTmin = {default = 2, unit = 'K'},
  H13_Vapour_condensation_alpha = {default = 1, unit = 'kW/m2K'},
  H14_Condensate_cooling_Tin = {default = 100, unit = 'C'},
  H14_Condensate_cooling_Tout = {default = 50, unit = 'C'},
  H14_Condensate_cooling_hin = {default = 6.29671, unit = 'kW'},
  H14_Condensate_cooling_hout = {default = 0, unit = 'kW'},
  H14_Condensate_cooling_dTmin = {default = 5, unit = 'K'},
  H14_Condensate_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  H15_Vapour_leaving_the_evaporator_Tin = {default = 100, unit = 'C'},
  H15_Vapour_leaving_the_evaporator_Tout = {default = 25, unit = 'C'},
  H15_Vapour_leaving_the_evaporator_hin = {default = 135.84, unit = 'kW'},
  H15_Vapour_leaving_the_evaporator_hout = {default = 0, unit = 'kW'},
  H15_Vapour_leaving_the_evaporator_dTmin = {default = 8, unit = 'K'},
  H15_Vapour_leaving_the_evaporator_alpha = {default = 1, unit = 'kW/m2K'},
  H16_Whey_concentrate_and_syrup_cooli_Tin = {default = 45.2, unit = 'C'},
  H16_Whey_concentrate_and_syrup_cooli_Tout = {default = 10, unit = 'C'},
  H16_Whey_concentrate_and_syrup_cooli_hin = {default = 5.55898, unit = 'kW'},
  H16_Whey_concentrate_and_syrup_cooli_hout = {default = 0, unit = 'kW'},
  H16_Whey_concentrate_and_syrup_cooli_dTmin = {default = 5, unit = 'K'},
  H16_Whey_concentrate_and_syrup_cooli_alpha = {default = 1, unit = 'kW/m2K'},
  H17_Aroma_condensation_and_cooling_l_Tin = {default = 81.7, unit = 'C'},
  H17_Aroma_condensation_and_cooling_l_Tout = {default = 27.2, unit = 'C'},
  H17_Aroma_condensation_and_cooling_l_hin = {default = 0.516066, unit = 'kW'},
  H17_Aroma_condensation_and_cooling_l_hout = {default = 0, unit = 'kW'},
  H17_Aroma_condensation_and_cooling_l_dTmin = {default = 5, unit = 'K'},
  H17_Aroma_condensation_and_cooling_l_alpha = {default = 1, unit = 'kW/m2K'},
  H18_Blending_cooling_side_lumped_Tin = {default = 50, unit = 'C'},
  H18_Blending_cooling_side_lumped_Tout = {default = 9.7, unit = 'C'},
  H18_Blending_cooling_side_lumped_hin = {default = 0.997497, unit = 'kW'},
  H18_Blending_cooling_side_lumped_hout = {default = 0, unit = 'kW'},
  H18_Blending_cooling_side_lumped_dTmin = {default = 5, unit = 'K'},
  H18_Blending_cooling_side_lumped_alpha = {default = 1, unit = 'kW/m2K'},
  -- material flows (kg/h per t/h) and electricity (kW per t/h)
  FRESH_MILK_flow = {default = 1000, unit = 'kg/h'}, -- in: Fresh milk
  SALT_flow = {default = 6.08681, unit = 'kg/h'}, -- in: Salt
  WATER_FOR_BRINING_flow = {default = 31.25, unit = 'kg/h'}, -- in: Water for brining
  WATER_FOR_CLEANING_CIP_flow = {default = 150, unit = 'kg/h'}, -- in: Water for cleaning (CIP)
  SUGAR_flow = {default = 18.9114, unit = 'kg/h'}, -- in: Sugar
  AROMA_flow = {default = 5.97114, unit = 'kg/h'}, -- in: Aroma
  CO2_flow = {default = 6.92707, unit = 'kg/h'}, -- in: CO2
  WATER_FOR_THE_DRINK_flow = {default = 64.9824, unit = 'kg/h'}, -- in: Water for the drink
  CREAM_flow = {default = 59.5208, unit = 'kg/h'}, -- out: Cream
  CHEESE_flow = {default = 70.309, unit = 'kg/h'}, -- out: Cheese
  WHEY_SOFT_DRINK_flow = {default = 218.528, unit = 'kg/h'}, -- out: Whey soft drink
  WATER_VAPOUR_FROM_WHEY_EVAPORATION_flow = {default = 176.89, unit = 'kg/h'}, -- out: Water vapour from whey evaporation
  EVAPORATOR_CONDENSATE_WATER_flow = {default = 448.47, unit = 'kg/h'}, -- out: Evaporator condensate water
  TREATED_WATER_DISCHARGE_flow = {default = 155.654, unit = 'kg/h'}, -- out: Treated water discharge
  CIP_WATER_DISCHARGE_flow = {default = 150, unit = 'kg/h'}, -- out: CIP water discharge
  SLUDGE_FROM_WASTEWATER_TREATMENT_flow = {default = 4.75694, unit = 'kg/h'}, -- out: Sludge from wastewater treatment
  ELEC_process = {default = 7.05434, unit = 'kW'},
}

et.outputs = {}

return et
