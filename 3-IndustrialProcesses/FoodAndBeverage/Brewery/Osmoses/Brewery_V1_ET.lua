--[[ OSMOSE energy-technology (ET) model: Brewery V1: beer production with anaerobic digestion of the spent grains
  Basis: all flows and heat loads per 1 t/h of beer (kg/h = kg/t; kW = kWh/t).
  Reference plant: 68.686 t/h of beer (19.0793 kg/s). Set CAPACITY (t/h) to scale the process units; operating time 8,760 h/y (set op_time in the frontend).
  Source: Marechal, Sachan, Salgueiro (2013), Handbook of Process Integration, Woodhead, pp. 820-863, doi:10.1533/9780857097255.5.820; IPESE case-study workbook Brewery_V1_rs_qt.xlsx.
  Heat streams: cold streams hin = 0, hout = Q; hot streams hin = Q, hout = 0; dTmin is the dTmin/2 contribution of each stream (K).
  Utilities (steam, hot water, refrigeration, cooling water, burners) are not part of this model; refrigeration demands are hot streams at process temperature.
  Reference MER targets at CAPACITY = 1 (problem table of the case study): Qh = 72.91 kW, Qc = 59.79 kW, shifted pinch = 20 C.
  Generated from the case-study workbook on 2026-10-20; 29 heat streams, 17 material streams.
]]
local osmose = require 'osmose'
local et = osmose.Model 'Brewery_V1'

et.header = {
  name = 'Brewery_V1',
  displayName = 'Brewery V1: beer production with anaerobic digestion of the spent grains',
  authors = {'Pullah Bhatnagar, EPFL IPESE research group', 'Daniel Flórez-Orrego, EPFL IPESE research group',
             'Oktay Boztas, EPFL IPESE research group', 'Meire Ribeiro Domingos, EPFL IPESE research group',
             'François Maréchal, EPFL IPESE research group'},
  developers = {''},
  contributors = {''},
  creation_date = '2026-10-20',
  updates = {''},
  versions = {'1.0'},
  confidentiality = {'Open'},
  title = 'Brewery V1: beer production with anaerobic digestion of the spent grains',
  description = 'Process data (material flows and heat streams) per 1 t/h of beer. Source: Marechal, Sachan, Salgueiro (2013), Handbook of Process Integration, Woodhead, pp. 820-863, doi:10.1533/9780857097255.5.820; IPESE case-study workbook Brewery_V1_rs_qt.xlsx',
}

-- ========== LAYERS ==========
et:addLayers { MALT = {type = 'ResourceBalance', unit = 'kg/h'} } -- Malt
et:addLayers { CORN_ADJUNCT = {type = 'ResourceBalance', unit = 'kg/h'} } -- Corn (adjunct)
et:addLayers { WATER_FOR_MASHING_MAK_AND_MAT = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water for mashing (MAK and MAT)
et:addLayers { SPARGE_WATER = {type = 'ResourceBalance', unit = 'kg/h'} } -- Sparge water
et:addLayers { MAKE_UP_WATER_AT_THE_WHIRLPOOL = {type = 'ResourceBalance', unit = 'kg/h'} } -- Make-up water at the whirlpool
et:addLayers { DILUTION_WATER = {type = 'ResourceBalance', unit = 'kg/h'} } -- Dilution water
et:addLayers { WATER_FOR_CLEANING_IN_PLACE = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water for cleaning in place
et:addLayers { SODA_NAOH_FOR_BOTTLE_WASHING = {type = 'ResourceBalance', unit = 'kg/h'} } -- Soda (NaOH) for bottle washing
et:addLayers { WATER_FOR_BOTTLE_WASHING_SODA_BATH_PRE_R = {type = 'ResourceBalance', unit = 'kg/h'} } -- Water for bottle washing (soda bath, pre-rinse, final rinse)
et:addLayers { BEER = {type = 'ResourceBalance', unit = 'kg/h'} } -- Beer
et:addLayers { BIOGAS = {type = 'ResourceBalance', unit = 'kg/h'} } -- Biogas (55 vol % CH4)
et:addLayers { DIGESTATE = {type = 'ResourceBalance', unit = 'kg/h'} } -- Digestate
et:addLayers { VAPOUR_FROM_WORT_BOILING = {type = 'ResourceBalance', unit = 'kg/h'} } -- Vapour from wort boiling
et:addLayers { TRUB = {type = 'ResourceBalance', unit = 'kg/h'} } -- Trub
et:addLayers { CO2_FROM_FERMENTATION = {type = 'ResourceBalance', unit = 'kg/h'} } -- CO2 from fermentation
et:addLayers { HOT_WATER_TO_CLEANING_IN_PLACE = {type = 'ResourceBalance', unit = 'kg/h'} } -- Hot water to cleaning in place
et:addLayers { BOTTLE_WASHING_WASTEWATER = {type = 'ResourceBalance', unit = 'kg/h'} } -- Bottle-washing wastewater
et:addLayers { ELECTRICITY = {type = 'ResourceBalance', unit = 'kW'} }
et:addLayers { BIOMETHANE = {type = 'ResourceBalance', unit = 'kW'} } -- methane exported to the gas grid (LHV)

-- ========== PROCESS UNITS (heat streams by section) ==========
et:addUnit('Mashing', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Mashing']:addStreams({
  C1_Water_to_the_mash_cooker_MAK = qt{tin = 'C1_Water_to_the_mash_cooker_MAK_Tin', hin = 'C1_Water_to_the_mash_cooker_MAK_hin', tout = 'C1_Water_to_the_mash_cooker_MAK_Tout', hout = 'C1_Water_to_the_mash_cooker_MAK_hout', dtmin = 'C1_Water_to_the_mash_cooker_MAK_dTmin', alpha = 'C1_Water_to_the_mash_cooker_MAK_alpha'}, -- cold: Water to the mash cooker (MAK)
  C2_Water_to_the_mash_tun_MAT = qt{tin = 'C2_Water_to_the_mash_tun_MAT_Tin', hin = 'C2_Water_to_the_mash_tun_MAT_hin', tout = 'C2_Water_to_the_mash_tun_MAT_Tout', hout = 'C2_Water_to_the_mash_tun_MAT_hout', dtmin = 'C2_Water_to_the_mash_tun_MAT_dTmin', alpha = 'C2_Water_to_the_mash_tun_MAT_alpha'}, -- cold: Water to the mash tun (MAT)
  C3_Mash_heating_in_MAK_and_MAT_lump = qt{tin = 'C3_Mash_heating_in_MAK_and_MAT_lump_Tin', hin = 'C3_Mash_heating_in_MAK_and_MAT_lump_hin', tout = 'C3_Mash_heating_in_MAK_and_MAT_lump_Tout', hout = 'C3_Mash_heating_in_MAK_and_MAT_lump_hout', dtmin = 'C3_Mash_heating_in_MAK_and_MAT_lump_dTmin', alpha = 'C3_Mash_heating_in_MAK_and_MAT_lump_alpha'}, -- cold: Mash heating in MAK and MAT (lumped)
  C4_Combined_mash_heating = qt{tin = 'C4_Combined_mash_heating_Tin', hin = 'C4_Combined_mash_heating_hin', tout = 'C4_Combined_mash_heating_Tout', hout = 'C4_Combined_mash_heating_hout', dtmin = 'C4_Combined_mash_heating_dTmin', alpha = 'C4_Combined_mash_heating_alpha'}, -- cold: Combined mash heating
})

et:addUnit('Lautering', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Lautering']:addStreams({
  C5_Sparge_water_heating = qt{tin = 'C5_Sparge_water_heating_Tin', hin = 'C5_Sparge_water_heating_hin', tout = 'C5_Sparge_water_heating_Tout', hout = 'C5_Sparge_water_heating_hout', dtmin = 'C5_Sparge_water_heating_dTmin', alpha = 'C5_Sparge_water_heating_alpha'}, -- cold: Sparge water heating
})

et:addUnit('Wort_boiling', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Wort_boiling']:addStreams({
  C6_Wort_heating_to_boiling = qt{tin = 'C6_Wort_heating_to_boiling_Tin', hin = 'C6_Wort_heating_to_boiling_hin', tout = 'C6_Wort_heating_to_boiling_Tout', hout = 'C6_Wort_heating_to_boiling_hout', dtmin = 'C6_Wort_heating_to_boiling_dTmin', alpha = 'C6_Wort_heating_to_boiling_alpha'}, -- cold: Wort heating to boiling
  C7_Wort_boiling_water_evaporation = qt{tin = 'C7_Wort_boiling_water_evaporation_Tin', hin = 'C7_Wort_boiling_water_evaporation_hin', tout = 'C7_Wort_boiling_water_evaporation_Tout', hout = 'C7_Wort_boiling_water_evaporation_hout', dtmin = 'C7_Wort_boiling_water_evaporation_dTmin', alpha = 'C7_Wort_boiling_water_evaporation_alpha'}, -- cold: Wort boiling, water evaporation
  H1_Boiling_vapour_condensation_with = qt{tin = 'H1_Boiling_vapour_condensation_with_Tin', hin = 'H1_Boiling_vapour_condensation_with_hin', tout = 'H1_Boiling_vapour_condensation_with_Tout', hout = 'H1_Boiling_vapour_condensation_with_hout', dtmin = 'H1_Boiling_vapour_condensation_with_dTmin', alpha = 'H1_Boiling_vapour_condensation_with_alpha'}, -- hot: Boiling vapour, condensation (with desuperheating)
  H2_Vapour_condensate_cooling = qt{tin = 'H2_Vapour_condensate_cooling_Tin', hin = 'H2_Vapour_condensate_cooling_hin', tout = 'H2_Vapour_condensate_cooling_Tout', hout = 'H2_Vapour_condensate_cooling_hout', dtmin = 'H2_Vapour_condensate_cooling_dTmin', alpha = 'H2_Vapour_condensate_cooling_alpha'}, -- hot: Vapour condensate cooling
})

et:addUnit('Whirlpool', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Whirlpool']:addStreams({
  C8_Make_up_water_heating = qt{tin = 'C8_Make_up_water_heating_Tin', hin = 'C8_Make_up_water_heating_hin', tout = 'C8_Make_up_water_heating_Tout', hout = 'C8_Make_up_water_heating_hout', dtmin = 'C8_Make_up_water_heating_dTmin', alpha = 'C8_Make_up_water_heating_alpha'}, -- cold: Make-up water heating
})

et:addUnit('CIP', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['CIP']:addStreams({
  C9_Hot_water_for_cleaning_in_place = qt{tin = 'C9_Hot_water_for_cleaning_in_place_Tin', hin = 'C9_Hot_water_for_cleaning_in_place_hin', tout = 'C9_Hot_water_for_cleaning_in_place_Tout', hout = 'C9_Hot_water_for_cleaning_in_place_hout', dtmin = 'C9_Hot_water_for_cleaning_in_place_dTmin', alpha = 'C9_Hot_water_for_cleaning_in_place_alpha'}, -- cold: Hot water for cleaning in place
})

et:addUnit('Beer_treatment', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Beer_treatment']:addStreams({
  C10_Concentrated_beer_warming_before = qt{tin = 'C10_Concentrated_beer_warming_before_Tin', hin = 'C10_Concentrated_beer_warming_before_hin', tout = 'C10_Concentrated_beer_warming_before_Tout', hout = 'C10_Concentrated_beer_warming_before_hout', dtmin = 'C10_Concentrated_beer_warming_before_dTmin', alpha = 'C10_Concentrated_beer_warming_before_alpha'}, -- cold: Concentrated beer warming before dilution
  C11_Pasteurisation_heating = qt{tin = 'C11_Pasteurisation_heating_Tin', hin = 'C11_Pasteurisation_heating_hin', tout = 'C11_Pasteurisation_heating_Tout', hout = 'C11_Pasteurisation_heating_hout', dtmin = 'C11_Pasteurisation_heating_dTmin', alpha = 'C11_Pasteurisation_heating_alpha'}, -- cold: Pasteurisation heating
  H9_Pasteurised_beer_cooling = qt{tin = 'H9_Pasteurised_beer_cooling_Tin', hin = 'H9_Pasteurised_beer_cooling_hin', tout = 'H9_Pasteurised_beer_cooling_Tout', hout = 'H9_Pasteurised_beer_cooling_hout', dtmin = 'H9_Pasteurised_beer_cooling_dTmin', alpha = 'H9_Pasteurised_beer_cooling_alpha'}, -- hot: Pasteurised beer cooling
})

et:addUnit('Bottle_washing', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Bottle_washing']:addStreams({
  C12_Soda_bath_heating = qt{tin = 'C12_Soda_bath_heating_Tin', hin = 'C12_Soda_bath_heating_hin', tout = 'C12_Soda_bath_heating_Tout', hout = 'C12_Soda_bath_heating_hout', dtmin = 'C12_Soda_bath_heating_dTmin', alpha = 'C12_Soda_bath_heating_alpha'}, -- cold: Soda bath heating
  C13_Pre_rinse_bath_heating = qt{tin = 'C13_Pre_rinse_bath_heating_Tin', hin = 'C13_Pre_rinse_bath_heating_hin', tout = 'C13_Pre_rinse_bath_heating_Tout', hout = 'C13_Pre_rinse_bath_heating_hout', dtmin = 'C13_Pre_rinse_bath_heating_dTmin', alpha = 'C13_Pre_rinse_bath_heating_alpha'}, -- cold: Pre-rinse bath heating
  C14_Soda_bath_make_up_water_and_soda = qt{tin = 'C14_Soda_bath_make_up_water_and_soda_Tin', hin = 'C14_Soda_bath_make_up_water_and_soda_hin', tout = 'C14_Soda_bath_make_up_water_and_soda_Tout', hout = 'C14_Soda_bath_make_up_water_and_soda_hout', dtmin = 'C14_Soda_bath_make_up_water_and_soda_dTmin', alpha = 'C14_Soda_bath_make_up_water_and_soda_alpha'}, -- cold: Soda bath make-up, water and soda (lumped)
  C15_Pre_rinse_make_up_water_heating = qt{tin = 'C15_Pre_rinse_make_up_water_heating_Tin', hin = 'C15_Pre_rinse_make_up_water_heating_hin', tout = 'C15_Pre_rinse_make_up_water_heating_Tout', hout = 'C15_Pre_rinse_make_up_water_heating_hout', dtmin = 'C15_Pre_rinse_make_up_water_heating_dTmin', alpha = 'C15_Pre_rinse_make_up_water_heating_alpha'}, -- cold: Pre-rinse make-up water heating
  C16_Final_rinse_water_heating = qt{tin = 'C16_Final_rinse_water_heating_Tin', hin = 'C16_Final_rinse_water_heating_hin', tout = 'C16_Final_rinse_water_heating_Tout', hout = 'C16_Final_rinse_water_heating_hout', dtmin = 'C16_Final_rinse_water_heating_dTmin', alpha = 'C16_Final_rinse_water_heating_alpha'}, -- cold: Final rinse water heating
  H10_Soda_bath_rinse_water_cooling = qt{tin = 'H10_Soda_bath_rinse_water_cooling_Tin', hin = 'H10_Soda_bath_rinse_water_cooling_hin', tout = 'H10_Soda_bath_rinse_water_cooling_Tout', hout = 'H10_Soda_bath_rinse_water_cooling_hout', dtmin = 'H10_Soda_bath_rinse_water_cooling_dTmin', alpha = 'H10_Soda_bath_rinse_water_cooling_alpha'}, -- hot: Soda bath rinse water cooling
  H11_Pre_rinse_water_to_wastewater_co = qt{tin = 'H11_Pre_rinse_water_to_wastewater_co_Tin', hin = 'H11_Pre_rinse_water_to_wastewater_co_hin', tout = 'H11_Pre_rinse_water_to_wastewater_co_Tout', hout = 'H11_Pre_rinse_water_to_wastewater_co_hout', dtmin = 'H11_Pre_rinse_water_to_wastewater_co_dTmin', alpha = 'H11_Pre_rinse_water_to_wastewater_co_alpha'}, -- hot: Pre-rinse water to wastewater, cooling
})

et:addUnit('Digestion', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Digestion']:addStreams({
  C17_Digester_at_35_C_heat_demand = qt{tin = 'C17_Digester_at_35_C_heat_demand_Tin', hin = 'C17_Digester_at_35_C_heat_demand_hin', tout = 'C17_Digester_at_35_C_heat_demand_Tout', hout = 'C17_Digester_at_35_C_heat_demand_hout', dtmin = 'C17_Digester_at_35_C_heat_demand_dTmin', alpha = 'C17_Digester_at_35_C_heat_demand_alpha'}, -- cold: Digester at 35 C (heat demand)
  H12_Spent_grains_cooling_to_digester = qt{tin = 'H12_Spent_grains_cooling_to_digester_Tin', hin = 'H12_Spent_grains_cooling_to_digester_hin', tout = 'H12_Spent_grains_cooling_to_digester_Tout', hout = 'H12_Spent_grains_cooling_to_digester_hout', dtmin = 'H12_Spent_grains_cooling_to_digester_dTmin', alpha = 'H12_Spent_grains_cooling_to_digester_alpha'}, -- hot: Spent grains cooling to digester temperature
})

et:addUnit('Wort_cooling', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Wort_cooling']:addStreams({
  H3_Wort_cooling_to_pitching_tempera = qt{tin = 'H3_Wort_cooling_to_pitching_tempera_Tin', hin = 'H3_Wort_cooling_to_pitching_tempera_hin', tout = 'H3_Wort_cooling_to_pitching_tempera_Tout', hout = 'H3_Wort_cooling_to_pitching_tempera_hout', dtmin = 'H3_Wort_cooling_to_pitching_tempera_dTmin', alpha = 'H3_Wort_cooling_to_pitching_tempera_alpha'}, -- hot: Wort cooling to pitching temperature
})

et:addUnit('Fermentation', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Fermentation']:addStreams({
  H4_Fermentation_at_10_C_heat_of_fer = qt{tin = 'H4_Fermentation_at_10_C_heat_of_fer_Tin', hin = 'H4_Fermentation_at_10_C_heat_of_fer_hin', tout = 'H4_Fermentation_at_10_C_heat_of_fer_Tout', hout = 'H4_Fermentation_at_10_C_heat_of_fer_hout', dtmin = 'H4_Fermentation_at_10_C_heat_of_fer_dTmin', alpha = 'H4_Fermentation_at_10_C_heat_of_fer_alpha'}, -- hot: Fermentation at 10 C (heat of fermentation)
})

et:addUnit('Maturation', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Maturation']:addStreams({
  H5_Cooling_to_maturation_temperatur = qt{tin = 'H5_Cooling_to_maturation_temperatur_Tin', hin = 'H5_Cooling_to_maturation_temperatur_hin', tout = 'H5_Cooling_to_maturation_temperatur_Tout', hout = 'H5_Cooling_to_maturation_temperatur_hout', dtmin = 'H5_Cooling_to_maturation_temperatur_dTmin', alpha = 'H5_Cooling_to_maturation_temperatur_alpha'}, -- hot: Cooling to maturation temperature
  H6_Maturation_at_6_C = qt{tin = 'H6_Maturation_at_6_C_Tin', hin = 'H6_Maturation_at_6_C_hin', tout = 'H6_Maturation_at_6_C_Tout', hout = 'H6_Maturation_at_6_C_hout', dtmin = 'H6_Maturation_at_6_C_dTmin', alpha = 'H6_Maturation_at_6_C_alpha'}, -- hot: Maturation at 6 C
})

et:addUnit('Chillage', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Chillage']:addStreams({
  H7_Beer_chilling = qt{tin = 'H7_Beer_chilling_Tin', hin = 'H7_Beer_chilling_hin', tout = 'H7_Beer_chilling_Tout', hout = 'H7_Beer_chilling_hout', dtmin = 'H7_Beer_chilling_dTmin', alpha = 'H7_Beer_chilling_alpha'}, -- hot: Beer chilling
  H8_Chillage_at_1_C = qt{tin = 'H8_Chillage_at_1_C_Tin', hin = 'H8_Chillage_at_1_C_hin', tout = 'H8_Chillage_at_1_C_Tout', hout = 'H8_Chillage_at_1_C_hout', dtmin = 'H8_Chillage_at_1_C_dTmin', alpha = 'H8_Chillage_at_1_C_alpha'}, -- hot: Chillage at 1 C
})

-- ========== MATERIAL BOUNDARY AND PROCESS ELECTRICITY ==========
et:addUnit('Plant_boundary', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 'CAPACITY', Fmax = 'CAPACITY'})
et['Plant_boundary']:addStreams({
  MALT_in = rs{'MALT', 'in', 'MALT_flow'}, -- Malt
  CORN_ADJUNCT_in = rs{'CORN_ADJUNCT', 'in', 'CORN_ADJUNCT_flow'}, -- Corn (adjunct)
  WATER_FOR_MASHING_MAK_AND_MAT_in = rs{'WATER_FOR_MASHING_MAK_AND_MAT', 'in', 'WATER_FOR_MASHING_MAK_AND_MAT_flow'}, -- Water for mashing (MAK and MAT)
  SPARGE_WATER_in = rs{'SPARGE_WATER', 'in', 'SPARGE_WATER_flow'}, -- Sparge water
  MAKE_UP_WATER_AT_THE_WHIRLPOOL_in = rs{'MAKE_UP_WATER_AT_THE_WHIRLPOOL', 'in', 'MAKE_UP_WATER_AT_THE_WHIRLPOOL_flow'}, -- Make-up water at the whirlpool
  DILUTION_WATER_in = rs{'DILUTION_WATER', 'in', 'DILUTION_WATER_flow'}, -- Dilution water
  WATER_FOR_CLEANING_IN_PLACE_in = rs{'WATER_FOR_CLEANING_IN_PLACE', 'in', 'WATER_FOR_CLEANING_IN_PLACE_flow'}, -- Water for cleaning in place
  SODA_NAOH_FOR_BOTTLE_WASHING_in = rs{'SODA_NAOH_FOR_BOTTLE_WASHING', 'in', 'SODA_NAOH_FOR_BOTTLE_WASHING_flow'}, -- Soda (NaOH) for bottle washing
  WATER_FOR_BOTTLE_WASHING_SODA_BATH_PRE_R_in = rs{'WATER_FOR_BOTTLE_WASHING_SODA_BATH_PRE_R', 'in', 'WATER_FOR_BOTTLE_WASHING_SODA_BATH_PRE_R_flow'}, -- Water for bottle washing (soda bath, pre-rinse, final rinse)
  BEER_out = rs{'BEER', 'out', 'BEER_flow'}, -- Beer
  BIOGAS_out = rs{'BIOGAS', 'out', 'BIOGAS_flow'}, -- Biogas (55 vol % CH4)
  DIGESTATE_out = rs{'DIGESTATE', 'out', 'DIGESTATE_flow'}, -- Digestate
  VAPOUR_FROM_WORT_BOILING_out = rs{'VAPOUR_FROM_WORT_BOILING', 'out', 'VAPOUR_FROM_WORT_BOILING_flow'}, -- Vapour from wort boiling
  TRUB_out = rs{'TRUB', 'out', 'TRUB_flow'}, -- Trub
  CO2_FROM_FERMENTATION_out = rs{'CO2_FROM_FERMENTATION', 'out', 'CO2_FROM_FERMENTATION_flow'}, -- CO2 from fermentation
  HOT_WATER_TO_CLEANING_IN_PLACE_out = rs{'HOT_WATER_TO_CLEANING_IN_PLACE', 'out', 'HOT_WATER_TO_CLEANING_IN_PLACE_flow'}, -- Hot water to cleaning in place
  BOTTLE_WASHING_WASTEWATER_out = rs{'BOTTLE_WASHING_WASTEWATER', 'out', 'BOTTLE_WASHING_WASTEWATER_flow'}, -- Bottle-washing wastewater
  ELECTRICITY_process = rs{'ELECTRICITY', 'in', 'ELEC_process'}, -- process electricity, refrigeration excluded
})

-- ========== BIOGAS USE OPTIONS (utilities, selected by the optimisation) ==========
-- Engine efficiencies 30.0/31.1/20.9 % and dTmin/2 15 K (gas), 5 K (cooling water): Marechal et al. (2013), Table 27.10; membrane 0.21 kWh/Nm3 biogas (Bauer et al., 2013).
et:addUnit('Biogas_CHP_engine', {type = 'Utility', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 0, Fmax = 'CAPACITY'})
et['Biogas_CHP_engine']:addStreams({
  BIOGAS_in = rs{'BIOGAS', 'in', 'BIOGAS_flow'},
  ELECTRICITY_out = rs{'ELECTRICITY', 'out', 'CHP_elec'},
  CHP_flue_gas = qt{tin = 470, hin = 'CHP_flue_gas_Q', tout = 90, hout = 0, dtmin = 15, alpha = 1}, -- hot
  CHP_cooling_water = qt{tin = 87, hin = 'CHP_cooling_water_Q', tout = 80, hout = 0, dtmin = 5, alpha = 1}, -- hot
})
et:addUnit('Biogas_upgrading_export', {type = 'Utility', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0, Fmin = 0, Fmax = 'CAPACITY'})
et['Biogas_upgrading_export']:addStreams({
  BIOGAS_in = rs{'BIOGAS', 'in', 'BIOGAS_flow'},
  ELECTRICITY_in = rs{'ELECTRICITY', 'in', 'UPGRADING_elec'},
  BIOMETHANE_out = rs{'BIOMETHANE', 'out', 'BIOMETHANE_export'},
})

-- ========== INPUTS (values per 1 t/h of beer) ==========
et.inputs = {
  CAPACITY = {default = 1, unit = 't/h'}, -- reference plant: 68.69 t/h
  -- Mashing
  C1_Water_to_the_mash_cooker_MAK_Tin = {default = 15, unit = 'C'},
  C1_Water_to_the_mash_cooker_MAK_Tout = {default = 51.5, unit = 'C'},
  C1_Water_to_the_mash_cooker_MAK_hin = {default = 0, unit = 'kW'},
  C1_Water_to_the_mash_cooker_MAK_hout = {default = 5.38542, unit = 'kW'},
  C1_Water_to_the_mash_cooker_MAK_dTmin = {default = 5, unit = 'K'},
  C1_Water_to_the_mash_cooker_MAK_alpha = {default = 1, unit = 'kW/m2K'},
  C2_Water_to_the_mash_tun_MAT_Tin = {default = 15, unit = 'C'},
  C2_Water_to_the_mash_tun_MAT_Tout = {default = 54.5, unit = 'C'},
  C2_Water_to_the_mash_tun_MAT_hin = {default = 0, unit = 'kW'},
  C2_Water_to_the_mash_tun_MAT_hout = {default = 11.9909, unit = 'kW'},
  C2_Water_to_the_mash_tun_MAT_dTmin = {default = 5, unit = 'K'},
  C2_Water_to_the_mash_tun_MAT_alpha = {default = 1, unit = 'kW/m2K'},
  C3_Mash_heating_in_MAK_and_MAT_lump_Tin = {default = 48, unit = 'C'},
  C3_Mash_heating_in_MAK_and_MAT_lump_Tout = {default = 65, unit = 'C'},
  C3_Mash_heating_in_MAK_and_MAT_lump_hin = {default = 0, unit = 'kW'},
  C3_Mash_heating_in_MAK_and_MAT_lump_hout = {default = 8.86213, unit = 'kW'},
  C3_Mash_heating_in_MAK_and_MAT_lump_dTmin = {default = 5, unit = 'K'},
  C3_Mash_heating_in_MAK_and_MAT_lump_alpha = {default = 1, unit = 'kW/m2K'},
  C4_Combined_mash_heating_Tin = {default = 65, unit = 'C'},
  C4_Combined_mash_heating_Tout = {default = 75, unit = 'C'},
  C4_Combined_mash_heating_hin = {default = 0, unit = 'kW'},
  C4_Combined_mash_heating_hout = {default = 5.36358, unit = 'kW'},
  C4_Combined_mash_heating_dTmin = {default = 5, unit = 'K'},
  C4_Combined_mash_heating_alpha = {default = 1, unit = 'kW/m2K'},
  -- Lautering
  C5_Sparge_water_heating_Tin = {default = 15, unit = 'C'},
  C5_Sparge_water_heating_Tout = {default = 80, unit = 'C'},
  C5_Sparge_water_heating_hin = {default = 0, unit = 'kW'},
  C5_Sparge_water_heating_hout = {default = 23.4242, unit = 'kW'},
  C5_Sparge_water_heating_dTmin = {default = 5, unit = 'K'},
  C5_Sparge_water_heating_alpha = {default = 1, unit = 'kW/m2K'},
  -- Wort_boiling
  C6_Wort_heating_to_boiling_Tin = {default = 78, unit = 'C'},
  C6_Wort_heating_to_boiling_Tout = {default = 105, unit = 'C'},
  C6_Wort_heating_to_boiling_hin = {default = 0, unit = 'kW'},
  C6_Wort_heating_to_boiling_hout = {default = 24.2104, unit = 'kW'},
  C6_Wort_heating_to_boiling_dTmin = {default = 5, unit = 'K'},
  C6_Wort_heating_to_boiling_alpha = {default = 1, unit = 'kW/m2K'},
  C7_Wort_boiling_water_evaporation_Tin = {default = 105, unit = 'C'},
  C7_Wort_boiling_water_evaporation_Tout = {default = 105.1, unit = 'C'},
  C7_Wort_boiling_water_evaporation_hin = {default = 0, unit = 'kW'},
  C7_Wort_boiling_water_evaporation_hout = {default = 48.3333, unit = 'kW'},
  C7_Wort_boiling_water_evaporation_dTmin = {default = 2, unit = 'K'},
  C7_Wort_boiling_water_evaporation_alpha = {default = 1, unit = 'kW/m2K'},
  H1_Boiling_vapour_condensation_with_Tin = {default = 100.1, unit = 'C'},
  H1_Boiling_vapour_condensation_with_Tout = {default = 100, unit = 'C'},
  H1_Boiling_vapour_condensation_with_hin = {default = 51.0311, unit = 'kW'},
  H1_Boiling_vapour_condensation_with_hout = {default = 0, unit = 'kW'},
  H1_Boiling_vapour_condensation_with_dTmin = {default = 2, unit = 'K'},
  H1_Boiling_vapour_condensation_with_alpha = {default = 1, unit = 'kW/m2K'},
  H2_Vapour_condensate_cooling_Tin = {default = 100, unit = 'C'},
  H2_Vapour_condensate_cooling_Tout = {default = 25, unit = 'C'},
  H2_Vapour_condensate_cooling_hin = {default = 7.02914, unit = 'kW'},
  H2_Vapour_condensate_cooling_hout = {default = 0, unit = 'kW'},
  H2_Vapour_condensate_cooling_dTmin = {default = 5, unit = 'K'},
  H2_Vapour_condensate_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  -- Whirlpool
  C8_Make_up_water_heating_Tin = {default = 15, unit = 'C'},
  C8_Make_up_water_heating_Tout = {default = 80, unit = 'C'},
  C8_Make_up_water_heating_hin = {default = 0, unit = 'kW'},
  C8_Make_up_water_heating_hout = {default = 5.50237, unit = 'kW'},
  C8_Make_up_water_heating_dTmin = {default = 5, unit = 'K'},
  C8_Make_up_water_heating_alpha = {default = 1, unit = 'kW/m2K'},
  -- CIP
  C9_Hot_water_for_cleaning_in_place_Tin = {default = 15, unit = 'C'},
  C9_Hot_water_for_cleaning_in_place_Tout = {default = 80, unit = 'C'},
  C9_Hot_water_for_cleaning_in_place_hin = {default = 0, unit = 'kW'},
  C9_Hot_water_for_cleaning_in_place_hout = {default = 26.8048, unit = 'kW'},
  C9_Hot_water_for_cleaning_in_place_dTmin = {default = 5, unit = 'K'},
  C9_Hot_water_for_cleaning_in_place_alpha = {default = 1, unit = 'kW/m2K'},
  -- Beer_treatment
  C10_Concentrated_beer_warming_before_Tin = {default = 1, unit = 'C'},
  C10_Concentrated_beer_warming_before_Tout = {default = 15, unit = 'C'},
  C10_Concentrated_beer_warming_before_hin = {default = 0, unit = 'kW'},
  C10_Concentrated_beer_warming_before_hout = {default = 11.4128, unit = 'kW'},
  C10_Concentrated_beer_warming_before_dTmin = {default = 5, unit = 'K'},
  C10_Concentrated_beer_warming_before_alpha = {default = 1, unit = 'kW/m2K'},
  C11_Pasteurisation_heating_Tin = {default = 15, unit = 'C'},
  C11_Pasteurisation_heating_Tout = {default = 70, unit = 'C'},
  C11_Pasteurisation_heating_hin = {default = 0, unit = 'kW'},
  C11_Pasteurisation_heating_hout = {default = 59.7983, unit = 'kW'},
  C11_Pasteurisation_heating_dTmin = {default = 5, unit = 'K'},
  C11_Pasteurisation_heating_alpha = {default = 1, unit = 'kW/m2K'},
  H9_Pasteurised_beer_cooling_Tin = {default = 70, unit = 'C'},
  H9_Pasteurised_beer_cooling_Tout = {default = 5, unit = 'C'},
  H9_Pasteurised_beer_cooling_hin = {default = 70.734, unit = 'kW'},
  H9_Pasteurised_beer_cooling_hout = {default = 0, unit = 'kW'},
  H9_Pasteurised_beer_cooling_dTmin = {default = 5, unit = 'K'},
  H9_Pasteurised_beer_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  -- Bottle_washing
  C12_Soda_bath_heating_Tin = {default = 65, unit = 'C'},
  C12_Soda_bath_heating_Tout = {default = 85, unit = 'C'},
  C12_Soda_bath_heating_hin = {default = 0, unit = 'kW'},
  C12_Soda_bath_heating_hout = {default = 3.66744, unit = 'kW'},
  C12_Soda_bath_heating_dTmin = {default = 5, unit = 'K'},
  C12_Soda_bath_heating_alpha = {default = 1, unit = 'kW/m2K'},
  C13_Pre_rinse_bath_heating_Tin = {default = 40, unit = 'C'},
  C13_Pre_rinse_bath_heating_Tout = {default = 60, unit = 'C'},
  C13_Pre_rinse_bath_heating_hin = {default = 0, unit = 'kW'},
  C13_Pre_rinse_bath_heating_hout = {default = 6.88355, unit = 'kW'},
  C13_Pre_rinse_bath_heating_dTmin = {default = 5, unit = 'K'},
  C13_Pre_rinse_bath_heating_alpha = {default = 1, unit = 'kW/m2K'},
  C14_Soda_bath_make_up_water_and_soda_Tin = {default = 15, unit = 'C'},
  C14_Soda_bath_make_up_water_and_soda_Tout = {default = 85, unit = 'C'},
  C14_Soda_bath_make_up_water_and_soda_hin = {default = 0, unit = 'kW'},
  C14_Soda_bath_make_up_water_and_soda_hout = {default = 19.3185, unit = 'kW'},
  C14_Soda_bath_make_up_water_and_soda_dTmin = {default = 5, unit = 'K'},
  C14_Soda_bath_make_up_water_and_soda_alpha = {default = 1, unit = 'kW/m2K'},
  C15_Pre_rinse_make_up_water_heating_Tin = {default = 15, unit = 'C'},
  C15_Pre_rinse_make_up_water_heating_Tout = {default = 60, unit = 'C'},
  C15_Pre_rinse_make_up_water_heating_hin = {default = 0, unit = 'kW'},
  C15_Pre_rinse_make_up_water_heating_hout = {default = 0.426582, unit = 'kW'},
  C15_Pre_rinse_make_up_water_heating_dTmin = {default = 5, unit = 'K'},
  C15_Pre_rinse_make_up_water_heating_alpha = {default = 1, unit = 'kW/m2K'},
  C16_Final_rinse_water_heating_Tin = {default = 35, unit = 'C'},
  C16_Final_rinse_water_heating_Tout = {default = 60, unit = 'C'},
  C16_Final_rinse_water_heating_hin = {default = 0, unit = 'kW'},
  C16_Final_rinse_water_heating_hout = {default = 5.81404, unit = 'kW'},
  C16_Final_rinse_water_heating_dTmin = {default = 5, unit = 'K'},
  C16_Final_rinse_water_heating_alpha = {default = 1, unit = 'kW/m2K'},
  H10_Soda_bath_rinse_water_cooling_Tin = {default = 85, unit = 'C'},
  H10_Soda_bath_rinse_water_cooling_Tout = {default = 60, unit = 'C'},
  H10_Soda_bath_rinse_water_cooling_hin = {default = 6.88209, unit = 'kW'},
  H10_Soda_bath_rinse_water_cooling_hout = {default = 0, unit = 'kW'},
  H10_Soda_bath_rinse_water_cooling_dTmin = {default = 5, unit = 'K'},
  H10_Soda_bath_rinse_water_cooling_alpha = {default = 1, unit = 'kW/m2K'},
  H11_Pre_rinse_water_to_wastewater_co_Tin = {default = 40, unit = 'C'},
  H11_Pre_rinse_water_to_wastewater_co_Tout = {default = 20, unit = 'C'},
  H11_Pre_rinse_water_to_wastewater_co_hin = {default = 10.3908, unit = 'kW'},
  H11_Pre_rinse_water_to_wastewater_co_hout = {default = 0, unit = 'kW'},
  H11_Pre_rinse_water_to_wastewater_co_dTmin = {default = 5, unit = 'K'},
  H11_Pre_rinse_water_to_wastewater_co_alpha = {default = 1, unit = 'kW/m2K'},
  -- Digestion
  C17_Digester_at_35_C_heat_demand_Tin = {default = 35, unit = 'C'},
  C17_Digester_at_35_C_heat_demand_Tout = {default = 35.1, unit = 'C'},
  C17_Digester_at_35_C_heat_demand_hin = {default = 0, unit = 'kW'},
  C17_Digester_at_35_C_heat_demand_hout = {default = 5.91201, unit = 'kW'},
  C17_Digester_at_35_C_heat_demand_dTmin = {default = 5, unit = 'K'},
  C17_Digester_at_35_C_heat_demand_alpha = {default = 1, unit = 'kW/m2K'},
  H12_Spent_grains_cooling_to_digester_Tin = {default = 75, unit = 'C'},
  H12_Spent_grains_cooling_to_digester_Tout = {default = 35, unit = 'C'},
  H12_Spent_grains_cooling_to_digester_hin = {default = 0.794893, unit = 'kW'},
  H12_Spent_grains_cooling_to_digester_hout = {default = 0, unit = 'kW'},
  H12_Spent_grains_cooling_to_digester_dTmin = {default = 5, unit = 'K'},
  H12_Spent_grains_cooling_to_digester_alpha = {default = 1, unit = 'kW/m2K'},
  -- Wort_cooling
  H3_Wort_cooling_to_pitching_tempera_Tin = {default = 102.5, unit = 'C'},
  H3_Wort_cooling_to_pitching_tempera_Tout = {default = 10, unit = 'C'},
  H3_Wort_cooling_to_pitching_tempera_hin = {default = 79.123, unit = 'kW'},
  H3_Wort_cooling_to_pitching_tempera_hout = {default = 0, unit = 'kW'},
  H3_Wort_cooling_to_pitching_tempera_dTmin = {default = 5, unit = 'K'},
  H3_Wort_cooling_to_pitching_tempera_alpha = {default = 1, unit = 'kW/m2K'},
  -- Fermentation
  H4_Fermentation_at_10_C_heat_of_fer_Tin = {default = 10, unit = 'C'},
  H4_Fermentation_at_10_C_heat_of_fer_Tout = {default = 9.9, unit = 'C'},
  H4_Fermentation_at_10_C_heat_of_fer_hin = {default = 7.78621, unit = 'kW'},
  H4_Fermentation_at_10_C_heat_of_fer_hout = {default = 0, unit = 'kW'},
  H4_Fermentation_at_10_C_heat_of_fer_dTmin = {default = 5, unit = 'K'},
  H4_Fermentation_at_10_C_heat_of_fer_alpha = {default = 1, unit = 'kW/m2K'},
  -- Maturation
  H5_Cooling_to_maturation_temperatur_Tin = {default = 10, unit = 'C'},
  H5_Cooling_to_maturation_temperatur_Tout = {default = 6, unit = 'C'},
  H5_Cooling_to_maturation_temperatur_hin = {default = 3.40392, unit = 'kW'},
  H5_Cooling_to_maturation_temperatur_hout = {default = 0, unit = 'kW'},
  H5_Cooling_to_maturation_temperatur_dTmin = {default = 5, unit = 'K'},
  H5_Cooling_to_maturation_temperatur_alpha = {default = 1, unit = 'kW/m2K'},
  H6_Maturation_at_6_C_Tin = {default = 6, unit = 'C'},
  H6_Maturation_at_6_C_Tout = {default = 5.9, unit = 'C'},
  H6_Maturation_at_6_C_hin = {default = 6.1949, unit = 'kW'},
  H6_Maturation_at_6_C_hout = {default = 0, unit = 'kW'},
  H6_Maturation_at_6_C_dTmin = {default = 5, unit = 'K'},
  H6_Maturation_at_6_C_alpha = {default = 1, unit = 'kW/m2K'},
  -- Chillage
  H7_Beer_chilling_Tin = {default = 6, unit = 'C'},
  H7_Beer_chilling_Tout = {default = 1, unit = 'C'},
  H7_Beer_chilling_hin = {default = 10.4025, unit = 'kW'},
  H7_Beer_chilling_hout = {default = 0, unit = 'kW'},
  H7_Beer_chilling_dTmin = {default = 5, unit = 'K'},
  H7_Beer_chilling_alpha = {default = 1, unit = 'kW/m2K'},
  H8_Chillage_at_1_C_Tin = {default = 1, unit = 'C'},
  H8_Chillage_at_1_C_Tout = {default = 0.9, unit = 'C'},
  H8_Chillage_at_1_C_hin = {default = 6.22693, unit = 'kW'},
  H8_Chillage_at_1_C_hout = {default = 0, unit = 'kW'},
  H8_Chillage_at_1_C_dTmin = {default = 5, unit = 'K'},
  H8_Chillage_at_1_C_alpha = {default = 1, unit = 'kW/m2K'},
  -- material flows (kg/h per t/h) and electricity (kW per t/h)
  MALT_flow = {default = 139.885, unit = 'kg/h'}, -- in: Malt
  CORN_ADJUNCT_flow = {default = 11.5151, unit = 'kg/h'}, -- in: Corn (adjunct)
  WATER_FOR_MASHING_MAK_AND_MAT_flow = {default = 388.206, unit = 'kg/h'}, -- in: Water for mashing (MAK and MAT)
  SPARGE_WATER_flow = {default = 309.917, unit = 'kg/h'}, -- in: Sparge water
  MAKE_UP_WATER_AT_THE_WHIRLPOOL_flow = {default = 72.8014, unit = 'kg/h'}, -- in: Make-up water at the whirlpool
  DILUTION_WATER_flow = {default = 237.302, unit = 'kg/h'}, -- in: Dilution water
  WATER_FOR_CLEANING_IN_PLACE_flow = {default = 354.677, unit = 'kg/h'}, -- in: Water for cleaning in place
  SODA_NAOH_FOR_BOTTLE_WASHING_flow = {default = 20.0007, unit = 'kg/h'}, -- in: Soda (NaOH) for bottle washing
  WATER_FOR_BOTTLE_WASHING_SODA_BATH_PRE_R_flow = {default = 438.14, unit = 'kg/h'}, -- in: Water for bottle washing (soda bath, pre-rinse, final rinse)
  BEER_flow = {default = 1000, unit = 'kg/h'}, -- out: Beer
  BIOGAS_flow = {default = 6.95833, unit = 'kg/h'}, -- out: Biogas (55 vol % CH4)
  DIGESTATE_flow = {default = 32.7863, unit = 'kg/h'}, -- out: Digestate
  VAPOUR_FROM_WORT_BOILING_flow = {default = 80.9778, unit = 'kg/h'}, -- out: Vapour from wort boiling
  TRUB_flow = {default = 1.60383, unit = 'kg/h'}, -- out: Trub
  CO2_FROM_FERMENTATION_flow = {default = 37.3, unit = 'kg/h'}, -- out: CO2 from fermentation
  HOT_WATER_TO_CLEANING_IN_PLACE_flow = {default = 354.677, unit = 'kg/h'}, -- out: Hot water to cleaning in place
  BOTTLE_WASHING_WASTEWATER_flow = {default = 458.14, unit = 'kg/h'}, -- out: Bottle-washing wastewater
  ELEC_process = {default = 60.5655, unit = 'kW'},
  CHP_elec = {default = 8.86802, unit = 'kW'},
  CHP_flue_gas_Q = {default = 9.19614, unit = 'kW'},
  CHP_cooling_water_Q = {default = 6.1751, unit = 'kW'},
  UPGRADING_elec = {default = 1.13814, unit = 'kW'},
  BIOMETHANE_export = {default = 29.5601, unit = 'kW'},
}

et.outputs = {}

return et
