# Instant coffee, spray-dried route

*Process data for mass and heat integration: rs and qt tables*

## 1. Process

The plant converts green coffee beans into spray-dried instant coffee. The beans are roasted, cooled and ground; the soluble solids are extracted with hot water, the extract is clarified and concentrated by vacuum evaporation, and the concentrate is spray dried in hot air.

Process steps and conditions:

1. Roasting of green beans (10 % moisture) in batch drum roasters with gas recirculation. Gas enters the roasting chamber at about 455 °C and the beans reach 236 °C (medium roast). Silverskin is separated in a cyclone.
2. Oxidation of volatile organic compounds and CO in the roaster gas in a catalytic afterburner at 400 °C; the stack gas leaves at 400 °C.
3. Water quench of the roasted beans to 120 °C, air cooling to 30 °C, and grinding.
4. Extraction in a battery of percolation columns with water at 180 °C. The extract (21.5 % solids) leaves at 110 °C; the spent grounds (79 % moisture) are discharged at 180 °C into an atmospheric cyclone, where part of their water flashes to steam.
5. Cooling of the extract to 12 °C, clarification by centrifugation, and storage.
6. Concentration in a single-effect vacuum evaporator at 55 °C to 44 % solids; the vapour condenses at about 50 °C.
7. Cooling of the concentrate to 12 °C for storage, then preheating to 39 °C before atomisation.
8. Spray drying with ambient air heated to 178 °C; a fluid bed at the bottom of the tower uses dehumidified air heated from 15 to 96 °C. The exhaust air leaves at 96 °C through a cyclone; the powder has 3 % moisture.

## 2. Basis and conventions

- **Reference flow:** 1 t/h of instant coffee. At this basis, a heat load in kW equals the specific energy in kWh per tonne of instant coffee, and a mass flow in kg/h equals kg per tonne.
- **Reference plant:** 5,000 t/y over 8,000 operating hours per year, that is 0.625 t/h. Columns labelled "ref. plant" are the 1 t/h values multiplied by 0.625.
- **Heat integration:** global ΔTmin = 10 K, applied as ΔTmin/2 = 5 K on every stream. Hot streams (H) must be cooled; cold streams (C) must be heated.
- Heat loads are time-averaged over the operating hours; batch roasting and the extraction cycles are represented by their average load.
- **Utilities are not part of the process data:** boilers, steam, burners and their fuel, the refrigeration plant, cooling water and air dehumidification are supplied by the utility system you design. Refrigeration demands appear as hot streams at the temperature of the product.
- Roasting (C1) and afterburning (C2) are direct-fired duties, represented by the heating of the process gas; the burners, their fuel and combustion air belong to the utility system.

![Block flow diagram of the instant coffee plant](../Figures/coffee_SD_flowsheet.png)

*Figure 1. Block flow diagram of the spray-dried route, mass flows in kg/h per 1 t/h of instant coffee.*

## 3. rs: material flows

**Table 1. Material flows, per 1 t/h of instant coffee.**

| Stream | Flow (kg/h) | T (°C) | Basis |
|:---|---:|:---|:---|
| **Raw materials (in)** |  |  |  |
| Green coffee beans | 2,430.0 | 20 | 2.43 t per t of instant coffee, medium roast |
| Quench water | 269.9 | 20 | Evaporated in the roaster plus moisture left in the beans |
| Extraction water | 7,451.4 | 20 | Leaves with the extract and the spent grounds |
| **Total in** | **10,151.3** |  |  |
| **Products and by-products (out)** |  |  |  |
| Instant coffee (3 % moisture) | 1,000.0 | 30 | Product |
| Silverskin | 18.2 | about 200 | 7.5 kg per t of green beans |
| Roaster off-gas: water vapour, CO2 and volatiles from the beans | 620.2 | 400 | Bean moisture, dry-matter loss and quench steam |
| Flash steam from spent-grounds discharge | 644.0 | 100 | Released at atmospheric pressure |
| Spent grounds (76 % moisture) | 4,357.2 | 40 | 1,050.3 kg/h dry matter |
| Evaporator condensate | 2,307.1 | 50 | Water evaporated from the extract |
| Water vapour in the dryer exhaust | 1,204.5 | 96 | Concentrate minus product |
| **Total out** | **10,151.3** |  |  |
| **Internal flows** |  |  |  |
| Roasted beans | 2,061.5 | 120 to 30 | 2 % moisture |
| Extract (21.5 % solids) | 4,511.6 | 110 to 12 | Soluble solids of the product / solids fraction |
| Concentrate (44 % solids) | 2,204.5 | 55 to 12 | Soluble solids / solids fraction |
| **Utility media (not part of the closure)** |  |  |  |
| Spray-dryer main air | 41,296 | 20 to 178 | Air per kg of water evaporated as in the reference plant |
| Fluid-bed air, dehumidified | 6,768 | 15 to 96 | Same basis |
| Exhaust air with water vapour | 50,215 | 96 | Same basis |

*Product and raw-material flows close at 10,151.3 kg/h in and out. The extraction yield is 48 % of the dry roasted coffee. Combustion gases of the roaster burners are part of the utility system and are not listed.*

## 4. rs: process electricity

Table 2 lists only the electricity that the process itself consumes. Heat and refrigeration demands are not included here: they are the qt streams of Table 3 and must be supplied by utilities that you select and size (boilers, burners, heat pumps, refrigeration plant, cooling water).

**Table 2. Process electricity demand, per 1 t/h of instant coffee.**

| Item | kW at 1 t/h | Basis |
|:---|---:|:---|
| Electric motors (roaster fans, grinders, pumps, vacuum pumps, dryer fans, conveyors) | 722 | 621 kcal per kg of instant coffee, measured in a spray-dried coffee plant |
| of which grinding | 33 | 16 kWh per t of roasted coffee |
| Lighting | 34 | 29 kcal per kg of instant coffee, same plant |
| **Total process electricity** | **756** |  |

*For comparison only: without any heat recovery, supplying the cold streams of Table 3 with natural-gas burners (C1, C2) and an 85 % efficient steam boiler (all other cold streams) would require about 7,137 kWh of natural gas per tonne of instant coffee. Okada et al. (1980) measured 14,280 kWh of fuel per tonne in a 1970s spray-dried coffee plant without afterburning and with large losses.*

## 5. qt: thermal streams

**Table 3. Thermal streams of the spray-dried route. Q and mCp at 1 t/h of instant coffee; ΔTmin/2 = 5 K for all streams; operating time 8,000 h/y.**

| ID | Stream | Tin (°C) | Tout (°C) | Q, 1 t/h (kW) | mCp, 1 t/h (kW/K) | Q, ref. plant (kW) |
|:---|:---|---:|---:|---:|---:|---:|
| **Cold streams (to be heated)** |  |  |  |  |  |  |
| C1 | Roaster furnace, recirculated gas | 200 | 455 | 797.18 | 3.126 | 498.2 |
| C2 | Catalytic afterburner, feed gas | 200 | 400 | 296.99 | 1.485 | 185.6 |
| C3 | Extraction water | 20 | 180 | 1,390.93 | 8.693 | 869.3 |
| C4 | Clarified extract, preheating | 12 | 55 | 193.05 | 4.489 | 120.7 |
| C5 | Evaporator, boiling extract | 55 | 56 | 1,518.83 | 1,518.829 | 949.3 |
| C6 | Concentrate preheating before atomisation | 12 | 39 | 48.89 | 1.811 | 30.6 |
| C7 | Spray-dryer main air | 20 | 178 | 1,830.56 | 11.586 | 1,144.1 |
| C8 | Fluid-bed air (dehumidified) | 15 | 96 | 153.79 | 1.899 | 96.1 |
|  | **Total cold streams** |  |  | **6,230.2** |  | **3,893.9** |
| **Hot streams (to be cooled)** |  |  |  |  |  |  |
| H1 | Stack gas after catalytic afterburner | 400 | 120 | 415.79 | 1.485 | 259.9 |
| H2 | Roasted-bean cooling with air | 120 | 30 | 86.33 | 0.959 | 54.0 |
| H3 | Extract cooling before clarification | 110 | 12 | 439.97 | 4.489 | 275.0 |
| H4 | Flash steam from spent-grounds discharge | 100 | 99 | 403.77 | 403.768 | 252.4 |
| H5 | Spent grounds after flash | 100 | 40 | 257.74 | 4.296 | 161.1 |
| H6 | Evaporator vapour, condensing | 50 | 49 | 1,526.52 | 1,526.520 | 954.1 |
| H7 | Concentrate cooling to storage | 55 | 12 | 77.86 | 1.811 | 48.7 |
| H8 | Spray-dryer exhaust air | 96 | 40 | 820.18 | 14.646 | 512.6 |
|  | **Total hot streams** |  |  | **4,028.2** |  | **2,517.6** |

*mCp = Q / |Tout − Tin|. Streams with a 1 K span are phase changes at nearly constant temperature: the evaporator, the vapour condenser and the flash steam. H3 and H7 end below ambient temperature: their last part requires refrigeration unless a cold stream absorbs it.*

## 6. Reference targets

Check your own problem-table or composite-curve calculation against these targets for the 16 streams of Table 3.

**Table 4. Minimum energy targets, ΔTmin = 10 K.**

| Quantity | 1 t/h (kW) | Ref. plant (kW) | Ref. plant (MWh/y) |
|:---|---:|---:|---:|
| Total heating demand (cold streams) | 6,230.2 | 3,893.9 | 31,151 |
| Total cooling demand (hot streams) | 4,028.2 | 2,517.6 | 20,141 |
| Minimum hot utility | 3,548.9 | 2,218.1 | 17,745 |
| of which above 400 °C (roaster furnace) | 171.9 | 107.5 | 860 |
| Minimum cold utility | 1,346.9 | 841.8 | 6,734 |
| of which below ambient (refrigeration) | 50.4 | 31.5 | 252 |
| Maximum heat recovery | 2,681.3 | 1,675.8 | 13,406 |
| Pinch temperature (shifted) | 45 °C | 45 °C |  |

*Reference-plant annual energy = kW at the reference plant × 8,000 h. The pinch at 45 °C shifted corresponds to 50 °C on hot streams and 40 °C on cold streams. Cold utility below ambient is the heat that must be removed below 20 °C on hot streams (15 °C shifted) when every other cold utility is placed at the highest feasible temperature. The evaporator boils at 55 °C while its own vapour condenses at 50 °C: this pair sets the pinch, and only a heat pump or a multiple-effect evaporator can recycle that latent heat.*

## 7. Data basis

**Table 5. Origin of the data.**

| Data | Source |
|:---|:---|
| Green beans 2.43 t per t of instant coffee (medium roast) | Gosalvitr et al. (2023), Table 3 |
| Roasting: bean moisture 11.1 % dry basis, dry-matter loss 6.8 %, end of roast 236 °C, quench to 120 °C, gas at 455 °C into the chamber | Schwartzberg (2013), reference medium roast in a recirculating (R) roaster |
| Roaster and afterburner fuel 1,621 kJ/kg green beans; stack gas 400 °C; 38 % saving when stack gas is cooled to 120 °C | Schwartzberg (2013), Tables 1 and 2: catalytic afterburner at 400 °C |
| Gas leaving the roasting chamber at 200 °C (C1, C2 inlet) | Assumed mean value; Schwartzberg (2013) reports that it rises during the roast |
| Silverskin 7.5 kg per t of green beans | Chemat et al. (2024) |
| Roasted-bean moisture 2 %; cooling to 30 °C | Assumed; Gosalvitr et al. (2023) for the 30 °C |
| Extraction at 180 °C; extract 20 to 23 °Brix at 110 °C; grounds at 79 % moisture | Okada et al. (1980), measured in a 1,000 kg/h spray-dried coffee plant |
| Evaporation at 55 °C under vacuum, single effect, to 39 to 44 °Brix | Okada et al. (1980) |
| Extract cooled below 15 °C before clarification; storage at 12 °C | Bassoli (2019); Tinoco-Caicedo et al. (2020) |
| Spray dryer: air 178 °C, fluid-bed air 15 to 96 °C, exhaust 96 °C, air flows per kg of water evaporated, feed at 44 % and preheated to 39 °C, product 3 % moisture | Tinoco-Caicedo et al. (2020), Table 5, measured in an industrial plant |
| Process electricity 756 kWh/t (motors and lighting) | Okada et al. (1980); grinding 16 kWh/t from Gosalvitr et al. (2023) |
| Flash of spent grounds to 100 °C, then cooling to 40 °C; cp of dry grounds 1.5 kJ/(kg K); cp of extract 4.18 (1 − x) + 1.4 x kJ/(kg K) | Assumed; discharge into atmospheric cyclones as described by Bassoli (2019) |
| Vapour condenses 5 K below the boiling extract | Assumed (boiling-point elevation and pressure drop) |
| Reference plant 5,000 t/y, 8,000 h/y; boiler efficiency 85 % | Mitraki et al. (2026) and its OSMOSE model |

## References

1. Bassoli D.G. (2019). Instant coffee production. In *Coffee: Production, Quality and Chemistry*, Royal Society of Chemistry, pp. 292–308.
2. Chemat A. et al. (2024). Valorization of coffee silverskin using extraction cycles and water as a solvent: design of process. *Molecules* 29(6), 1318. <https://doi.org/10.3390/molecules29061318>
3. Gosalvitr P., Cuéllar-Franca R.M., Smith R., Azapagic A. (2023). An environmental and economic sustainability assessment of coffee production in the UK. *Chemical Engineering Journal* 465, 142793. <https://doi.org/10.1016/j.cej.2023.142793>
4. Mitraki R., Limpach J., Salman M., Flórez-Orrego D., Maréchal F., Léonard G. (2026). Evaluation of energy transition pathways for the instant coffee industry. *Energy Demand* 1(2), 1–18. <https://doi.org/10.66506/ed.52>
5. Okada M., Rao M.A., Lima J.E., Torloni M. (1980). Energy consumption and the potential for conservation in a spray-dried coffee plant. *Journal of Food Science* 45(3), 685–688. <https://doi.org/10.1111/j.1365-2621.1980.tb04132.x>
6. Schwartzberg H. (2013). Batch coffee roasting; roasting energy use; reducing that use. In Yanniotis S. et al. (eds.), *Advances in Food Process Engineering Research and Applications*, Springer, pp. 173–195.
7. Tinoco-Caicedo D.L., Lozano-Medina A., Blanco-Marigorta A.M. (2020). Conventional and advanced exergy and exergoeconomic analysis of a spray drying system: a case study of an instant coffee factory in Ecuador. *Energies* 13(21), 5622. <https://doi.org/10.3390/en13215622>

## Further reading for students

Studies on energy use, heat recovery and by-product valorisation in coffee processing, useful to extend your analysis:

- Clarke R.J. (1987). Extraction. In Clarke R.J., Macrae R. (eds.), *Coffee, Volume 2: Technology*, Springer, pp. 109–145.
- Humbert S., Loerincik Y., Rossi V., Margni M., Jolliet O. (2009). Life cycle assessment of spray dried soluble coffee and comparison with alternatives (drip filter and capsule espresso). *Journal of Cleaner Production* 17(15), 1351–1358.
- Kekes T. et al. (2025). Enhancing environmental sustainability in the coffee processing industry via energy recovery and optimization: a life cycle assessment case study. *Sustainability* 17(3), 1334. <https://doi.org/10.3390/su17031334>
- Ladha-Sabur A., Bakalis S., Fryer P.J., Lopez-Quiroga E. (2019). Mapping energy consumption in food manufacturing. *Trends in Food Science & Technology* 86, 270–280. <https://doi.org/10.1016/j.tifs.2019.02.034>
- Pantaleo A.M. et al. (2018). Integrating cogeneration and intermittent waste-heat recovery in food processing: microturbines vs. ORC systems in the coffee roasting industry. *Applied Energy* 225, 782–796. <https://doi.org/10.1016/j.apenergy.2018.04.097>
- Sidło W., Latosińska J. (2025). Reuse of spent coffee grounds: alternative applications, challenges, and prospects. A review. *Applied Sciences* 15(1), 137. <https://doi.org/10.3390/app15010137>
