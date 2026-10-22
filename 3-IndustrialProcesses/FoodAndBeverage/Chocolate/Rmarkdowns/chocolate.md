# Milk chocolate from whole cocoa beans (route PR1)

*Process data for mass and heat integration: rs and qt tables*

## 1. Process

The plant converts whole fermented cocoa beans into milk chocolate. Beans are debacterized, roasted whole with hot air, cooled and winnowed; the nibs are ground into cocoa liquor. Part of the liquor is pressed into cocoa butter and press cake. Liquor, butter, sugar and milk powder are mixed, refined, conched, tempered, moulded and cooled.

Process steps and conditions:

1. Debacterization of raw beans at 80 to 95 °C, heated by steam at 160 to 180 °C.
2. Whole-bean roasting at about 100 °C in three hot-air zones; air is heated by steam to 145, 155 and 160 °C, and the exhaust leaves at up to 110 °C.
3. Cooling of the roasted beans with air, then breaking and winnowing to separate shells from nibs.
4. Grinding of nibs into cocoa liquor at 70 to 95 °C; mill heat is removed by cooling water.
5. Pressing of part of the liquor at 50 °C (steam at 75 °C) into cocoa butter and press cake.
6. Mixing and roll refining of liquor, butter, sugar and milk powder to 15 to 20 µm; a steam-jacketed mixer provides the drying duty.
7. Conching in four product lines, heated at the start and then cooled; the mass is held near 55 °C.
8. Tempering in storage tanks at 42 to 51 °C and moulding at 30 to 55 °C.
9. Cooling of the moulded chocolate to 5 to 7 °C in cooling tunnels and cold rooms supplied with chilled water at 5/11 °C.

Two site utilities serve the whole plant: a warm-water network at 55 °C that keeps chocolate molten in tracing circuits, and cleaning in place (CIP) with caustic, acid and rinse water.

## 2. Basis and conventions

- **Reference flow:** 1 t/h of milk chocolate. At this basis, a heat load in kW equals the specific energy in kWh per tonne of chocolate, and a mass flow in kg/h equals kg per tonne.
- **Recipe** (mass fractions): cocoa mass 12 %, cocoa butter 23 %, sugar 44.5 %, whole milk powder 20 %, lecithin 0.5 %.
- **Reference plant** (size category 1): 1,000 t/y of chocolate over 3,600 operating hours per year, that is 0.278 t/h. Columns labelled "cat. 1" are the 1 t/h values multiplied by 0.278.
- **Heat integration:** global ΔTmin = 10 K, applied as ΔTmin/2 = 5 K on every stream. Hot streams (H) must be cooled; cold streams (C) must be heated.
- Heat loads are time-averaged over the operating hours; batch steps (conching, CIP) are represented by their average load.
- **Utilities are not part of the process data:** heat, refrigeration and cooling are supplied by the utility system you design.

![Block flow diagram of route PR1](../Figures/ChocolatePR1.png)

*Figure 1. Block flow diagram of route PR1, mass flows in kg/h per 1 t/h of chocolate.*

## 3. rs: material flows

**Table 1. Material and utility-medium flows, per 1 t/h of chocolate.**

| Stream | Flow (kg/h) | T (°C) | Basis |
|:---|---:|:---|:---|
| **Raw materials (in)** |  |  |  |
| Fermented, dried cocoa beans (6.5 % water) | 263.0 | 20 | Swiss average: 0.263 t beans per t chocolate |
| Sugar | 445.0 | 20 | Recipe, 44.5 % |
| Whole milk powder | 200.0 | 20 | Recipe, 20 % |
| Lecithin | 5.0 | 20 | Recipe, 0.5 % |
| Purchased cocoa butter | 181.3 | 20 | Recipe butter (230) minus own pressed butter |
| **Total in** | **1,094.3** |  |  |
| **Products and by-products (out)** |  |  |  |
| Milk chocolate | 1,000.0 | 5 to 7 | Product |
| Cocoa shells | 30.1 | 25 | 12 % of roasted beans |
| Water vapour in roaster exhaust | 12.1 | up to 110 | Moisture 6.5 % to 2 % |
| Cocoa press cake, 11 % fat | 52.1 | 20 | Liquor at 54 % fat pressed to 11 % fat cake |
| **Total out** | **1,094.3** |  |  |
| **Internal flows** |  |  |  |
| Roasted beans, 2 % water | 251.0 | 100 | To cooling and winnowing |
| Nibs, ground to cocoa liquor | 220.8 | 70 to 95 | Roasted beans minus shells |
| Cocoa liquor to recipe | 120.0 |  | Recipe, 12 % cocoa mass |
| Cocoa liquor to press | 100.8 | 50 | Remainder of the liquor |
| Own pressed cocoa butter | 48.7 | 50 | To mixing |
| **Utility media** |  |  |  |
| Roasting air, three zones | 3,284 | 20 in, 145 to 160 heated | Q / (cp ΔT) per zone, cp 1.89 kJ/(kg K) |
| Steam to drying (jacketed mixer) | 86 | about 170 | Q / latent heat |
| Steam to debacterization | 30 | 160 to 180 | Q / latent heat |
| CIP rinse water | 71 | 10 in, 40 out | Q / (cp ΔT) |

*Product and raw-material flows close at 1,094.3 kg/h in and out. Utility media are not part of this closure.*

## 4. rs: process electricity

Table 2 lists only the electricity that the process itself consumes. Heat and refrigeration demands are not included here: they are the qt streams of Table 3 and must be supplied by utilities that you select and size (boilers, heat pumps, refrigeration plant, cooling water).

**Table 2. Process electricity demand, per 1 t/h of chocolate.**

| Item | kW at 1 t/h | Basis |
|:---|---:|:---|
| Air compressors | 102 | Equal to the recovered compressor heat (H6) |
| Conche drives | 237 | Conche cooling (H7 to H10) minus conche heating (C12 to C15) |
| Grinder drives | 30 | Heat removed by grinding cooling water |
| Other drives, fans, lighting, packaging | 514 | Refining, mixing, pressing, winnowing, pumps, packaging, ventilation, lighting |
| **Total process electricity** | **883** |  |

*For comparison only: the current Swiss sector average is about 1,833 kWh of final energy per tonne of chocolate (59 % electricity, 31 % natural gas, 8 % district heating), including the existing utilities.*

## 5. qt: thermal streams

**Table 3. Thermal streams of route PR1. Q and mCp at 1 t/h of chocolate; ΔTmin/2 = 5 K for all streams.**

| ID | Stream | Tin (°C) | Tout (°C) | Q, 1 t/h (kW) | mCp, 1 t/h (kW/K) | Q, cat. 1 (kW) |
|:---|:---|---:|---:|---:|---:|---:|
|  | **Cold streams (to be heated)** |  |  |  |  |  |
| C1 | Roasting air, zone 1 | 20 | 145 | 61.90 | 0.495 | 17.19 |
| C2 | Roasting air, zone 2 | 20 | 155 | 73.44 | 0.544 | 20.40 |
| C3 | Roasting air, zone 3 | 20 | 160 | 95.91 | 0.685 | 26.64 |
| C4 | Drying, steam-jacketed mixer | 164 | 165 | 48.96 | 48.964 | 13.60 |
| C5 | Debacterization of beans | 25 | 80 | 16.98 | 0.309 | 4.72 |
| C6 | CIP caustic solution | 80 | 80.1 | 3.00 | 30.000 | 0.83 |
| C7 | CIP acid solution | 60 | 60.1 | 1.04 | 10.400 | 0.29 |
| C8 | CIP rinse water | 10 | 40 | 2.48 | 0.083 | 0.69 |
| C9 | Tracing warm-water network | 25 | 55 | 215.93 | 7.198 | 59.98 |
| C10 | Press 1, liquor feed | 43 | 50 | 0.50 | 0.071 | 0.14 |
| C11 | Press 2, feed | 20 | 50 | 0.55 | 0.018 | 0.15 |
| C12 | Conche line A, heating | 40 | 55 | 6.26 | 0.417 | 1.74 |
| C13 | Conche line B, heating | 35 | 80 | 8.44 | 0.188 | 2.34 |
| C14 | Conche line C, heating | 35 | 42 | 0.47 | 0.066 | 0.13 |
| C15 | Conche line D, heating | 35 | 42 | 0.74 | 0.106 | 0.21 |
| C16 | Tempering tank 1 | 45 | 46 | 27.50 | 27.495 | 7.64 |
| C17 | Tempering tank 2 | 42 | 43 | 43.26 | 43.255 | 12.02 |
| C18 | Tempering tank 3 | 42 | 43 | 3.69 | 3.685 | 1.02 |
| C19 | Tempering tank 4 | 45 | 46 | 0.95 | 0.955 | 0.27 |
| C20 | Tempering tank 5 | 47 | 48 | 2.19 | 2.190 | 0.61 |
| C21 | Tempering tank 6 | 43 | 44 | 1.23 | 1.230 | 0.34 |
| C22 | Tempering tank 7 | 50 | 51 | 5.49 | 5.490 | 1.52 |
| C23 | Tempering tank 8 | 45 | 46 | 2.75 | 2.750 | 0.76 |
| C24 | Tempering tank 9 | 42 | 43 | 1.36 | 1.365 | 0.38 |
| C25 | Moulding line A, step 1 | 30 | 35 | 1.99 | 0.398 | 0.55 |
| C26 | Moulding line A, step 2 | 35 | 36 | 3.34 | 3.340 | 0.93 |
| C27 | Moulding line A, step 3 | 36 | 39 | 1.46 | 0.487 | 0.41 |
| C28 | Moulding line A, step 4 | 39 | 41 | 1.10 | 0.550 | 0.31 |
| C29 | Moulding line A, step 5 | 41 | 48 | 3.12 | 0.446 | 0.87 |
| C30 | Moulding line A, step 6 | 48 | 49 | 0.48 | 0.480 | 0.13 |
| C31 | Moulding line B, step 1 | 30 | 42 | 3.91 | 0.326 | 1.09 |
| C32 | Moulding line B, step 2 | 42 | 43 | 0.37 | 0.370 | 0.10 |
| C33 | Moulding line B, step 3 | 43 | 54 | 3.98 | 0.361 | 1.10 |
| C34 | Moulding line B, step 4 | 54 | 55 | 0.43 | 0.435 | 0.12 |
|  | **Total cold streams** |  |  | **645.2** |  | **179.2** |
|  | **Hot streams (to be cooled)** |  |  |  |  |  |
| H1 | Roaster exhaust, zone 1 | 30 | 20 | 23.84 | 2.384 | 6.62 |
| H2 | Roaster exhaust, zone 2 | 46 | 20 | 35.32 | 1.358 | 9.81 |
| H3 | Roaster exhaust, zone 3 | 110 | 20 | 62.31 | 0.692 | 17.31 |
| H4 | Press 1, cake cooling | 45 | 20 | 0.92 | 0.037 | 0.26 |
| H5 | Press 2, cake cooling | 50 | 20 | 1.11 | 0.037 | 0.31 |
| H6 | Air compressors, heat recovery | 70 | 16.1 | 102.08 | 1.894 | 28.36 |
| H7 | Conche line A, cooling | 55 | 20 | 92.20 | 2.634 | 25.61 |
| H8 | Conche line B, cooling | 80 | 20 | 118.55 | 1.976 | 32.93 |
| H9 | Conche line C, cooling | 42 | 20 | 5.79 | 0.263 | 1.61 |
| H10 | Conche line D, cooling | 42 | 20 | 36.22 | 1.646 | 10.06 |
| H11 | Production cooling, chilled-water level | 11 | 5 | 337.46 | 56.243 | 93.74 |
|  | **Total hot streams** |  |  | **815.8** |  | **226.6** |

*mCp = Q / |Tout − Tin|. Streams with a 0.1 K or 1 K span are near-isothermal duties (CIP baths, drying, tempering tanks, moulding steps).*

## 6. Reference targets

Check your own problem-table or composite-curve calculation against these targets for the 45 streams of Table 3.

**Table 4. Minimum energy targets, ΔTmin = 10 K.**

| Quantity | 1 t/h (kW) | Category 1 (kW) | Category 1 (MWh/y) |
|:---|---:|---:|---:|
| Total heating demand (cold streams) | 645.2 | 179.2 | 645 |
| Total cooling demand (hot streams) | 815.8 | 226.6 | 816 |
| Minimum hot utility | 353.2 | 98.1 | 353 |
| Minimum cold utility | 523.8 | 145.5 | 524 |
| of which refrigeration (below 11 °C) | 337.5 | 93.7 | 337 |
| of which cooling above ambient | 186.3 | 51.8 | 186 |
| Maximum heat recovery | 292.0 | 81.1 | 292 |
| Pinch temperature (shifted) | 37 °C | 37 °C |  |

*Category-1 annual energy = kW at category 1 × 3,600 h. The pinch at 37 °C shifted corresponds to 42 °C on hot streams and 32 °C on cold streams.*

## 7. Data basis

**Table 5. Origin of the data.**

| Data | Source |
|:---|:---|
| Process steps and temperatures | Bhadbhade et al. (2023), Figure 3; Bhadbhade et al. (2024) |
| Thermal streams (Table 3) | Bhadbhade et al. (2024), supplementary Appendix 6: Swiss sector stream loads (MWh/y) divided by 200,000 t/y of chocolate; nibs-roasting and infrared-drying streams removed; refrigeration-plant streams replaced by the production-cooling demand H11 |
| Production cooling H11: 337.5 kW, 11 to 5 °C | Refrigeration heat rejection of Appendix 6 (427.2 kWh/t) × COP / (1 + COP), cooling COP 3.76; COP and 5/11 °C chilled water measured at a Swiss chocolate factory (Arpagaus and Bertsch, 2020) |
| Operating hours and plant size | Bhadbhade et al. (2024), supplementary Table A2; Bhadbhade et al. (2023), Table 2 |
| Recipe and liquor fat content (54 %) | Ozdemir et al. (2026) |
| Bean moisture 6.5 % raw, 2 % roasted | Sandoval et al. (2019); Beckett (2018) as cited by Elianarni et al. (2025) |
| Bean intake 0.263 t/t chocolate | Swiss cocoa grindings (55,000 t) over chocolate sales (209,096 t), CHOCOSUISSE (2025) |
| Shell fraction 12 %, press-cake fat 11 % | Assumed values within reported ranges: shells 10 to 17 % (Rojo-Poveda et al., 2020); cake 10 to 12 % fat (commercial grade) |
| Final energy and carrier shares | Bhadbhade and Patel (2020); Bhadbhade et al. (2023), Figure 1 |
| Air cp 1.89 kJ/(kg K); steam latent heat | Bhadbhade et al. (2024), Table 2; steam tables |

## References

1. Arpagaus C., Bertsch S. (2020). *Industrial heat pumps in Switzerland: application potentials and case studies*. Swiss Federal Office of Energy. <https://www.aramis.admin.ch/Default?DocumentID=66033&Load=true>
2. Bhadbhade N., Ong B.H.Y., Olsen D.G., Wellig B., Patel M.K. (2023). *Exemplary energy profiles for chocolate and cocoa production*. SWEET DeCarbCH Deliverable D4.3.1, Swiss Federal Office of Energy.
3. Bhadbhade N., Ong B.H.Y., Olsen D.G., Wellig B., Patel M.K. (2024). Assessment of CO2 abatement potential of heat pumps using pinch analysis for the Swiss chocolate industry. *Journal of Cleaner Production* 455, 142323, and supplementary material. <https://doi.org/10.1016/j.jclepro.2024.142323>
4. Bhadbhade N., Patel M.K. (2020). Analysis of energy efficiency improvement and carbon dioxide abatement potentials for Swiss Food and Beverage sector. *Resources, Conservation and Recycling* 161, 104967. <https://doi.org/10.1016/j.resconrec.2020.104967>
5. CHOCOSUISSE (2025). *Bulletin 2025, business year 2024*. <https://www.chocosuisse.ch>
6. Elianarni D., Pracoyo M.A., Damat (2025). Roasting time optimization for fermented cocoa beans. *BIO Web of Conferences* 201, 05009. <https://doi.org/10.1051/bioconf/202520105009>
7. Ong B.H.Y., Bhadbhade N., Olsen D.G., Wellig B. (2023). Characterizing sector-wide thermal energy profiles for industrial sectors. *Energy* 282, 129028. <https://doi.org/10.1016/j.energy.2023.129028>
8. Ozdemir O., Keskin-Cavdar H., Polat S., Unal M.U. (2026). Influence of cocoa liquor origin on cocoa butter composition and color, texture, and rheological properties of milk and dark chocolates. *Food Science & Nutrition* 14(8), e72130. <https://doi.org/10.1002/fsn3.72130>
9. Rojo-Poveda O., Barbosa-Pereira L., Zeppa G., Stévigny C. (2020). Cocoa bean shell: a by-product with nutritional properties and biofunctional potential. *Nutrients* 12(4), 1123. <https://doi.org/10.3390/nu12041123>
10. Sandoval A.J. et al. (2019). Composition and thermogravimetric characterization of components of Venezuelan fermented and dry Trinitario cocoa beans. *Revista Técnica de la Facultad de Ingeniería, Universidad del Zulia* 42(1), 39 to 47.
