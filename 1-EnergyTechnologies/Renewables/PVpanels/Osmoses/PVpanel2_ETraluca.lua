-- PV model (Based on Araz's model)

local osmose  = require 'osmose'
local ET      = osmose.Model 'PV'

ET.inputs = {

  add_PVpanel2_ETraluca = {default =1, unit = 'C'},
  PV_capacity = { default = 1, unit='-'} , -- for manipulating the produced amount of solar available

  --  PV_available = {default = 7.55, unit = 'm^2'},
  --  areapv = {default = 7.55, unit = 'm^2'},
  --  E_default = {default = 0, unit = 'kW'},
  --Cost: [JLR]
  T_ext             = {default = 14.4, unit = 'C'},---read from csv
  GI                = {default = 100, unit = 'W/m^2'},--read from csv
  size_ref          = {default = 16000, unit = 'm^2'},
  area_factor       = {default = 0.25, unit = nil},
  T_ref             = {default = 298, unit = 'K'},
  U_glass           = {default = 29.1, unit = 'W*m^-2/K'},
  f_glass           = {default = 0.9, unit = nil},
  efficiency_ref    = {default = 0.14, unit = nil},
  efficiency_var    = {default = 0.001, unit = '1/K'},
  param_electricity = {default = 1000, unit = 'W/kW'},
  costinv           = {default = 150, unit = 'CHF/m^2'}, --initially 300
  i                 = {default = 0.08, unit = nil},
  n                 = {default = 20, unit = nil},
}

ET.outputs = {
  T_panel     = {job = function() return (U_glass*(T_ext+273.15))/(U_glass-efficiency_var*GI)+GI*(f_glass-efficiency_ref-efficiency_var*T_ref)/(U_glass-efficiency_var*GI) end, unit = 'K'},
  size_real   = {job = "size_ref*area_factor", unit = 'm^2'},
  efficiency  = {job = "efficiency_ref-efficiency_var*(T_panel()-T_ref)", unit = nil},
  E_default   = {job = "GI*size_real()*efficiency()/param_electricity", unit = 'kW'},
  Cinv2       = {job = function() return costinv*(i*((1+i)^n)/((1+i)^n-1))*size_real() end, unit = 'CHF/yr'},
}

ET:addLayers {Elec = {type= 'ResourceBalance', unit = 'kW'} }

--Fmin = 0, Fmax = 10000
ET:addUnit("PV", {type = 'Utility', Fmin = 0, Fmax = 1, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2', sizingStream = {'elecPV'}, addToProblem ='add_PVpanel2_ETraluca'})
--ET:addUnit("PV", {type = 'Utility', Fmin = 0, Fmax = 3, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2', sizingStream = {'elecPV'}, addToProblem ='add_PVpanel2_ETraluca'})
--ET:addUnit("PV", {type = 'Process', Mult='PV_capacity', Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 'Cinv2', sizingStream = {'elecPV'}, addToProblem ='add_PVpanel2_ETraluca'})
ET["PV"]:addStreams({
  elecPV = rs({'Elec', 'out', 'E_default'})
})

-- MK adaptations: removing period from Units_Mult_t. New variable Units_Mult_p is now the mult of a period. Units_Mult remains the old one. Adapt to new names of PERIOD and TIMES_OF_PERIOD for Units_Mult_p
--ET:addEquations {Mult_PV = { statement = "subject to constraint_mult_PV{p in PERIOD, t in TIMES_OF_PERIOD[p]}: \n\t Units_Mult_t[PV,t] = Units_Mult_p[PV,p];", param = {}, addToProblem = 1, type ='ampl' } }

return ET

