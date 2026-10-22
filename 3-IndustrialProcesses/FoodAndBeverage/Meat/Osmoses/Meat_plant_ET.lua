local osmose = require 'osmose'
local et     = osmose.Model 'Meat_plant_ET'

et.header = {
  name        = 'Meat_plant_ET',
  displayName = 'Integrated pork plant',
  authors     = {'EPFL IPESE research group'},
  versions    = {'1.0'},
  title       = 'Integrated pork plant: slaughtering, cutting and cooked sausages',
  description = [[Integrated pork plant: stunning and bleeding, scalding and dehairing, singeing and dressing, carcass chilling,
  cutting and deboning, and a cooked-sausage line, with chilled and frozen storage and the hot, warm and tap water networks.
  Flows and heat loads are given per 1 t/h of hot carcass and scale with carcass_prod. Utilities (steam, hot-water generation,
  refrigeration, cooling) are not part of the process data.]],
  references  = {'Fritzson and Berntsson (2006), J. Food Eng. 76, 594-604, https://doi.org/10.1016/j.jfoodeng.2005.06.007', 'Process data: Meat_plant.md'},
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  -- Throughput: 1 t/h of hot carcass is the reference; the reference plant (700,000 pigs/y over 6,300 h/y) is 10.06 t/h
  carcass_prod = {default = 1, unit = 't/h'},

  -- Global dTmin = 10 K, applied as dTmin/2 = 5 K on every stream
  dtmin = {default = 5, unit = 'C'},

---------------------
-- Material flows per t of hot carcass (closure: 1,332.1 kg in and out)
---------------------
  pigs_in_r        = {default = 1282.1, unit = 'kg/t'}, -- Live pigs
  ice_in_r         = {default = 50, unit = 'kg/t'}, -- Ice and water for the batter
  cuts_out_r       = {default = 529.9, unit = 'kg/t'}, -- Fresh cuts
  sausages_out_r   = {default = 235, unit = 'kg/t'}, -- Cooked sausages
  blood_out_r      = {default = 38.5, unit = 'kg/t'}, -- Blood
  offal_out_r      = {default = 243.6, unit = 'kg/t'}, -- Offal, intestines and bristles
  bones_out_r      = {default = 270.1, unit = 'kg/t'}, -- Bones, fat and rind
  vapour_out_r     = {default = 15, unit = 'kg/t'}, -- Vapour from cooking

  -- Internal flows and utility media (information only, not resource streams)
  carcass_r        = {default = 1000, unit = 'kg/t'}, -- Hot carcass to chilling
  boneless_meat_r  = {default = 729.9, unit = 'kg/t'}, -- Boneless meat
  trimmings_r      = {default = 200, unit = 'kg/t'}, -- Trimmings to the sausage line
  batter_r         = {default = 250, unit = 'kg/t'}, -- Sausage batter
  hot_water_r      = {default = 497, unit = 'kg/t'}, -- Hot water at 82 °C
  warm_water_r     = {default = 2187, unit = 'kg/t'}, -- Warm water at 55 °C
  tap_water_r      = {default = 696, unit = 'kg/t'}, -- Tap water at 40 °C

---------------------
-- Process electricity per t of hot carcass (heat and refrigeration are qt streams, not electricity)
---------------------
  E_slaughter_r    = {default = 49, unit = 'kWh/t'}, -- Slaughter line
  E_cutting_r      = {default = 44, unit = 'kWh/t'}, -- Cutting and deboning
  E_sausage_r      = {default = 99, unit = 'kWh/t'}, -- Sausage line
  E_aircomp_r      = {default = 18, unit = 'kWh/t'}, -- Air compressors

---------------------
-- Thermal streams: Tin, Tout and specific heat load per t of hot carcass
-- Sources: Karlis et al. (2024), Fritzson and Berntsson (2006a), Meier (2007), COWI (2000); see Meat_plant.md
---------------------

  -- Cold streams (to be heated)
  c1_Tin   = {default = 900, unit = 'C'}, c1_Tout   = {default = 1000, unit = 'C'}, c1_q   = {default = 28, unit = 'kWh/t'}, -- Singeing oven, direct-fired
  c2_Tin   = {default = 60, unit = 'C'}, c2_Tout   = {default = 61, unit = 'C'}, c2_q   = {default = 40, unit = 'kWh/t'}, -- Scalding tank, held at 60 °C
  c3_Tin   = {default = 11, unit = 'C'}, c3_Tout   = {default = 82, unit = 'C'}, c3_q   = {default = 40.98, unit = 'kWh/t'}, -- Hot water 82 °C (sterilisers, disinfection)
  c4_Tin   = {default = 11, unit = 'C'}, c4_Tout   = {default = 55, unit = 'C'}, c4_q   = {default = 111.73, unit = 'kWh/t'}, -- Warm water 55 °C (cleaning)
  c5_Tin   = {default = 11, unit = 'C'}, c5_Tout   = {default = 40, unit = 'C'}, c5_q   = {default = 23.43, unit = 'kWh/t'}, -- Tap water 40 °C (hand washing, personnel)
  c6_Tin   = {default = 112, unit = 'C'}, c6_Tout   = {default = 113, unit = 'C'}, c6_q   = {default = 63.86, unit = 'kWh/t'}, -- Sausage cooking, direct steam injection

  -- Hot streams (to be cooled)
  h1_Tin   = {default = 70, unit = 'C'}, h1_Tout   = {default = 35, unit = 'C'}, h1_q   = {default = 20.21, unit = 'kWh/t'}, -- Cooking-oven exhaust air
  h2_Tin   = {default = 74, unit = 'C'}, h2_Tout   = {default = 45, unit = 'C'}, h2_q   = {default = 5.68, unit = 'kWh/t'}, -- Sausage shower cooling
  h3_Tin   = {default = 70, unit = 'C'}, h3_Tout   = {default = 25, unit = 'C'}, h3_q   = {default = 17.89, unit = 'kWh/t'}, -- Air compressors, heat recovery
  h4_Tin   = {default = 38, unit = 'C'}, h4_Tout   = {default = 5, unit = 'C'}, h4_q   = {default = 1.27, unit = 'kWh/t'}, -- Blood chilling
  h5_Tin   = {default = 38, unit = 'C'}, h5_Tout   = {default = 4, unit = 'C'}, h5_q   = {default = 42.5, unit = 'kWh/t'}, -- Carcass chilling
  h6_Tin   = {default = 45, unit = 'C'}, h6_Tout   = {default = 2, unit = 'C'}, h6_q   = {default = 8.42, unit = 'kWh/t'}, -- Sausage chilling
  h7_Tin   = {default = 3, unit = 'C'}, h7_Tout   = {default = 2, unit = 'C'}, h7_q   = {default = 150.23, unit = 'kWh/t'}, -- Chilled rooms (cutting, storage), air at 2 °C
  h8_Tin   = {default = -24, unit = 'C'}, h8_Tout   = {default = -25, unit = 'C'}, h8_q   = {default = 6, unit = 'kWh/t'}, -- Freezer rooms, air at -25 °C

}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  pigs_in          = {unit = 'kg/h', job = 'pigs_in_r*carcass_prod'},
  ice_in           = {unit = 'kg/h', job = 'ice_in_r*carcass_prod'},
  cuts_out         = {unit = 'kg/h', job = 'cuts_out_r*carcass_prod'},
  sausages_out     = {unit = 'kg/h', job = 'sausages_out_r*carcass_prod'},
  blood_out        = {unit = 'kg/h', job = 'blood_out_r*carcass_prod'},
  offal_out        = {unit = 'kg/h', job = 'offal_out_r*carcass_prod'},
  bones_out        = {unit = 'kg/h', job = 'bones_out_r*carcass_prod'},
  vapour_out       = {unit = 'kg/h', job = 'vapour_out_r*carcass_prod'},

  E_slaughter      = {unit = 'kW', job = 'E_slaughter_r*carcass_prod'},
  E_cutting        = {unit = 'kW', job = 'E_cutting_r*carcass_prod'},
  E_sausage        = {unit = 'kW', job = 'E_sausage_r*carcass_prod'},
  E_total          = {unit = 'kW', job = 'E_slaughter()+E_cutting()+E_sausage()'},

  c1_Q             = {unit = 'kW', job = 'c1_q*carcass_prod'},
  c2_Q             = {unit = 'kW', job = 'c2_q*carcass_prod'},
  c3_Q             = {unit = 'kW', job = 'c3_q*carcass_prod'},
  c4_Q             = {unit = 'kW', job = 'c4_q*carcass_prod'},
  c5_Q             = {unit = 'kW', job = 'c5_q*carcass_prod'},
  c6_Q             = {unit = 'kW', job = 'c6_q*carcass_prod'},
  h1_Q             = {unit = 'kW', job = 'h1_q*carcass_prod'},
  h2_Q             = {unit = 'kW', job = 'h2_q*carcass_prod'},
  h3_Q             = {unit = 'kW', job = 'h3_q*carcass_prod'},
  h4_Q             = {unit = 'kW', job = 'h4_q*carcass_prod'},
  h5_Q             = {unit = 'kW', job = 'h5_q*carcass_prod'},
  h6_Q             = {unit = 'kW', job = 'h6_q*carcass_prod'},
  h7_Q             = {unit = 'kW', job = 'h7_q*carcass_prod'},
  h8_Q             = {unit = 'kW', job = 'h8_q*carcass_prod'},

}


--========================
-- Layers --
--========================
  et:addLayers { Live_pigs       = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Ice_water       = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Fresh_cuts      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Sausages        = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Blood           = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Offal           = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Bones_fat       = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Cooking_vapour  = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Elec            = {type = 'ResourceBalance', unit = 'kW'} }


--==============================================================================================
-- Units --
--==============================================================================================

  et:addUnit('Meat_plant', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['Meat_plant']:addStreams {

    -- Cold streams (heat demand)
    qt_c1_singeing         = qt({tin = 'c1_Tin', hin = 0, tout = 'c1_Tout', hout = 'c1_Q', dtmin = 'dtmin'}),
    qt_c2_scalding         = qt({tin = 'c2_Tin', hin = 0, tout = 'c2_Tout', hout = 'c2_Q', dtmin = 'dtmin'}),
    qt_c3_hot_water        = qt({tin = 'c3_Tin', hin = 0, tout = 'c3_Tout', hout = 'c3_Q', dtmin = 'dtmin'}),
    qt_c4_warm_water       = qt({tin = 'c4_Tin', hin = 0, tout = 'c4_Tout', hout = 'c4_Q', dtmin = 'dtmin'}),
    qt_c5_tap_water        = qt({tin = 'c5_Tin', hin = 0, tout = 'c5_Tout', hout = 'c5_Q', dtmin = 'dtmin'}),
    qt_c6_cooking          = qt({tin = 'c6_Tin', hin = 0, tout = 'c6_Tout', hout = 'c6_Q', dtmin = 'dtmin'}),

    -- Hot streams (heat available)
    qt_h1_oven_exhaust     = qt({tin = 'h1_Tin', hin = 'h1_Q', tout = 'h1_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h2_sausage_shower   = qt({tin = 'h2_Tin', hin = 'h2_Q', tout = 'h2_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h3_aircomp          = qt({tin = 'h3_Tin', hin = 'h3_Q', tout = 'h3_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h4_blood_chilling   = qt({tin = 'h4_Tin', hin = 'h4_Q', tout = 'h4_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h5_carcass_chilling = qt({tin = 'h5_Tin', hin = 'h5_Q', tout = 'h5_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h6_sausage_chilling = qt({tin = 'h6_Tin', hin = 'h6_Q', tout = 'h6_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h7_chilled_rooms    = qt({tin = 'h7_Tin', hin = 'h7_Q', tout = 'h7_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h8_freezer_rooms    = qt({tin = 'h8_Tin', hin = 'h8_Q', tout = 'h8_Tout', hout = 0, dtmin = 'dtmin'}),

    -- Resource streams
    Live_pigs_in           = rs({'Live_pigs', 'in', 'pigs_in'}),
    Ice_water_in           = rs({'Ice_water', 'in', 'ice_in'}),
    Fresh_cuts_out         = rs({'Fresh_cuts', 'out', 'cuts_out'}),
    Sausages_out           = rs({'Sausages', 'out', 'sausages_out'}),
    Blood_out              = rs({'Blood', 'out', 'blood_out'}),
    Offal_out              = rs({'Offal', 'out', 'offal_out'}),
    Bones_fat_out          = rs({'Bones_fat', 'out', 'bones_out'}),
    Cooking_vapour_out     = rs({'Cooking_vapour', 'out', 'vapour_out'}),
    Elec_in                = rs({'Elec', 'in', 'E_total'}),

  }


return et
