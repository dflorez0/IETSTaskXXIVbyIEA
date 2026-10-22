local osmose = require 'osmose'
local et = osmose.Model 'FurnacePrehNG_ET'

et.header = {
  name = '',
  displayName = '',
  authors = {'Daniel Flórez-Orrego, EPFL IPESE research group'},
  developers = {''},
  contributors = {''},
  creation_date = '',
  updates = {''},
  versions = {'1.0'},
  confidentiality = {''},
  title = 'Natural gas combustion furnace',
  description = [[Natural gas combustion furnace]],
  references = {''},
  adaptedwith = {},
  notes =  {}
}

et.inputs = { 
  dtmin_radiation={default = 2,unit = 'C'}, 
  dtmin_convection={default = 8,unit = 'C'},
  dtmin_2ph={default = 2,unit = 'C'},
  dtmin_0 = {default = 0,unit = 'C'}, 

  Tad={default = 1957, unit = 'C'}, -- consider changing this temperature depending on fuel type, Hysys and https://www.thoughtco.com/flame-temperatures-table-607307
  To={default = 25, unit = 'C'},  -- Tamb = To = Tchemicalreference
  Trad={default = 1100, unit = 'C'}, -- This is a convention, 1100
  Troof = {default = 101, unit = 'C'}, -- Account for lower chimeney temperature, in an hourly resolution, it could vary as well
  Tstack={default = 100, unit = 'C'},  -- safe side, no dewpoint 1 bar
  Twall = {default = 60, unit = 'C'},
  Tloss = {default = 30, unit = 'C'}, -- dissipation temperature to plant environment, for hot gas escaping
  
  MWair={default = 29, unit = ''},  -- molecular weight of dry air (79% N2 + 21% O2) 
  MWfuel = {default = 16, unit = ''},  -- molecular weight of fuel
  MWCO2 = {default = 44, unit = ''},  -- molecular weight of CO2
  LHV ={default = 50000, unit = ''},   -- kJ/kg natural gas LHV @ 25°C,1 bar initially 47000
  molratst = {default = 9.52, unit = '' }, -- CH4 stoich molar air to fuel ratio 
  a = {default=1.02, unit=''}, -- air_act/air_st, excess air flow ratio 
  -- CH4 + a*2(O2+3.76N2) --> CO2 + 2H2O + 2*3.76N2 + 2(a-1)(O2 + 3.76N2)
  
  cpair = {default=1.012, unit=''}, --kJ/kg.K heat capacity @400°C,1bar 
  cpng = {default=2.304, unit=''}, --kJ/kg.K heat capacity methane @530°C,1bar 
  Tprin = {default=26, unit='C'}, -- To <= Air preheating temperature < Trad
  --OBS: Preheating above the pinch has no net useful effect
  --Thus, preheating must be below the pinch temperature of the remaining process.
  --losses={default = 0.03, unit = ''}, -- 3% of losses
  
  Furnace_natGas_LOAD={default = 1000, unit = 'kW'}, -- *400 = maximum furnace capacity

  walllossfactor = {default = 0.1, unit = ''}, -- walllossfactor + hotgasescfactor < 1
  hotgasescfactor = {default = 0.1, unit = ''}, -- refers to hot gas escape

  ------------------------------
  ------- ECONOMICS ------------
  ------------------------------
  inst2avgratio = {default = 2.5, unit = '-'}, -- installed to average power ratio inferred from the measured consumption of natural gas
  Spec_heaterCost_installed = {default = 200, unit = 'Eur/kW'},
  n  = {default = 40, unit = 'year', description = 'Lifetime'},
  i  = {default = 0.06, unit = '-', description = 'interest rate'},
  CEPCI_2020  = {default = 596.2,    unit = '-', description = 'actual CEPCI'},

}

et.outputs = {
  v = {unit='',job='molratst*MWair/MWfuel'}, -- kgair_stoich/kgfuel, stoichiometric air mass

   -- Specific for the useful heat 
  cpg = {unit='',job='Furnace_natGas_LOAD/(Tad-To)'},  -- stoich Cp
  Tad_corr = {unit='C',job='To+(Furnace_natGas_LOAD/(cpg()+(cpair*(a-1)*v()*Furnace_natGas_LOAD/LHV)))'},
  cpg_corr = {unit='',job='Furnace_natGas_LOAD/(Tad_corr()-To)'}, -- excessair cp reduce slope

  Q_radiation = {unit='kW',job='(Furnace_natGas_LOAD*(Tad_corr()-Trad)/(Tad_corr()-To))'}, -- i.e.= cpg_corr*(Tad_corr()-Trad)
  Q_convroof = {unit='kW',job='(Furnace_natGas_LOAD*(Trad-Troof)/(Tad_corr()-To))'}, -- i.e.= cpg_corr*(Trad-Troof)
  Q_convrecov = {unit='kW',job='(Furnace_natGas_LOAD*(Troof-Tstack)/(Tad_corr()-To))'}, -- i.e.= cpg_corr()*(Troof-Tstack)
  Q_preh = {unit='kW',job='cpair*v()*Furnace_natGas_LOAD/LHV*(Tprin-To)'}, -- only stoich air preheating load
  Q_stack = {unit='kW',job='cpg_corr()*(Tstack-To)'}, -- stack losses = Furnace_natGas_LOAD*(Tstack-To)/(Tad_corr()-To)
  Q_radpreh = {unit='kW',job='Q_preh()+Q_radiation()'}, -- To add the preheating to the heat of radiation. The prehating increases the heat above Trad 

  -- Specific for the wall loss heat
  Furnace_natGas_WALL = {unit='',job='walllossfactor*Furnace_natGas_LOAD/(1-walllossfactor-hotgasescfactor)'},
  cpg_wl = {unit='',job='Furnace_natGas_WALL()/(Tad-To)'},  -- stoich Cp kW/K ------------ WATCHOUT FOR EACH FUEL IS DIFFERENT TAD AIR AND TAD OXY
  Tad_corr_wl = {unit='C',job='To+(Furnace_natGas_WALL()/(cpg_wl()+(cpair*(a-1)*v()*Furnace_natGas_WALL()/LHV)))'}, -- K + kW/kW/K
  cpg_corr_wl = {unit='',job='Furnace_natGas_WALL()/(Tad_corr_wl()-To)'}, -- excessoxygen cp reduce slope, kW/K
  
  Q_radiation_wl = {unit='kW',job='(Furnace_natGas_WALL()*(Tad_corr_wl()-Trad)/(Tad_corr_wl()-To))'}, -- i.e.= cpg_corr*(Tad_corr()-Trad)
  Q_convroof_wl = {unit='kW',job='(Furnace_natGas_WALL()*(Trad-Troof)/(Tad_corr_wl()-To))'}, -- i.e.= cpg_corr*(Trad-Troof)
  Q_convrecov_wl = {unit='kW',job='(Furnace_natGas_WALL()*(Troof-Tstack)/(Tad_corr_wl()-To))'}, -- i.e.= cpg_corr()*(Trad-Tstack)
  Q_preh_wl = {unit='kW',job='cpair*v()*Furnace_natGas_WALL()/LHV*(Tprin-To)'}, -- only stoich oxygen preheating load
  Q_stack_wl = {unit='kW',job='cpg_corr_wl()*(Tstack-To)'}, -- stack losses = Furnace_natGas_LOAD*(Tstack-To)/(Tad_corr()-To)
  Q_radpreh_wl = {unit='kW',job='Q_preh_wl()+Q_radiation_wl()'}, -- To add the preheating to the heat of radiation. The prehating increases the heat above Trad 


  -- Specific for the hot gas escape loss heat
  Furnace_natGas_ESC = {unit='',job='hotgasescfactor*Furnace_natGas_LOAD/(1-walllossfactor-hotgasescfactor)'},
  cpg_ae = {unit='',job='Furnace_natGas_ESC()/(Tad-To)'},  -- stoich Cp kW/K ------------ WATCHOUT FOR EACH FUEL IS DIFFERENT TAD AIR AND TAD OXY
  Tad_corr_ae = {unit='C',job='To+(Furnace_natGas_ESC()/(cpg_ae()+(cpair*(a-1)*v()*Furnace_natGas_ESC()/LHV)))'}, -- K + kW/kW/K
  cpg_corr_ae = {unit='',job='Furnace_natGas_ESC()/(Tad_corr_ae()-To)'}, -- excessoxygen cp reduce slope, kW/K
  
  Q_radiation_ae = {unit='kW',job='(Furnace_natGas_ESC()*(Tad_corr_ae()-Trad)/(Tad_corr_ae()-To))'}, -- i.e.= cpg_corr*(Tad_corr()-Trad)
  Q_convroof_ae = {unit='kW',job='(Furnace_natGas_ESC()*(Trad-Troof)/(Tad_corr_ae()-To))'}, -- i.e.= cpg_corr*(Trad-Troof)
  Q_convrecov_ae = {unit='kW',job='(Furnace_natGas_ESC()*(Troof-Tstack)/(Tad_corr_ae()-To))'}, -- i.e.= cpg_corr()*(Trad-Tstack)
  Q_preh_ae = {unit='kW',job='cpair*v()*Furnace_natGas_ESC()/LHV*(Tprin-To)'}, -- only stoich oxygen preheating load
  Q_stack_ae = {unit='kW',job='cpg_corr_ae()*(Tstack-To)'}, -- stack losses = Furnace_natGas_LOAD*(Tstack-To)/(Tad_corr()-To)
  Q_radpreh_ae = {unit='kW',job='Q_preh_ae()+Q_radiation_ae()'}, -- To add the preheating to the heat of radiation. The prehating increases the heat above Trad   
  Q_total_ae = {unit='kW',job='Q_preh_ae()+Q_radiation_ae()+Q_convroof_ae()+Q_convrecov_ae()+Q_stack_ae()'},

  -- Total energy demand
  Q_demand = {unit='kW',job='Furnace_natGas_LOAD+Furnace_natGas_WALL()+Furnace_natGas_ESC()'}, -- in kW
  -- Q_demand = {unit='kW',job='Furnace_natGas_LOAD/(1-losses)'}, -- in kW


------------------------------
------- EMISSIONS ------------
------------------------------
  TotalCO2Flow = {unit='kg/h',job='Q_demand()/LHV*3600*MWCO2/MWfuel'}, -- kg/h CO2, total amount of CO2 produced, fuel dependent, note 1 kmol of CO2 per kmol fuel
  EmitCO2Flow = {unit='kg/h',job='Furnace_natGas_ESC()/LHV*3600*MWCO2/MWfuel'}, -- kg/h CO2, emitted CO2 with escape hot gas, fuel dependent
  CapturableCO2Flow = {unit='kg/h',job='(Q_demand()-Furnace_natGas_ESC())/LHV*3600*MWCO2/MWfuel'}, -- kg/h CO2, capturable CO2 from stack, fuel dependent


------------------------------
------- ECONOMICS ------------
------------------------------ 
  Annuity = {job = '(i*(i+1)^n)/((i+1)^n-1)',unit = '-', },
  Spec_heaterCost = {job = 'inst2avgratio*Spec_heaterCost_installed', unit = 'Eur/kW'},
  Cinv2_NGFur   = {job = 'Spec_heaterCost()*Q_demand()*(CEPCI_2020/CEPCI_2020)*Annuity()', unit = 'Eur/y'}, 

}

et:addLayers {CH4 = {type= 'ResourceBalance', unit = 'kW'} }
et:addLayers {CO2inFlueGas = {type= 'ResourceBalance', unit = 'kg/h'} }
et:addLayers {LGWH = {type ='HeatCascade', unit ='kW'}} -- Initially send it to waste sink after plant heating
et:addLayers {EnvCO2Em = {type= 'ResourceBalance', unit = 'kg/h'} }

-- Default heat cascade (complementary furnace)

et:addUnit('NG_Furnace',{type='Utility', Fmin = 0, Fmax = 400, Cost1 = 0, Cost2 = 0, Cinv1=0, Cinv2='Cinv2_NGFur'}) -- provide enough hot utility 

et["NG_Furnace"]:addStreams({

  -- useful heat
  radiationGas = qt{tin = 'Trad', hin = 'Q_radpreh', tout = 'Trad', hout = 0, dtmin = 'dtmin_radiation', alpha=1}, -- hot stream -- alpha in kW/kgK
  rooftempGas = qt{tin = 'Trad', hin = 'Q_convroof', tout = 'Troof', hout = 0, dtmin = 'dtmin_convection', alpha=1}, -- hot stream -- alpha in kW/kgK
  convrecGas = qt{tin = 'Troof', hin = 'Q_convrecov', tout = 'Tstack', hout = 0, dtmin = 'dtmin_convection', alpha=1}, -- hot stream -- alpha in kW/kgK
  preheatLoad = qt{tin = 'To', hin = 0, tout = 'Tprin', hout = 'Q_preh', dtmin = 'dtmin_convection', alpha=1}, -- cold stream -- alpha in kW/kgK
  --stackGas = qt{tin = 'Tstack', hin = 'Q_stack', tout = 'To', hout = 0, dtmin = 'dtmin_2ph', alpha=1}, -- hot stream -- alpha in kW/kgK, stack cooling NEEDED FOR OxyCCS

  --wall loss heat
  radiationGas_wl = qt{tin = 'Tloss', hin = 'Q_radpreh_wl', tout = 'Tloss', hout = 0, dtmin = 'dtmin_0', HC='LGWH', alpha=1}, -- HC='LGWH', hot stream -- alpha in kW/kgK
  rooftempGas_wl = qt{tin = 'Tloss', hin = 'Q_convroof_wl', tout = 'Tloss', hout = 0, dtmin = 'dtmin_0',HC='LGWH', alpha=1}, -- HC='LGWH', hot stream -- alpha in kW/kgK
  convrecGas_wl = qt{tin = 'Troof', hin = 'Q_convrecov_wl', tout = 'Tstack', hout = 0, dtmin = 'dtmin_convection', alpha=1}, -- hot stream -- alpha in kW/kgK
  preheatLoad_wl = qt{tin = 'To', hin = 0, tout = 'Tprin', hout = 'Q_preh_wl', dtmin = 'dtmin_convection', alpha=1}, -- cold stream -- alpha in kW/kgK
  --stackGas_wl = qt{tin = 'Tstack', hin = 'Q_stack_wl', tout = 'To', hout = 0, dtmin = 'dtmin_2ph', alpha=1}, -- hot stream -- alpha in kW/kgK, stack cooling NEEDED FOR OxyCCS


  -- escape hot gas loss heat
  ---radiationGas_ae = qt{tin = 'Trad', hin = 'Q_radpreh_ae', tout = 'Trad', hout = 0, dtmin = 'dtmin_radiation', HC='LGWH', alpha=1}, -- hot stream -- alpha in kW/kgK
  -- rooftempGas_ae = qt{tin = 'Trad', hin = 'Q_convroof_ae', tout = 'Troof', hout = 0, dtmin = 'dtmin_convection',HC='LGWH', alpha=1}, -- hot stream -- alpha in kW/kgK
  ---convrecGas_ae = qt{tin = 'Troof', hin = 'Q_convrecov_ae', tout = 'Tstack', hout = 0, dtmin = 'dtmin_convection', HC='LGWH', alpha=1}, -- hot stream -- alpha in kW/kgK
  ---stackGas_ae = qt{tin = 'Tstack', hin = 'Q_stack_ae', tout = 'To', hout = 0, dtmin = 'dtmin_2ph', alpha=1, HC='LGWH'}, -- hot stream -- alpha in kW/kgK
  escHotGasloss = qt{tin = 'Tloss', hin = 'Q_total_ae', tout = 'Tloss', hout = 0, dtmin = 'dtmin_0', alpha=1, HC='LGWH'}, --HC='LGWH'-- ROOF T -- hot stream -- alpha in kW/kgK
  preheatLoad_ae = qt{tin = 'To', hin = 0, tout = 'Tprin', hout = 'Q_preh_ae', dtmin = 'dtmin_convection', alpha=1}, -- cold stream -- alpha in kW/kgK
  
  -- Mass streams
  NatGasFurn = rs({'CH4', 'in', 'Q_demand'}), -- kW of natural gas
  NGfurnCO2emit = rs({'EnvCO2Em', 'out', 'EmitCO2Flow'}),
  NGfurnCO2capturable = rs({'CO2inFlueGas', 'out', 'CapturableCO2Flow'}),
})

return et
