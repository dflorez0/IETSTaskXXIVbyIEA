# Integrated pork plant: slaughtering, cutting and cooked sausages

*Process data for mass and heat integration: rs and qt tables*

## 1. Process

The plant slaughters pigs, chills and cuts the carcasses, sells most of the meat as fresh cuts and turns the trimmings into cooked sausages of the cervelat type. Combining a slaughter line with meat processing on one site is typical of large plants (Fritzson and Berntsson, 2006a).

Process steps and conditions:

1. Stunning and bleeding; the blood is collected and chilled to about 5 °C.
2. Scalding in water at 58 to 65 °C for 3 to 6 min, with the tank held near 60 °C by steam, followed by mechanical dehairing.
3. Singeing in a direct-fired oven at 900 to 1,000 °C to remove residual hair, then polishing, evisceration and splitting.
4. Chilling of the carcasses from about 38 °C to 4 °C; EU rules require pig meat to reach at most 7 °C before cutting or transport.
5. Cutting and deboning in chilled rooms; boneless meat is about 1/1.37 of the carcass mass.
6. Mixing of trimmings with ice, salt and spices into a batter, filled into casings.
7. Cooking with direct steam injection to a core temperature of 74 °C.
8. Showering to about 45 °C and chilling to 2 °C.
9. Chilled storage at about 2 °C and frozen storage at about −25 °C.

Three water networks serve the plant, all fed with mains water at 11 °C: hot water at 82 °C for knife sterilisers and disinfection, warm water at 55 °C for cleaning, and tap water at 40 °C for hand washing and personnel facilities.

## 2. Basis and conventions

- **Reference flow:** 1 t/h of hot carcass weight, that is 11.05 pigs/h at the Swiss average carcass of 90.5 kg. At this basis, a heat load in kW equals the specific energy in kWh per tonne of carcass, and a mass flow in kg/h equals kg per tonne.
- **Reference plant:** 700,000 pigs/y over 6,300 operating hours per year, that is 10.06 t/h of carcass (111 pigs/h). Columns labelled "ref. plant" are the 1 t/h values multiplied by 10.06.
- **Heat integration:** global ΔTmin = 10 K, applied as ΔTmin/2 = 5 K on every stream. Hot streams (H) must be cooled; cold streams (C) must be heated.
- Heat loads are time-averaged over the operating hours; batch steps (cooking, cleaning) are represented by their average load.
- **Utilities are not part of the process data:** steam, hot-water generation, refrigeration and cooling are supplied by the utility system you design. Refrigeration demands appear as hot streams at the temperature of the product or of the room air.
- Singeing (C1) is a direct-fired duty at 900 to 1,000 °C; the burner and its flue gas belong to the utility system.

![Block flow diagram of the integrated pork plant](../Figures/meat_flowsheet.png)

*Figure 1. Block flow diagram of the integrated pork plant, mass flows in kg/h per 1 t/h of hot carcass.*

## 3. rs: material flows

**Table 1. Material and utility-medium flows, per 1 t/h of hot carcass.**

| Stream | Flow (kg/h) | T (°C) | Basis |
|:---|---:|:---|:---|
| **Raw materials (in)** |  |  |  |
| Live pigs | 1,282.1 | 38 | Carcass 90.5 kg per pig, dressing yield 78 % |
| Ice and water for the batter | 50.0 | 0 | 5 % of carcass mass |
| **Total in** | **1,332.1** |  |  |
| **Products and by-products (out)** |  |  |  |
| Fresh cuts | 529.9 | 2 | Boneless meat minus trimmings |
| Cooked sausages | 235.0 | 2 | Batter minus 6 % cooking loss |
| Blood | 38.5 | 5 | 3 % of live weight |
| Offal, intestines, bristles | 243.6 | 38 | Live weight minus carcass minus blood |
| Bones, fat, rind | 270.1 | 4 | Carcass minus boneless meat |
| Vapour from cooking | 15.0 | up to 100 | 6 % of batter |
| **Total out** | **1,332.1** |  |  |
| **Internal flows** |  |  |  |
| Hot carcass to chilling | 1,000.0 | 38 to 4 | Basis |
| Boneless meat | 729.9 | 4 | Carcass / 1.37 |
| Trimmings to the sausage line | 200.0 | 4 | 20 % of carcass mass |
| Sausage batter | 250.0 | 4 to 74 | Trimmings plus ice and water |
| **Utility media (mains water at 11 °C, discharged as wastewater)** |  |  |  |
| Hot water | 497 | 82 | Knife sterilisers, disinfection |
| Warm water | 2,187 | 55 | Cleaning |
| Tap water | 696 | 40 | Hand washing, personnel |

*Product and raw-material flows close at 1,332.1 kg/h in and out. Water networks are utility media and are not part of this closure.*

## 4. rs: process electricity

Table 2 lists only the electricity that the process itself consumes. Heat and refrigeration demands are not included here: they are the qt streams of Table 3 and must be supplied by utilities that you select and size (boilers, heat pumps, refrigeration plant, cooling water).

**Table 2. Process electricity demand, per 1 t/h of hot carcass.**

| Item | kW at 1 t/h | Basis |
|:---|---:|:---|
| Slaughter line (stunning, dehairing, polishing, conveyors, lighting) | 49 | Slaughterhouse electricity (149 kWh/t) minus cooling systems (100 kWh/t) |
| Cutting and deboning | 44 | 60 kWh per t of boneless meat × 0.730 t per t of carcass |
| Sausage line (cutting, mixing, filling, packing, lighting) | 99 | 660 kWh per t of raw material × 60 % non-cooling share × 0.25 t per t of carcass |
| **Total process electricity** | **192** |  |

*Air compressors (about 18 kWh/t, 5 % of plant electricity) are included in the rows above; their recoverable heat is stream H3. For comparison only: a large Swedish slaughter and meat-processing plant of the reference size used about 490 kWh of electricity and 420 kWh of fuel per tonne of carcass, including refrigeration, boilers and comfort heating (Fritzson and Berntsson, 2006b).*

## 5. qt: thermal streams

**Table 3. Thermal streams of the integrated pork plant. Q and mCp at 1 t/h of carcass; ΔTmin/2 = 5 K for all streams.**

| ID | Stream | Tin (°C) | Tout (°C) | Q, 1 t/h (kW) | mCp, 1 t/h (kW/K) | Q, ref. plant (kW) |
|:---|:---|---:|---:|---:|---:|---:|
| **Cold streams (to be heated)** |  |  |  |  |  |  |
| C1 | Singeing oven, direct-fired | 900 | 1000 | 28.00 | 0.280 | 281.7 |
| C2 | Scalding tank, held at 60 °C | 60 | 61 | 40.00 | 40.000 | 402.4 |
| C3 | Hot water 82 °C (sterilisers, disinfection) | 11 | 82 | 40.98 | 0.577 | 412.2 |
| C4 | Warm water 55 °C (cleaning) | 11 | 55 | 111.73 | 2.539 | 1,124.0 |
| C5 | Tap water 40 °C (hand washing, personnel) | 11 | 40 | 23.43 | 0.808 | 235.7 |
| C6 | Sausage cooking, direct steam injection | 112 | 113 | 63.86 | 63.857 | 642.4 |
|  | **Total cold streams** |  |  | **308.0** |  | **3,098.3** |
| **Hot streams (to be cooled)** |  |  |  |  |  |  |
| H1 | Cooking-oven exhaust air | 70 | 35 | 20.21 | 0.577 | 203.3 |
| H2 | Sausage shower cooling | 74 | 45 | 5.68 | 0.196 | 57.1 |
| H3 | Air compressors, heat recovery | 70 | 25 | 17.89 | 0.398 | 180.0 |
| H4 | Blood chilling | 38 | 5 | 1.27 | 0.038 | 12.8 |
| H5 | Carcass chilling | 38 | 4 | 42.50 | 1.250 | 427.5 |
| H6 | Sausage chilling | 45 | 2 | 8.42 | 0.196 | 84.7 |
| H7 | Chilled rooms (cutting, storage), air at 2 °C | 3 | 2 | 150.23 | 150.231 | 1,511.3 |
| H8 | Freezer rooms, air at −25 °C | −24 | −25 | 6.00 | 6.000 | 60.4 |
|  | **Total hot streams** |  |  | **252.2** |  | **2,537.0** |

*mCp = Q / |Tout − Tin|. Streams with a 1 K span are near-isothermal duties: the scalding tank, steam injection for cooking, and room air held at a set temperature. H4 to H8 are refrigeration demands at product or room-air temperature.*

## 6. Reference targets

Check your own problem-table or composite-curve calculation against these targets for the 14 streams of Table 3.

**Table 4. Minimum energy targets, ΔTmin = 10 K.**

| Quantity | 1 t/h (kW) | Ref. plant (kW) | Ref. plant (MWh/y) |
|:---|---:|---:|---:|
| Total heating demand (cold streams) | 308.0 | 3,098.3 | 19,519 |
| Total cooling demand (hot streams) | 252.2 | 2,537.0 | 15,983 |
| Minimum hot utility | 237.6 | 2,390.3 | 15,059 |
| of which above 900 °C (singeing) | 28.0 | 281.7 | 1,775 |
| Minimum cold utility | 181.8 | 1,829.0 | 11,523 |
| of which at the freezer level (−25 °C) | 6.0 | 60.4 | 380 |
| Maximum heat recovery | 70.4 | 708.0 | 4,461 |
| Pinch temperature (shifted) | 16 °C | 16 °C |  |

*Reference-plant annual energy = kW at the reference plant × 6,300 h. The pinch at 16 °C shifted corresponds to 21 °C on hot streams and 11 °C on cold streams. Because the water networks start from mains water at 11 °C, they absorb the warm heat sources, and all of the minimum cold utility lies below ambient: it must be supplied by refrigeration.*

## 7. Data basis

**Table 5. Origin of the data.**

| Data | Source |
|:---|:---|
| Process steps and temperatures | Karlis et al. (2024): scalding 58 to 65 °C, singeing 900 to 1,000 °C, blood chilled to about 5 °C; COWI (2000): sterilisers at 82 °C; Meier (2007): steam injection at 113 °C, core 74 °C, shower to about 45 °C, chilling to 2 °C |
| Average carcass 90.5 kg per pig | Proviande (2025): 214,208 t of pig carcasses from 2,365,996 pigs |
| Dressing yield 78 % | Assumed general value (carcass / live weight) |
| Blood 3 % of live weight | COWI (2000), Table 2-2 |
| Boneless meat = carcass / 1.37 | Ramírez et al. (2006) |
| Trimmings 20 % and ice 5 % of carcass; cp of sausages 3.0 and of blood 3.6 kJ/(kg K) | Assumed values |
| Cooking loss 6 %; cooking heat 255 kWh/t of batter; oven exhaust 70 to 35 °C, 81 kWh/t | Meier (2007), Bell AG Basel pinch study |
| Water networks: mains at 11 °C; 82, 55 and 40 °C at 5, 22 and 7 m³/h | Fritzson and Berntsson (2006a), Fig. 2, scaled from the reference plant to 1 t/h |
| Reference plant: 700,000 pigs/y, 6,300 h/y | Fritzson and Berntsson (2006b), Table 1 |
| Scalding 40 kWh/t; singeing 28 kWh/t; cooling-system electricity 100 kWh/t | Karlis et al. (2024), Figs 3.39, 3.38 and 3.36: medians of reported pig slaughterhouses, read from the figures |
| Cold demand 200 kWh/t (H4, H5, H7, H8) | Cooling-system electricity × seasonal cooling COP 2.0 (Meier, 2007); carcass chilling 153 kJ/kg (Grimsby Institute); freezer share 3 % (Meier, 2007); chilled rooms take the remainder |
| Process electricity | Nunes et al. (2016): 149 kWh/t for slaughterhouses, 660 kWh/t of raw material for sausage plants; Ramírez et al. (2006): cutting 60 kWh/t, non-cooling share 60 %; COWI (2000), Table 2-12: compressed air 5 % |

## References

1. COWI Consulting Engineers and Planners (2000). *Cleaner Production Assessment in Meat Processing*. Prepared for the United Nations Environment Programme, Division of Technology, Industry and Economics. <https://wedocs.unep.org/handle/20.500.11822/9571>
2. Fritzson A., Berntsson T. (2006a). Efficient energy use in a slaughter and meat processing plant: opportunities for process integration. *Journal of Food Engineering* 76, 594–604. <https://doi.org/10.1016/j.jfoodeng.2005.06.007>
3. Fritzson A., Berntsson T. (2006b). Energy efficiency in the slaughter and meat processing industry: opportunities for improvements in future energy markets. *Journal of Food Engineering* 77, 792–802. <https://doi.org/10.1016/j.jfoodeng.2005.08.005>
4. Grimsby Institute (n.d.). *Sector focus: carcass chilling*. Project on reducing the energy inputs into the refrigeration of food. <https://www.grimsby.ac.uk/documents/defra/sectrep-meatchill.pdf>
5. Karlis P., Presicce F., Giner-Santonja G., Brinkmann T., Roudier S. (2024). *Best Available Techniques (BAT) Reference Document for the Slaughterhouses, Animal By-products and/or Edible Co-products Industries*. JRC, EUR 31752 EN. <https://doi.org/10.2760/18199>
6. Meier D. (2007). *Pilotphase Pinch-Methodik 2006/07: Bell AG*. Schlussbericht, Encontrol GmbH for the Swiss Federal Office of Energy. <https://pubdb.bfe.admin.ch/de/publication/download/2976>
7. Nunes J., Dinho da Silva P., Andrade L.P., Domingues L., Gaspar P.D. (2016). Energy assessment of the Portuguese meat industry. *Energy Efficiency* 9, 1163–1178. <https://doi.org/10.1007/s12053-015-9414-7>
8. Proviande (2025). *Der Fleischmarkt im Überblick 2025*. <https://www.proviande.ch>
9. Ramírez C.A., Patel M., Blok K. (2006). How much energy to process one pound of meat? A comparison of energy use and specific energy consumption in the meat industry of four European countries. *Energy* 31, 2047–2063. <https://doi.org/10.1016/j.energy.2005.08.007>

## Further reading for students

Swiss pinch studies of meat plants and sector-level data, useful for comparing your results with real sites:

- Ong B.H.Y., Bhadbhade N., Olsen D.G., Wellig B. (2023). Characterizing sector-wide thermal energy profiles for industrial sectors. *Energy* 282, 129028 (Swiss meat sector profile). <https://doi.org/10.1016/j.energy.2023.129028>
- DM Energieberatung (2016). *Pinch-Analyse: Bell Schweiz AG, Oensingen*. SFOE. <https://pubdb.bfe.admin.ch/de/publication/download/8405>
- DM Energieberatung (2018). *Pinch-Analyse Bigler AG, Büren an der Aare*. SFOE. <https://pubdb.bfe.admin.ch/de/publication/download/9447>
- DME Energieberatung (2011). *Pinch-Analyse 2011: Rapelli SA, Stabio*. SFOE. <https://pubdb.bfe.admin.ch/de/publication/download/6447>
- Wojdalski J. et al. (2013). Assessment of energy consumption in a meat-processing plant: a case study. *Food and Bioprocess Technology* 6, 2621–2629. <https://doi.org/10.1007/s11947-012-0924-4>
- World Bank Group (2007). *Environmental, Health, and Safety Guidelines: Meat Processing*. <https://www.ifc.org/content/dam/ifc/doc/2000/2007-meat-processing-ehs-guidelines-en.pdf>
