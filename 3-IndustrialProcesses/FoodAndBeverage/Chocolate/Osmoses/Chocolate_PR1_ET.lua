local osmose = require 'osmose'
local et     = osmose.Model 'Chocolate_PR1_ET'

et.header = {
  name        = 'Chocolate_PR1_ET',
  displayName = 'Milk chocolate (route PR1)',
  authors     = {'Daniel Flórez-Orrego, EPFL IPESE research group', 'Meire Ribeiro Domingos, EPFL IPESE research group',
                 'Pullah Bhatnagar, EPFL IPESE research group', 'Oktay Boztas, EPFL IPESE research group'},
  versions    = {'1.0'},
  title       = 'Milk chocolate from whole cocoa beans (route PR1)',
  description = [[Milk chocolate from whole fermented cocoa beans: debacterization, whole-bean roasting with hot air,
  cooling and winnowing, grinding into cocoa liquor, pressing of part of the liquor into cocoa butter and press cake,
  mixing and refining, conching, tempering, moulding and cooling. Flows and heat loads are given per 1 t/h of chocolate
  and scale with choco_prod. Utilities (heat, refrigeration, cooling water) are not part of the process data.]],
  references  = {'Bhadbhade et al. (2024), J. Clean. Prod. 455, 142323, https://doi.org/10.1016/j.jclepro.2024.142323',
                 'Process data: case study of route PR1, Documents/PR1casestudyChocolate.docx'},
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  -- Production rate: 1 t/h is the reference; the category 1 plant (1,000 t/y over 3,600 h/y) is 0.278 t/h
  choco_prod = {default = 1, unit = 't/h'},

  -- Global dTmin = 10 K, applied as dTmin/2 = 5 K on every stream
  dtmin = {default = 5, unit = 'C'},

---------------------
-- Material flows per t of chocolate (closure: 1,094.3 kg in and out)
---------------------
  beans_in_r        = {default = 263, unit = 'kg/t'}, -- Cocoa beans
  sugar_in_r        = {default = 445, unit = 'kg/t'}, -- Sugar
  milkpowder_in_r   = {default = 200, unit = 'kg/t'}, -- Whole milk powder
  lecithin_in_r     = {default = 5, unit = 'kg/t'}, -- Lecithin
  butter_in_r       = {default = 181.3, unit = 'kg/t'}, -- Purchased cocoa butter
  chocolate_out_r   = {default = 1000, unit = 'kg/t'}, -- Milk chocolate
  shells_out_r      = {default = 30.1, unit = 'kg/t'}, -- Cocoa shells
  vapour_out_r      = {default = 12.1, unit = 'kg/t'}, -- Water vapour in the roaster exhaust
  presscake_out_r   = {default = 52.1, unit = 'kg/t'}, -- Cocoa press cake

  -- Internal flows and utility media (information only, not resource streams)
  roasted_beans_r   = {default = 251, unit = 'kg/t'}, -- Roasted beans
  nibs_r            = {default = 220.8, unit = 'kg/t'}, -- Nibs
  liquor_recipe_r   = {default = 120, unit = 'kg/t'}, -- Cocoa liquor to the recipe
  liquor_press_r    = {default = 100.8, unit = 'kg/t'}, -- Cocoa liquor to the press
  butter_own_r      = {default = 48.7, unit = 'kg/t'}, -- Own pressed cocoa butter
  roast_air_r       = {default = 3284, unit = 'kg/t'}, -- Roasting air
  steam_drying_r    = {default = 86, unit = 'kg/t'}, -- Steam to drying
  steam_debact_r    = {default = 30, unit = 'kg/t'}, -- Steam to debacterization
  cip_water_r       = {default = 71, unit = 'kg/t'}, -- CIP rinse water

---------------------
-- Process electricity per t of chocolate (heat and refrigeration are qt streams, not electricity)
---------------------
  E_aircomp_r       = {default = 102, unit = 'kWh/t'}, -- Air compressors
  E_conche_r        = {default = 237, unit = 'kWh/t'}, -- Conche drives
  E_grinder_r       = {default = 30, unit = 'kWh/t'}, -- Grinder drives
  E_other_r         = {default = 514, unit = 'kWh/t'}, -- Other drives, fans, lighting and packaging

---------------------
-- Thermal streams: Tin, Tout and specific heat load per t of chocolate
-- Source: Bhadbhade et al. (2024), supplementary Appendix 6; H11 from the refrigeration heat rejection
---------------------

  -- Cold streams (to be heated)
  c1_Tin   = {default = 20, unit = 'C'}, c1_Tout   = {default = 145, unit = 'C'}, c1_q   = {default = 61.9, unit = 'kWh/t'}, -- Roasting air, zone 1
  c2_Tin   = {default = 20, unit = 'C'}, c2_Tout   = {default = 155, unit = 'C'}, c2_q   = {default = 73.44, unit = 'kWh/t'}, -- Roasting air, zone 2
  c3_Tin   = {default = 20, unit = 'C'}, c3_Tout   = {default = 160, unit = 'C'}, c3_q   = {default = 95.91, unit = 'kWh/t'}, -- Roasting air, zone 3
  c4_Tin   = {default = 164, unit = 'C'}, c4_Tout   = {default = 165, unit = 'C'}, c4_q   = {default = 48.96, unit = 'kWh/t'}, -- Drying, steam-jacketed mixer
  c5_Tin   = {default = 25, unit = 'C'}, c5_Tout   = {default = 80, unit = 'C'}, c5_q   = {default = 16.98, unit = 'kWh/t'}, -- Debacterization of beans
  c6_Tin   = {default = 80, unit = 'C'}, c6_Tout   = {default = 80.1, unit = 'C'}, c6_q   = {default = 3, unit = 'kWh/t'}, -- CIP caustic solution
  c7_Tin   = {default = 60, unit = 'C'}, c7_Tout   = {default = 60.1, unit = 'C'}, c7_q   = {default = 1.04, unit = 'kWh/t'}, -- CIP acid solution
  c8_Tin   = {default = 10, unit = 'C'}, c8_Tout   = {default = 40, unit = 'C'}, c8_q   = {default = 2.48, unit = 'kWh/t'}, -- CIP rinse water
  c9_Tin   = {default = 25, unit = 'C'}, c9_Tout   = {default = 55, unit = 'C'}, c9_q   = {default = 215.93, unit = 'kWh/t'}, -- Tracing warm-water network
  c10_Tin  = {default = 43, unit = 'C'}, c10_Tout  = {default = 50, unit = 'C'}, c10_q  = {default = 0.5, unit = 'kWh/t'}, -- Press 1, liquor feed
  c11_Tin  = {default = 20, unit = 'C'}, c11_Tout  = {default = 50, unit = 'C'}, c11_q  = {default = 0.55, unit = 'kWh/t'}, -- Press 2, feed
  c12_Tin  = {default = 40, unit = 'C'}, c12_Tout  = {default = 55, unit = 'C'}, c12_q  = {default = 6.26, unit = 'kWh/t'}, -- Conche line A, heating
  c13_Tin  = {default = 35, unit = 'C'}, c13_Tout  = {default = 80, unit = 'C'}, c13_q  = {default = 8.44, unit = 'kWh/t'}, -- Conche line B, heating
  c14_Tin  = {default = 35, unit = 'C'}, c14_Tout  = {default = 42, unit = 'C'}, c14_q  = {default = 0.47, unit = 'kWh/t'}, -- Conche line C, heating
  c15_Tin  = {default = 35, unit = 'C'}, c15_Tout  = {default = 42, unit = 'C'}, c15_q  = {default = 0.74, unit = 'kWh/t'}, -- Conche line D, heating
  c16_Tin  = {default = 45, unit = 'C'}, c16_Tout  = {default = 46, unit = 'C'}, c16_q  = {default = 27.5, unit = 'kWh/t'}, -- Tempering tank 1
  c17_Tin  = {default = 42, unit = 'C'}, c17_Tout  = {default = 43, unit = 'C'}, c17_q  = {default = 43.26, unit = 'kWh/t'}, -- Tempering tank 2
  c18_Tin  = {default = 42, unit = 'C'}, c18_Tout  = {default = 43, unit = 'C'}, c18_q  = {default = 3.69, unit = 'kWh/t'}, -- Tempering tank 3
  c19_Tin  = {default = 45, unit = 'C'}, c19_Tout  = {default = 46, unit = 'C'}, c19_q  = {default = 0.95, unit = 'kWh/t'}, -- Tempering tank 4
  c20_Tin  = {default = 47, unit = 'C'}, c20_Tout  = {default = 48, unit = 'C'}, c20_q  = {default = 2.19, unit = 'kWh/t'}, -- Tempering tank 5
  c21_Tin  = {default = 43, unit = 'C'}, c21_Tout  = {default = 44, unit = 'C'}, c21_q  = {default = 1.23, unit = 'kWh/t'}, -- Tempering tank 6
  c22_Tin  = {default = 50, unit = 'C'}, c22_Tout  = {default = 51, unit = 'C'}, c22_q  = {default = 5.49, unit = 'kWh/t'}, -- Tempering tank 7
  c23_Tin  = {default = 45, unit = 'C'}, c23_Tout  = {default = 46, unit = 'C'}, c23_q  = {default = 2.75, unit = 'kWh/t'}, -- Tempering tank 8
  c24_Tin  = {default = 42, unit = 'C'}, c24_Tout  = {default = 43, unit = 'C'}, c24_q  = {default = 1.36, unit = 'kWh/t'}, -- Tempering tank 9
  c25_Tin  = {default = 30, unit = 'C'}, c25_Tout  = {default = 35, unit = 'C'}, c25_q  = {default = 1.99, unit = 'kWh/t'}, -- Moulding line A, step 1
  c26_Tin  = {default = 35, unit = 'C'}, c26_Tout  = {default = 36, unit = 'C'}, c26_q  = {default = 3.34, unit = 'kWh/t'}, -- Moulding line A, step 2
  c27_Tin  = {default = 36, unit = 'C'}, c27_Tout  = {default = 39, unit = 'C'}, c27_q  = {default = 1.46, unit = 'kWh/t'}, -- Moulding line A, step 3
  c28_Tin  = {default = 39, unit = 'C'}, c28_Tout  = {default = 41, unit = 'C'}, c28_q  = {default = 1.1, unit = 'kWh/t'}, -- Moulding line A, step 4
  c29_Tin  = {default = 41, unit = 'C'}, c29_Tout  = {default = 48, unit = 'C'}, c29_q  = {default = 3.12, unit = 'kWh/t'}, -- Moulding line A, step 5
  c30_Tin  = {default = 48, unit = 'C'}, c30_Tout  = {default = 49, unit = 'C'}, c30_q  = {default = 0.48, unit = 'kWh/t'}, -- Moulding line A, step 6
  c31_Tin  = {default = 30, unit = 'C'}, c31_Tout  = {default = 42, unit = 'C'}, c31_q  = {default = 3.91, unit = 'kWh/t'}, -- Moulding line B, step 1
  c32_Tin  = {default = 42, unit = 'C'}, c32_Tout  = {default = 43, unit = 'C'}, c32_q  = {default = 0.37, unit = 'kWh/t'}, -- Moulding line B, step 2
  c33_Tin  = {default = 43, unit = 'C'}, c33_Tout  = {default = 54, unit = 'C'}, c33_q  = {default = 3.98, unit = 'kWh/t'}, -- Moulding line B, step 3
  c34_Tin  = {default = 54, unit = 'C'}, c34_Tout  = {default = 55, unit = 'C'}, c34_q  = {default = 0.43, unit = 'kWh/t'}, -- Moulding line B, step 4

  -- Hot streams (to be cooled)
  h1_Tin   = {default = 30, unit = 'C'}, h1_Tout   = {default = 20, unit = 'C'}, h1_q   = {default = 23.84, unit = 'kWh/t'}, -- Roaster exhaust, zone 1
  h2_Tin   = {default = 46, unit = 'C'}, h2_Tout   = {default = 20, unit = 'C'}, h2_q   = {default = 35.32, unit = 'kWh/t'}, -- Roaster exhaust, zone 2
  h3_Tin   = {default = 110, unit = 'C'}, h3_Tout   = {default = 20, unit = 'C'}, h3_q   = {default = 62.31, unit = 'kWh/t'}, -- Roaster exhaust, zone 3
  h4_Tin   = {default = 45, unit = 'C'}, h4_Tout   = {default = 20, unit = 'C'}, h4_q   = {default = 0.92, unit = 'kWh/t'}, -- Press 1, cake cooling
  h5_Tin   = {default = 50, unit = 'C'}, h5_Tout   = {default = 20, unit = 'C'}, h5_q   = {default = 1.11, unit = 'kWh/t'}, -- Press 2, cake cooling
  h6_Tin   = {default = 70, unit = 'C'}, h6_Tout   = {default = 16.1, unit = 'C'}, h6_q   = {default = 102.08, unit = 'kWh/t'}, -- Air compressors, heat recovery
  h7_Tin   = {default = 55, unit = 'C'}, h7_Tout   = {default = 20, unit = 'C'}, h7_q   = {default = 92.2, unit = 'kWh/t'}, -- Conche line A, cooling
  h8_Tin   = {default = 80, unit = 'C'}, h8_Tout   = {default = 20, unit = 'C'}, h8_q   = {default = 118.55, unit = 'kWh/t'}, -- Conche line B, cooling
  h9_Tin   = {default = 42, unit = 'C'}, h9_Tout   = {default = 20, unit = 'C'}, h9_q   = {default = 5.79, unit = 'kWh/t'}, -- Conche line C, cooling
  h10_Tin  = {default = 42, unit = 'C'}, h10_Tout  = {default = 20, unit = 'C'}, h10_q  = {default = 36.22, unit = 'kWh/t'}, -- Conche line D, cooling
  h11_Tin  = {default = 11, unit = 'C'}, h11_Tout  = {default = 5, unit = 'C'}, h11_q  = {default = 337.46, unit = 'kWh/t'}, -- Production cooling, chilled-water level

}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  beans_in        = {unit = 'kg/h', job = 'beans_in_r*choco_prod'},
  sugar_in        = {unit = 'kg/h', job = 'sugar_in_r*choco_prod'},
  milkpowder_in   = {unit = 'kg/h', job = 'milkpowder_in_r*choco_prod'},
  lecithin_in     = {unit = 'kg/h', job = 'lecithin_in_r*choco_prod'},
  butter_in       = {unit = 'kg/h', job = 'butter_in_r*choco_prod'},
  chocolate_out   = {unit = 'kg/h', job = 'chocolate_out_r*choco_prod'},
  shells_out      = {unit = 'kg/h', job = 'shells_out_r*choco_prod'},
  vapour_out      = {unit = 'kg/h', job = 'vapour_out_r*choco_prod'},
  presscake_out   = {unit = 'kg/h', job = 'presscake_out_r*choco_prod'},

  E_aircomp       = {unit = 'kW', job = 'E_aircomp_r*choco_prod'},
  E_conche        = {unit = 'kW', job = 'E_conche_r*choco_prod'},
  E_grinder       = {unit = 'kW', job = 'E_grinder_r*choco_prod'},
  E_other         = {unit = 'kW', job = 'E_other_r*choco_prod'},
  E_total         = {unit = 'kW', job = 'E_aircomp()+E_conche()+E_grinder()+E_other()'},

  c1_Q            = {unit = 'kW', job = 'c1_q*choco_prod'},
  c2_Q            = {unit = 'kW', job = 'c2_q*choco_prod'},
  c3_Q            = {unit = 'kW', job = 'c3_q*choco_prod'},
  c4_Q            = {unit = 'kW', job = 'c4_q*choco_prod'},
  c5_Q            = {unit = 'kW', job = 'c5_q*choco_prod'},
  c6_Q            = {unit = 'kW', job = 'c6_q*choco_prod'},
  c7_Q            = {unit = 'kW', job = 'c7_q*choco_prod'},
  c8_Q            = {unit = 'kW', job = 'c8_q*choco_prod'},
  c9_Q            = {unit = 'kW', job = 'c9_q*choco_prod'},
  c10_Q           = {unit = 'kW', job = 'c10_q*choco_prod'},
  c11_Q           = {unit = 'kW', job = 'c11_q*choco_prod'},
  c12_Q           = {unit = 'kW', job = 'c12_q*choco_prod'},
  c13_Q           = {unit = 'kW', job = 'c13_q*choco_prod'},
  c14_Q           = {unit = 'kW', job = 'c14_q*choco_prod'},
  c15_Q           = {unit = 'kW', job = 'c15_q*choco_prod'},
  c16_Q           = {unit = 'kW', job = 'c16_q*choco_prod'},
  c17_Q           = {unit = 'kW', job = 'c17_q*choco_prod'},
  c18_Q           = {unit = 'kW', job = 'c18_q*choco_prod'},
  c19_Q           = {unit = 'kW', job = 'c19_q*choco_prod'},
  c20_Q           = {unit = 'kW', job = 'c20_q*choco_prod'},
  c21_Q           = {unit = 'kW', job = 'c21_q*choco_prod'},
  c22_Q           = {unit = 'kW', job = 'c22_q*choco_prod'},
  c23_Q           = {unit = 'kW', job = 'c23_q*choco_prod'},
  c24_Q           = {unit = 'kW', job = 'c24_q*choco_prod'},
  c25_Q           = {unit = 'kW', job = 'c25_q*choco_prod'},
  c26_Q           = {unit = 'kW', job = 'c26_q*choco_prod'},
  c27_Q           = {unit = 'kW', job = 'c27_q*choco_prod'},
  c28_Q           = {unit = 'kW', job = 'c28_q*choco_prod'},
  c29_Q           = {unit = 'kW', job = 'c29_q*choco_prod'},
  c30_Q           = {unit = 'kW', job = 'c30_q*choco_prod'},
  c31_Q           = {unit = 'kW', job = 'c31_q*choco_prod'},
  c32_Q           = {unit = 'kW', job = 'c32_q*choco_prod'},
  c33_Q           = {unit = 'kW', job = 'c33_q*choco_prod'},
  c34_Q           = {unit = 'kW', job = 'c34_q*choco_prod'},
  h1_Q            = {unit = 'kW', job = 'h1_q*choco_prod'},
  h2_Q            = {unit = 'kW', job = 'h2_q*choco_prod'},
  h3_Q            = {unit = 'kW', job = 'h3_q*choco_prod'},
  h4_Q            = {unit = 'kW', job = 'h4_q*choco_prod'},
  h5_Q            = {unit = 'kW', job = 'h5_q*choco_prod'},
  h6_Q            = {unit = 'kW', job = 'h6_q*choco_prod'},
  h7_Q            = {unit = 'kW', job = 'h7_q*choco_prod'},
  h8_Q            = {unit = 'kW', job = 'h8_q*choco_prod'},
  h9_Q            = {unit = 'kW', job = 'h9_q*choco_prod'},
  h10_Q           = {unit = 'kW', job = 'h10_q*choco_prod'},
  h11_Q           = {unit = 'kW', job = 'h11_q*choco_prod'},

}


--========================
-- Layers --
--========================
  et:addLayers { Cocoa_beans    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Sugar          = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Milk_powder    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Lecithin       = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Cocoa_butter   = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Chocolate      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Cocoa_shells   = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Roaster_vapour = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Press_cake     = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Elec           = {type = 'ResourceBalance', unit = 'kW'} }


--==============================================================================================
-- Units --
--==============================================================================================

  et:addUnit('Chocolate_PR1', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['Chocolate_PR1']:addStreams {

    -- Cold streams (heat demand)
    qt_c1_roast_air1     = qt({tin = 'c1_Tin', hin = 0, tout = 'c1_Tout', hout = 'c1_Q', dtmin = 'dtmin'}),
    qt_c2_roast_air2     = qt({tin = 'c2_Tin', hin = 0, tout = 'c2_Tout', hout = 'c2_Q', dtmin = 'dtmin'}),
    qt_c3_roast_air3     = qt({tin = 'c3_Tin', hin = 0, tout = 'c3_Tout', hout = 'c3_Q', dtmin = 'dtmin'}),
    qt_c4_drying         = qt({tin = 'c4_Tin', hin = 0, tout = 'c4_Tout', hout = 'c4_Q', dtmin = 'dtmin'}),
    qt_c5_debact         = qt({tin = 'c5_Tin', hin = 0, tout = 'c5_Tout', hout = 'c5_Q', dtmin = 'dtmin'}),
    qt_c6_cip_caustic    = qt({tin = 'c6_Tin', hin = 0, tout = 'c6_Tout', hout = 'c6_Q', dtmin = 'dtmin'}),
    qt_c7_cip_acid       = qt({tin = 'c7_Tin', hin = 0, tout = 'c7_Tout', hout = 'c7_Q', dtmin = 'dtmin'}),
    qt_c8_cip_rinse      = qt({tin = 'c8_Tin', hin = 0, tout = 'c8_Tout', hout = 'c8_Q', dtmin = 'dtmin'}),
    qt_c9_tracing        = qt({tin = 'c9_Tin', hin = 0, tout = 'c9_Tout', hout = 'c9_Q', dtmin = 'dtmin'}),
    qt_c10_press1_feed   = qt({tin = 'c10_Tin', hin = 0, tout = 'c10_Tout', hout = 'c10_Q', dtmin = 'dtmin'}),
    qt_c11_press2_feed   = qt({tin = 'c11_Tin', hin = 0, tout = 'c11_Tout', hout = 'c11_Q', dtmin = 'dtmin'}),
    qt_c12_conche_A_heat = qt({tin = 'c12_Tin', hin = 0, tout = 'c12_Tout', hout = 'c12_Q', dtmin = 'dtmin'}),
    qt_c13_conche_B_heat = qt({tin = 'c13_Tin', hin = 0, tout = 'c13_Tout', hout = 'c13_Q', dtmin = 'dtmin'}),
    qt_c14_conche_C_heat = qt({tin = 'c14_Tin', hin = 0, tout = 'c14_Tout', hout = 'c14_Q', dtmin = 'dtmin'}),
    qt_c15_conche_D_heat = qt({tin = 'c15_Tin', hin = 0, tout = 'c15_Tout', hout = 'c15_Q', dtmin = 'dtmin'}),
    qt_c16_temper1       = qt({tin = 'c16_Tin', hin = 0, tout = 'c16_Tout', hout = 'c16_Q', dtmin = 'dtmin'}),
    qt_c17_temper2       = qt({tin = 'c17_Tin', hin = 0, tout = 'c17_Tout', hout = 'c17_Q', dtmin = 'dtmin'}),
    qt_c18_temper3       = qt({tin = 'c18_Tin', hin = 0, tout = 'c18_Tout', hout = 'c18_Q', dtmin = 'dtmin'}),
    qt_c19_temper4       = qt({tin = 'c19_Tin', hin = 0, tout = 'c19_Tout', hout = 'c19_Q', dtmin = 'dtmin'}),
    qt_c20_temper5       = qt({tin = 'c20_Tin', hin = 0, tout = 'c20_Tout', hout = 'c20_Q', dtmin = 'dtmin'}),
    qt_c21_temper6       = qt({tin = 'c21_Tin', hin = 0, tout = 'c21_Tout', hout = 'c21_Q', dtmin = 'dtmin'}),
    qt_c22_temper7       = qt({tin = 'c22_Tin', hin = 0, tout = 'c22_Tout', hout = 'c22_Q', dtmin = 'dtmin'}),
    qt_c23_temper8       = qt({tin = 'c23_Tin', hin = 0, tout = 'c23_Tout', hout = 'c23_Q', dtmin = 'dtmin'}),
    qt_c24_temper9       = qt({tin = 'c24_Tin', hin = 0, tout = 'c24_Tout', hout = 'c24_Q', dtmin = 'dtmin'}),
    qt_c25_mould_A1      = qt({tin = 'c25_Tin', hin = 0, tout = 'c25_Tout', hout = 'c25_Q', dtmin = 'dtmin'}),
    qt_c26_mould_A2      = qt({tin = 'c26_Tin', hin = 0, tout = 'c26_Tout', hout = 'c26_Q', dtmin = 'dtmin'}),
    qt_c27_mould_A3      = qt({tin = 'c27_Tin', hin = 0, tout = 'c27_Tout', hout = 'c27_Q', dtmin = 'dtmin'}),
    qt_c28_mould_A4      = qt({tin = 'c28_Tin', hin = 0, tout = 'c28_Tout', hout = 'c28_Q', dtmin = 'dtmin'}),
    qt_c29_mould_A5      = qt({tin = 'c29_Tin', hin = 0, tout = 'c29_Tout', hout = 'c29_Q', dtmin = 'dtmin'}),
    qt_c30_mould_A6      = qt({tin = 'c30_Tin', hin = 0, tout = 'c30_Tout', hout = 'c30_Q', dtmin = 'dtmin'}),
    qt_c31_mould_B1      = qt({tin = 'c31_Tin', hin = 0, tout = 'c31_Tout', hout = 'c31_Q', dtmin = 'dtmin'}),
    qt_c32_mould_B2      = qt({tin = 'c32_Tin', hin = 0, tout = 'c32_Tout', hout = 'c32_Q', dtmin = 'dtmin'}),
    qt_c33_mould_B3      = qt({tin = 'c33_Tin', hin = 0, tout = 'c33_Tout', hout = 'c33_Q', dtmin = 'dtmin'}),
    qt_c34_mould_B4      = qt({tin = 'c34_Tin', hin = 0, tout = 'c34_Tout', hout = 'c34_Q', dtmin = 'dtmin'}),

    -- Hot streams (heat available)
    qt_h1_roast_exh1     = qt({tin = 'h1_Tin', hin = 'h1_Q', tout = 'h1_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h2_roast_exh2     = qt({tin = 'h2_Tin', hin = 'h2_Q', tout = 'h2_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h3_roast_exh3     = qt({tin = 'h3_Tin', hin = 'h3_Q', tout = 'h3_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h4_press1_cake    = qt({tin = 'h4_Tin', hin = 'h4_Q', tout = 'h4_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h5_press2_cake    = qt({tin = 'h5_Tin', hin = 'h5_Q', tout = 'h5_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h6_aircomp        = qt({tin = 'h6_Tin', hin = 'h6_Q', tout = 'h6_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h7_conche_A_cool  = qt({tin = 'h7_Tin', hin = 'h7_Q', tout = 'h7_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h8_conche_B_cool  = qt({tin = 'h8_Tin', hin = 'h8_Q', tout = 'h8_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h9_conche_C_cool  = qt({tin = 'h9_Tin', hin = 'h9_Q', tout = 'h9_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h10_conche_D_cool = qt({tin = 'h10_Tin', hin = 'h10_Q', tout = 'h10_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h11_prod_cooling  = qt({tin = 'h11_Tin', hin = 'h11_Q', tout = 'h11_Tout', hout = 0, dtmin = 'dtmin'}),

    -- Resource streams
    Cocoa_beans_in       = rs({'Cocoa_beans', 'in', 'beans_in'}),
    Sugar_in             = rs({'Sugar', 'in', 'sugar_in'}),
    Milk_powder_in       = rs({'Milk_powder', 'in', 'milkpowder_in'}),
    Lecithin_in          = rs({'Lecithin', 'in', 'lecithin_in'}),
    Cocoa_butter_in      = rs({'Cocoa_butter', 'in', 'butter_in'}),
    Chocolate_out        = rs({'Chocolate', 'out', 'chocolate_out'}),
    Cocoa_shells_out     = rs({'Cocoa_shells', 'out', 'shells_out'}),
    Roaster_vapour_out   = rs({'Roaster_vapour', 'out', 'vapour_out'}),
    Press_cake_out       = rs({'Press_cake', 'out', 'presscake_out'}),
    Elec_in              = rs({'Elec', 'in', 'E_total'}),

  }


return et
