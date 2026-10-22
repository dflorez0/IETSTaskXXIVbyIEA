local osmose = require 'osmose'
local et     = osmose.Model 'Coffee_SD_ET'

et.header = {
  name        = 'Coffee_SD_ET',
  displayName = 'Instant coffee (spray-dried)',
  authors     = {'EPFL IPESE research group'},
  versions    = {'1.0'},
  title       = 'Instant coffee, spray-dried route',
  description = [[Spray-dried instant coffee from green coffee beans: roasting with gas recirculation and a catalytic afterburner,
  quench, cooling and grinding, extraction with water at 180 C, cooling and clarification of the extract, single-effect
  vacuum evaporation and spray drying with a fluid bed. Flows and heat loads are given per 1 t/h of instant coffee and
  scale with coffee_prod. Utilities (burners, steam, refrigeration, cooling water, air dehumidification) are not part of the process data.]],
  references  = {'Mitraki et al. (2026), Energy Demand 1(2), 1-18, https://doi.org/10.66506/ed.52', 'Process data: Instant_Coffee_SD_moodle.md'},
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  -- Production rate: 1 t/h is the reference; the reference plant (5,000 t/y over 8,000 h/y) is 0.625 t/h
  coffee_prod = {default = 1, unit = 't/h'},

  -- Global dTmin = 10 K, applied as dTmin/2 = 5 K on every stream
  dtmin = {default = 5, unit = 'C'},

---------------------
-- Material flows per t of instant coffee (closure: 10,151.3 kg in and out)
---------------------
  beans_in_r              = {default = 2430, unit = 'kg/t'}, -- Green coffee beans
  quench_water_in_r       = {default = 269.9, unit = 'kg/t'}, -- Quench water
  extraction_water_in_r   = {default = 7451.4, unit = 'kg/t'}, -- Extraction water
  coffee_out_r            = {default = 1000, unit = 'kg/t'}, -- Instant coffee
  silverskin_out_r        = {default = 18.2, unit = 'kg/t'}, -- Silverskin
  offgas_out_r            = {default = 620.2, unit = 'kg/t'}, -- Roaster off-gas
  flash_steam_out_r       = {default = 644, unit = 'kg/t'}, -- Flash steam
  grounds_out_r           = {default = 4357.2, unit = 'kg/t'}, -- Spent grounds
  condensate_out_r        = {default = 2307.1, unit = 'kg/t'}, -- Evaporator condensate
  dryer_vapour_out_r      = {default = 1204.5, unit = 'kg/t'}, -- Water vapour in the dryer exhaust

  -- Internal flows and utility media (information only, not resource streams)
  roasted_beans_r         = {default = 2061.5, unit = 'kg/t'}, -- Roasted beans
  extract_r               = {default = 4511.6, unit = 'kg/t'}, -- Extract
  concentrate_r           = {default = 2204.5, unit = 'kg/t'}, -- Concentrate
  dryer_air_r             = {default = 41296, unit = 'kg/t'}, -- Spray-dryer main air
  fluidbed_air_r          = {default = 6768, unit = 'kg/t'}, -- Fluid-bed air
  exhaust_air_r           = {default = 50215, unit = 'kg/t'}, -- Dryer exhaust air

---------------------
-- Process electricity per t of instant coffee (heat and refrigeration are qt streams, not electricity)
---------------------
  E_motors_r              = {default = 722, unit = 'kWh/t'}, -- Electric motors
  E_lighting_r            = {default = 34, unit = 'kWh/t'}, -- Lighting
  E_grinding_r            = {default = 33, unit = 'kWh/t'}, -- Grinding

---------------------
-- Thermal streams: Tin, Tout and specific heat load per t of instant coffee
-- Sources: Schwartzberg (2013), Okada et al. (1980), Tinoco-Caicedo et al. (2020), Bassoli (2019); see Instant_Coffee_SD_moodle.md
---------------------

  -- Cold streams (to be heated)
  c1_Tin   = {default = 200, unit = 'C'}, c1_Tout   = {default = 455, unit = 'C'}, c1_q   = {default = 797.18, unit = 'kWh/t'}, -- Roaster furnace, recirculated gas
  c2_Tin   = {default = 200, unit = 'C'}, c2_Tout   = {default = 400, unit = 'C'}, c2_q   = {default = 296.99, unit = 'kWh/t'}, -- Catalytic afterburner, feed gas
  c3_Tin   = {default = 20, unit = 'C'}, c3_Tout   = {default = 180, unit = 'C'}, c3_q   = {default = 1390.93, unit = 'kWh/t'}, -- Extraction water
  c4_Tin   = {default = 12, unit = 'C'}, c4_Tout   = {default = 55, unit = 'C'}, c4_q   = {default = 193.05, unit = 'kWh/t'}, -- Clarified extract, preheating
  c5_Tin   = {default = 55, unit = 'C'}, c5_Tout   = {default = 56, unit = 'C'}, c5_q   = {default = 1518.83, unit = 'kWh/t'}, -- Evaporator, boiling extract
  c6_Tin   = {default = 12, unit = 'C'}, c6_Tout   = {default = 39, unit = 'C'}, c6_q   = {default = 48.89, unit = 'kWh/t'}, -- Concentrate preheating before atomisation
  c7_Tin   = {default = 20, unit = 'C'}, c7_Tout   = {default = 178, unit = 'C'}, c7_q   = {default = 1830.56, unit = 'kWh/t'}, -- Spray-dryer main air
  c8_Tin   = {default = 15, unit = 'C'}, c8_Tout   = {default = 96, unit = 'C'}, c8_q   = {default = 153.79, unit = 'kWh/t'}, -- Fluid-bed air (dehumidified)

  -- Hot streams (to be cooled)
  h1_Tin   = {default = 400, unit = 'C'}, h1_Tout   = {default = 120, unit = 'C'}, h1_q   = {default = 415.79, unit = 'kWh/t'}, -- Stack gas after catalytic afterburner
  h2_Tin   = {default = 120, unit = 'C'}, h2_Tout   = {default = 30, unit = 'C'}, h2_q   = {default = 86.33, unit = 'kWh/t'}, -- Roasted-bean cooling with air
  h3_Tin   = {default = 110, unit = 'C'}, h3_Tout   = {default = 12, unit = 'C'}, h3_q   = {default = 439.97, unit = 'kWh/t'}, -- Extract cooling before clarification
  h4_Tin   = {default = 100, unit = 'C'}, h4_Tout   = {default = 99, unit = 'C'}, h4_q   = {default = 403.77, unit = 'kWh/t'}, -- Flash steam from spent-grounds discharge
  h5_Tin   = {default = 100, unit = 'C'}, h5_Tout   = {default = 40, unit = 'C'}, h5_q   = {default = 257.74, unit = 'kWh/t'}, -- Spent grounds after flash
  h6_Tin   = {default = 50, unit = 'C'}, h6_Tout   = {default = 49, unit = 'C'}, h6_q   = {default = 1526.52, unit = 'kWh/t'}, -- Evaporator vapour, condensing
  h7_Tin   = {default = 55, unit = 'C'}, h7_Tout   = {default = 12, unit = 'C'}, h7_q   = {default = 77.86, unit = 'kWh/t'}, -- Concentrate cooling to storage
  h8_Tin   = {default = 96, unit = 'C'}, h8_Tout   = {default = 40, unit = 'C'}, h8_q   = {default = 820.18, unit = 'kWh/t'}, -- Spray-dryer exhaust air

}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  beans_in                = {unit = 'kg/h', job = 'beans_in_r*coffee_prod'},
  quench_water_in         = {unit = 'kg/h', job = 'quench_water_in_r*coffee_prod'},
  extraction_water_in     = {unit = 'kg/h', job = 'extraction_water_in_r*coffee_prod'},
  coffee_out              = {unit = 'kg/h', job = 'coffee_out_r*coffee_prod'},
  silverskin_out          = {unit = 'kg/h', job = 'silverskin_out_r*coffee_prod'},
  offgas_out              = {unit = 'kg/h', job = 'offgas_out_r*coffee_prod'},
  flash_steam_out         = {unit = 'kg/h', job = 'flash_steam_out_r*coffee_prod'},
  grounds_out             = {unit = 'kg/h', job = 'grounds_out_r*coffee_prod'},
  condensate_out          = {unit = 'kg/h', job = 'condensate_out_r*coffee_prod'},
  dryer_vapour_out        = {unit = 'kg/h', job = 'dryer_vapour_out_r*coffee_prod'},

  E_motors                = {unit = 'kW', job = 'E_motors_r*coffee_prod'},
  E_lighting              = {unit = 'kW', job = 'E_lighting_r*coffee_prod'},
  E_total                 = {unit = 'kW', job = 'E_motors()+E_lighting()'},

  c1_Q                    = {unit = 'kW', job = 'c1_q*coffee_prod'},
  c2_Q                    = {unit = 'kW', job = 'c2_q*coffee_prod'},
  c3_Q                    = {unit = 'kW', job = 'c3_q*coffee_prod'},
  c4_Q                    = {unit = 'kW', job = 'c4_q*coffee_prod'},
  c5_Q                    = {unit = 'kW', job = 'c5_q*coffee_prod'},
  c6_Q                    = {unit = 'kW', job = 'c6_q*coffee_prod'},
  c7_Q                    = {unit = 'kW', job = 'c7_q*coffee_prod'},
  c8_Q                    = {unit = 'kW', job = 'c8_q*coffee_prod'},
  h1_Q                    = {unit = 'kW', job = 'h1_q*coffee_prod'},
  h2_Q                    = {unit = 'kW', job = 'h2_q*coffee_prod'},
  h3_Q                    = {unit = 'kW', job = 'h3_q*coffee_prod'},
  h4_Q                    = {unit = 'kW', job = 'h4_q*coffee_prod'},
  h5_Q                    = {unit = 'kW', job = 'h5_q*coffee_prod'},
  h6_Q                    = {unit = 'kW', job = 'h6_q*coffee_prod'},
  h7_Q                    = {unit = 'kW', job = 'h7_q*coffee_prod'},
  h8_Q                    = {unit = 'kW', job = 'h8_q*coffee_prod'},

}


--========================
-- Layers --
--========================
  et:addLayers { Green_coffee      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Quench_water      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Extraction_water  = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Instant_coffee    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Silverskin        = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Roaster_offgas    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Flash_steam       = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Spent_grounds     = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Evap_condensate   = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Dryer_vapour      = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Elec              = {type = 'ResourceBalance', unit = 'kW'} }


--==============================================================================================
-- Units --
--==============================================================================================

  et:addUnit('Coffee_SD', {type = 'Process', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['Coffee_SD']:addStreams {

    -- Cold streams (heat demand)
    qt_c1_roaster_gas      = qt({tin = 'c1_Tin', hin = 0, tout = 'c1_Tout', hout = 'c1_Q', dtmin = 'dtmin'}),
    qt_c2_afterburner      = qt({tin = 'c2_Tin', hin = 0, tout = 'c2_Tout', hout = 'c2_Q', dtmin = 'dtmin'}),
    qt_c3_extraction_water = qt({tin = 'c3_Tin', hin = 0, tout = 'c3_Tout', hout = 'c3_Q', dtmin = 'dtmin'}),
    qt_c4_extract_preheat  = qt({tin = 'c4_Tin', hin = 0, tout = 'c4_Tout', hout = 'c4_Q', dtmin = 'dtmin'}),
    qt_c5_evaporator       = qt({tin = 'c5_Tin', hin = 0, tout = 'c5_Tout', hout = 'c5_Q', dtmin = 'dtmin'}),
    qt_c6_conc_preheat     = qt({tin = 'c6_Tin', hin = 0, tout = 'c6_Tout', hout = 'c6_Q', dtmin = 'dtmin'}),
    qt_c7_dryer_air        = qt({tin = 'c7_Tin', hin = 0, tout = 'c7_Tout', hout = 'c7_Q', dtmin = 'dtmin'}),
    qt_c8_fluidbed_air     = qt({tin = 'c8_Tin', hin = 0, tout = 'c8_Tout', hout = 'c8_Q', dtmin = 'dtmin'}),

    -- Hot streams (heat available)
    qt_h1_stack_gas        = qt({tin = 'h1_Tin', hin = 'h1_Q', tout = 'h1_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h2_bean_cooling     = qt({tin = 'h2_Tin', hin = 'h2_Q', tout = 'h2_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h3_extract_cooling  = qt({tin = 'h3_Tin', hin = 'h3_Q', tout = 'h3_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h4_flash_steam      = qt({tin = 'h4_Tin', hin = 'h4_Q', tout = 'h4_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h5_spent_grounds    = qt({tin = 'h5_Tin', hin = 'h5_Q', tout = 'h5_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h6_evap_vapour      = qt({tin = 'h6_Tin', hin = 'h6_Q', tout = 'h6_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h7_conc_cooling     = qt({tin = 'h7_Tin', hin = 'h7_Q', tout = 'h7_Tout', hout = 0, dtmin = 'dtmin'}),
    qt_h8_dryer_exhaust    = qt({tin = 'h8_Tin', hin = 'h8_Q', tout = 'h8_Tout', hout = 0, dtmin = 'dtmin'}),

    -- Resource streams
    Green_coffee_in        = rs({'Green_coffee', 'in', 'beans_in'}),
    Quench_water_in        = rs({'Quench_water', 'in', 'quench_water_in'}),
    Extraction_water_in    = rs({'Extraction_water', 'in', 'extraction_water_in'}),
    Instant_coffee_out     = rs({'Instant_coffee', 'out', 'coffee_out'}),
    Silverskin_out         = rs({'Silverskin', 'out', 'silverskin_out'}),
    Roaster_offgas_out     = rs({'Roaster_offgas', 'out', 'offgas_out'}),
    Flash_steam_out        = rs({'Flash_steam', 'out', 'flash_steam_out'}),
    Spent_grounds_out      = rs({'Spent_grounds', 'out', 'grounds_out'}),
    Evap_condensate_out    = rs({'Evap_condensate', 'out', 'condensate_out'}),
    Dryer_vapour_out       = rs({'Dryer_vapour', 'out', 'dryer_vapour_out'}),
    Elec_in                = rs({'Elec', 'in', 'E_total'}),

  }


return et
