local osmose  = require 'osmose'
local et      = osmose.Model 'MeOHprodCOSOEC2to1FlareIsothermalv4_ET'

et.header = {
  name = '',
  displayName = '',
  authors = {'Daniel Florez Orrego, Meire Domingos EPFL IPESE research group'},
  developers = {'Daniel Florez-Orrego, Meire Domingos'},
  contributors = {''},
  creation_date = '',
  updates = {''},
  versions = {'1.0'},
  confidentiality = {''},
  title = 'MeOHprodCOSOEC2to1FlareIsothermalv4 - MeOHprodCOSOEC21',
  description = [[Methanol synthesis from the 2:1 (H/C) co-electrolysis syngas produced by
  COSOECOiken7300Am2scrat21MEOH_ET. Isothermal synthesis reactor, purge combustion in an oxy-fired flare
  with isothermal radiative section, and a distillation column separating methanol from heavies and water.
  One unit converts 5726.79 kg/h of syngas into 4302.79 kg/h of methanol, i.e. roughly 997 COSOEC units
  feed one methanol unit.]],
  references = {''},
  adaptedwith = {},
  notes = {}
}

--==============================================================================================
-- User parameters --
--==============================================================================================
et.inputs = {

  dtmin_gas = {default = 8, unit = 'C'},
  dtmin_liq = {default = 5, unit = 'C'},
  dtmin_2ph = {default = 2, unit = 'C'},

---------------------
-- Heat streams
-- Source: MeOHprodCOSOEC2to1FlareIsothermalv4.xlsx, tab MeOHprodCOSOEC21
-- Positive Q = cold stream (heat demand); negative Q = hot stream (heat available)
-- Duties are absolute (kW) for the 5726.79 kg/h syngas feed; they are not per-unit-mass values
---------------------

  -- Syngas feed preheating and reactor feed/effluent exchange
  hxmeoh1_Tin  = {default = 72,      unit = 'C'},
  hxmeoh1_Tout = {default = 175,     unit = 'C'},
  hxmeoh1_Q    = {default = 831.606, unit = 'kW'},

  hxmeoh2_Tin  = {default = 210,      unit = 'C'},
  hxmeoh2_Tout = {default = 154,      unit = 'C'},
  hxmeoh2_Q    = {default = -831.606, unit = 'kW'},

  meohrxpreh_Tin  = {default = 175,     unit = 'C'},
  meohrxpreh_Tout = {default = 210,     unit = 'C'},
  meohrxpreh_Q    = {default = 284.524, unit = 'kW'},

  -- Isothermal methanol synthesis reactor (exothermic; heat available at 210 C)
  meohreactor_Tin  = {default = 210,      unit = 'C'},
  meohreactor_Tout = {default = 210,      unit = 'C'},
  meohreactor_Q    = {default = -3341.06, unit = 'kW'},

  -- Cooling to the flash separators
  cooltoflash1_Tin  = {default = 135,      unit = 'C'},
  cooltoflash1_Tout = {default = 30,       unit = 'C'},
  cooltoflash1_Q    = {default = -2116.04, unit = 'kW'},

  cooltoflash2_Tin  = {default = 30,   unit = 'C'},
  cooltoflash2_Tout = {default = 30,   unit = 'C'},
  cooltoflash2_Q    = {default = 12.9, unit = 'kW'},

  -- Oxy-fired purge flare: isothermal radiative section at 1000 C, then convective cooling
  fluecool1_Tin  = {default = 1000,      unit = 'C'},
  fluecool1_Tout = {default = 1000,      unit = 'C'},
  fluecool1_Q    = {default = -2749.211, unit = 'kW'},

  fluecool2_Tin  = {default = 1000,     unit = 'C'},
  fluecool2_Tout = {default = 150,      unit = 'C'},
  fluecool2_Q    = {default = -663.459, unit = 'kW'},

  fluecool3_Tin  = {default = 150,     unit = 'C'},
  fluecool3_Tout = {default = 94,      unit = 'C'},  -- condensation onset
  fluecool3_Q    = {default = -37.475, unit = 'kW'},

  fluecool4_Tin  = {default = 94,       unit = 'C'},
  fluecool4_Tout = {default = 30,       unit = 'C'},
  fluecool4_Q    = {default = -676.526, unit = 'kW'},

  -- Methanol distillation column
  reboilerheat_Tin  = {default = 100,  unit = 'C'},
  reboilerheat_Tout = {default = 100,  unit = 'C'},
  reboilerheat_Q    = {default = 2900, unit = 'kW'},

  condheat_Tin  = {default = 13,    unit = 'C'},
  condheat_Tout = {default = 13,    unit = 'C'},
  condheat_Q    = {default = -2918, unit = 'kW'},

  -- Product rundown
  meohcool_Tin  = {default = 13,    unit = 'C'},   -- methanol product warmed to ambient
  meohcool_Tout = {default = 25,    unit = 'C'},
  meohcool_Q    = {default = 49.38, unit = 'kW'},

  heavycool_Tin  = {default = 100,    unit = 'C'},  -- heavies bottoms cooled to ambient
  heavycool_Tout = {default = 25,     unit = 'C'},
  heavycool_Q    = {default = -61.73, unit = 'kW'},

---------------------
-- Resource flows (kg/h in the source case unit set; no conversion applied)
---------------------

  massflow_syngas_in  = {default = 5726.79,  unit = 'kg/h'}, -- 2:1 syngas from COSOECOiken7300Am2scrat21MEOH
  massflow_O2_flare   = {default = 832.3812, unit = 'kg/h'}, -- O2 to the purge flare
  massflow_MeOH_out   = {default = 4302.79,  unit = 'kg/h'}, -- methanol product
  massflow_wastewater_out = {default = 651.5136, unit = 'kg/h'}, -- column bottoms: water carrying heavies, needs treatment
  massflow_CO2_out    = {default = 697.9824, unit = 'kg/h'}, -- pure CO2 recovered from the flare gas
  massflow_H2O_out    = {default = 906.606,  unit = 'kg/h'}, -- clean condensate to treatment

---------------------
-- Electricity (kW, from Aspen WNET)
---------------------

  E_comprecycl = {default = 303.836, unit = 'kW'}, -- synthesis loop recycle compressor

  -- PLACEHOLDER: dummy wastewater treatment. The specific work and the 1:1 recovery below are
  -- token values, not a design. Replace both before drawing any conclusion about the cost or
  -- the electricity demand of treating the column bottoms.
  spec_work_WWTP = {default = 0.00001, unit = 'kWh/kg'},
  m3_per_kg_H2O  = {default = 0.001,   unit = 'm3/kg'}, -- water density 1000 kg/m3

---------------------
-- Economics --
-- No capital cost correlation is available for this unit yet; Cinv is left at zero.
---------------------
  i = {default = 0.06, unit = nil},
  n = {default = 25,   unit = nil},

  Mult_MeOHprod = {default = 10, unit = '-'},

}


--==============================================================================================
-- Calculated parameters --
--==============================================================================================
et.outputs = {

  volflow_H2O_out = {job = "massflow_H2O_out / 1000", unit = 'm3/h'},

}


--========================
-- Layers --
-- Syngas: 2:1 co-electrolysis syngas from COSOECOiken7300Am2scrat21MEOH_ET
-- wastewater: column bottoms, water carrying higher alcohols. It cannot go straight to water_out,
--   so it is routed through the placeholder treatment unit below, which discharges it as water_out
--========================
  et:addLayers { water_out  = {type = 'ResourceBalance', unit = 'm3/h'} }
  et:addLayers { Elec       = {type = 'ResourceBalance', unit = 'kW'} }
  et:addLayers { CO2        = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { oxyvent    = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { Syngas     = {type = 'ResourceBalance', unit = 'kg/h'} }  -- NEW
  et:addLayers { MeohProd   = {type = 'ResourceBalance', unit = 'kg/h'} }
  et:addLayers { wastewater = {type = 'ResourceBalance', unit = 'kg/h'} }  -- NEW
  et:addLayers { SteamGen   = {type = 'HeatCascade',     unit = 'kW'} }    -- steam generation circuit (100-110C)


--==============================================================================================
-- Units --
--==============================================================================================

  et:addUnit('MeOHprodCOSOEC21', {type = 'Utility', Fmin = 0, Fmax = "Mult_MeOHprod", Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0})
  et['MeOHprodCOSOEC21']:addStreams {

    -- Cold streams (heat demand)
    hxmeoh1      = qt({tin = 'hxmeoh1_Tin',      hin = 0, tout = 'hxmeoh1_Tout',      hout = 'hxmeoh1_Q',      dtmin = 'dtmin_gas', alpha = 1}),
    meohrxpreh   = qt({tin = 'meohrxpreh_Tin',   hin = 0, tout = 'meohrxpreh_Tout',   hout = 'meohrxpreh_Q',   dtmin = 'dtmin_gas', alpha = 1}),
    cooltoflash2 = qt({tin = 'cooltoflash2_Tin', hin = 0, tout = 'cooltoflash2_Tout', hout = 'cooltoflash2_Q', dtmin = 'dtmin_2ph', alpha = 1}),
    reboilerheat = qt({tin = 'reboilerheat_Tin', hin = 0, tout = 'reboilerheat_Tout', hout = 'reboilerheat_Q', dtmin = 'dtmin_2ph', alpha = 1}),
    meohcool     = qt({tin = 'meohcool_Tin',     hin = 0, tout = 'meohcool_Tout',     hout = 'meohcool_Q',     dtmin = 'dtmin_liq', alpha = 1}),

    -- Hot streams (heat available)
    hxmeoh2      = qt({tin = 'hxmeoh2_Tin',      hin = 0, tout = 'hxmeoh2_Tout',      hout = 'hxmeoh2_Q',      dtmin = 'dtmin_gas', alpha = 1}),
    meohreactor  = qt({tin = 'meohreactor_Tin',  hin = 0, tout = 'meohreactor_Tout',  hout = 'meohreactor_Q',  dtmin = 'dtmin_gas', alpha = 1}),
    cooltoflash1 = qt({tin = 'cooltoflash1_Tin', hin = 0, tout = 'cooltoflash1_Tout', hout = 'cooltoflash1_Q', dtmin = 'dtmin_2ph', alpha = 1}),
    fluecool1    = qt({tin = 'fluecool1_Tin',    hin = 0, tout = 'fluecool1_Tout',    hout = 'fluecool1_Q',    dtmin = 'dtmin_gas', alpha = 1}),
    fluecool2    = qt({tin = 'fluecool2_Tin',    hin = 0, tout = 'fluecool2_Tout',    hout = 'fluecool2_Q',    dtmin = 'dtmin_gas', alpha = 1}),
    fluecool3    = qt({tin = 'fluecool3_Tin',    hin = 0, tout = 'fluecool3_Tout',    hout = 'fluecool3_Q',    dtmin = 'dtmin_gas', alpha = 1}),
    fluecool4    = qt({tin = 'fluecool4_Tin',    hin = 0, tout = 'fluecool4_Tout',    hout = 'fluecool4_Q',    dtmin = 'dtmin_2ph', alpha = 1}),
    condheat     = qt({tin = 'condheat_Tin',     hin = 0, tout = 'condheat_Tout',     hout = 'condheat_Q',     dtmin = 'dtmin_2ph', alpha = 1}),
    heavycool    = qt({tin = 'heavycool_Tin',    hin = 0, tout = 'heavycool_Tout',    hout = 'heavycool_Q',    dtmin = 'dtmin_liq', alpha = 1}),

    -- Resource streams
    Syngas_in       = rs({'Syngas',     'in',  'massflow_syngas_in'}),
    O2_flare_in     = rs({'oxyvent',    'in',  'massflow_O2_flare'}),
    MeOH_out        = rs({'MeohProd',   'out', 'massflow_MeOH_out'}),
    wastewater_out  = rs({'wastewater', 'out', 'massflow_wastewater_out'}),
    CO2_pure_out    = rs({'CO2',        'out', 'massflow_CO2_out'}),
    H2O_cond_out    = rs({'water_out',  'out', 'volflow_H2O_out'}),
    Elecbalance     = rs({'Elec',       'in',  'E_comprecycl'}),

  }


  -- ======================================== --
  -------  Wastewater treatment (PLACEHOLDER)  ------
  -- Takes the column bottoms off the wastewater layer and discharges them as treated water_out,
  -- which WaterToGrid in Resources_ET absorbs. Both the specific work and the 1:1 water recovery
  -- are token values (see spec_work_WWTP above): this unit currently treats water essentially for
  -- free and loses nothing to sludge. Replace both before using the results.
  -- If treated water should instead return as reusable feed, point water_treated_out at water_in.
  -- ======================================== --

  et:addUnit('WWTP_dummy_MeOHprod', {type = 'Utility', Fmin = 0, Fmax = 1000000, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, Impact1 = 0, Impact2 = 0})
  et['WWTP_dummy_MeOHprod']:addStreams({
    wastewater_in     = rs({'wastewater', 'in',  1}),                  -- kg/h of untreated bottoms
    water_treated_out = rs({'water_out',  'out', 'm3_per_kg_H2O'}),    -- m3/h per kg/h treated
    WWTP_elec_in      = rs({'Elec',       'in',  'spec_work_WWTP'}),   -- kW per kg/h
  })


return et
