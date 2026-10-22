-- reference: 
-- Du Wen, Muhammad Aziz,
-- Flexible operation strategy of an integrated renewable multi-generation system for electricity, hydrogen, ammonia, and heating,
-- Energy Conversion and Management, Volume 253, 2022, 115166
--https://www.axpo.com/se/se/energy-knowledge/wind-power.html

local osmose  = require 'osmose'
local ET      = osmose.Model 'WT'
local math = require 'math'


ET.inputs = {

  add_WindTurbine_ET = {default =1, unit = 'C'},

-- inputs
  N_WT = {default = 1, unit =  '-'},           -- number of wind turbine
  V_mea = {default = 6, unit = 'm/s'},         -- measured wind speed
  T_ext = {default = 25, unit = 'C'},           -- ambient temperature
-- technical parameter
  d_rotor = {default = 82, unit = 'm'},        -- rotor diameter
  z_rotor = {default = 71.5, unit = 'm'},      -- height of rotor
  z_mea = {default = 10, unit = 'm'},          -- height of measurement
  eta_mec = {default = 0.9, unit = '-'},       -- mechanical efficiency
  shear_exp = {default = 0.25, unit =  '-'},    -- wind shear exponent
  co_power = {default = 0.49, unit =  '-'},     -- power coefficient
-- economic parameter
  cost_capex_WT = {default = 1436, unit = 'USD/kW'},  -- CAPEX, reference: https://www.nrel.gov/docs/fy21osti/78471.pdf, table ES1
  cost_opex_WT = {default = 43, unit = 'USD/kW/y'},  -- OPEX
  i = {default = 0.08, unit =  '-'},
  n = {default = 20, unit =  '-'},
  pi = {default = 3.141592, unit =  '-'},
}


ET.outputs = {
  ro_air = {job = "1.293*273.15/(T_ext+273.15)", unit = 'kg/m^3'},             -- correction of air density
  A_rotor = {job = "0.25*pi*d_rotor^2", unit = 'm^2'},         -- swept area
  V_real = {job = "V_mea*(z_rotor/z_mea)^shear_exp", unit = 'm/s'},      -- correction of wind speed
  E_wind = {job = "(0.5*N_WT*ro_air()*A_rotor()*V_real^3)/1000", unit = 'kW'},  -- wind potential
  P_WT_rated = {job = "(0.5*N_WT*ro_air()*A_rotor()*12^3)/1000", unit = 'kW'}, -- rated power -- CALCULAR
  P_WT = {
    unit = 'kW',
    job = function()
        local V = V_real()  -- Store V_real() value to avoid calling it multiple times
        if V < 3 then  -- cut in speed
            outputs = 0
        elseif V > 25 then  -- cut off speed
            outputs = 0
        elseif V > 12 and V <= 25 then  -- rated speed
            outputs = (0.5 * N_WT * ro_air() * A_rotor() * eta_mec * co_power * 12^3) / 1000
        else
            outputs = (0.5 * N_WT * ro_air() * A_rotor() * eta_mec * co_power * V^3) / 1000
        end
        return outputs
    end
},


  efficiency = {job = "eta_mec*co_power", unit = '-'},

  Annuity_fact = {job = '(i*(i+1)^n)/((i+1)^n-1)',unit = '-'},
  Cinv2 = {job = "cost_capex_WT*P_WT_rated()*Annuity_fact()", unit = 'USD'},
 -- Cost2 = {job = "cost_opex_WT*P_WT()", unit = 'USD/h'},
}

ET:addLayers {Elec = {type= 'ResourceBalance', unit = 'kW'} }


--Fmin = 0, Fmax = 1,
-- Mult = 1
--type = 'Utility', Fmin = 0, Fmax = 1, 
ET:addUnit("WTmodel", {type = 'Utility', Fmin = 1, Fmax = 1, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, sizingStream = {'elecWT'}, addToProblem = 'add_WindTurbine_ET'})--'P_WT_rated'
--ET:addUnit("WTmodel", {type = 'Process', Fmin = 0, Fmax = 1, Cost1 = 0, Cost2 = 0, Cinv1 = 0, Cinv2 = 0, sizingStream = {'elecWT'}, addToProblem = 'add_WindTurbine_ET'})--'P_WT_rated'
ET["WTmodel"]:addStreams({
  elecWT = rs({'Elec', 'out', 'P_WT'})
})

--Most onshore wind turbines today are rated at 2.5-3 MW, (https://www.inspirecleanenergy.com/blog/clean-energy-101/how-much-energy-does-wind-turbine-produce)
--The maximum power output is reached at 12 to 15 m/s. (https://www.axpo.com/se/se/energy-knowledge/wind-power.html#:~:text=A%20wind%20power%20plant%20begins,speeds%20exceeding%20200%20km%2Fh.)
return ET