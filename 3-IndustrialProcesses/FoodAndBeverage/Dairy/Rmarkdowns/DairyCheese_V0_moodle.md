# Dairy plant V0: cheese only, whey leaves the site

*Process data for mass and heat integration: rs and qt tables*

## 1. Process

The plant receives fresh milk and produces cream and cheese. The whey separated in evaporation and cheese making leaves the site without further processing, for example as animal feed.

Process steps and conditions:

1. Reception: raw milk is cooled from 6 to 4 °C and stored.
2. Pasteurisation: the milk is heated to 75 °C with regenerative heat exchange; the cream is separated by centrifugation at about 60 °C; the pasteurised skimmed milk is cooled back to 4 °C.
3. Evaporation: the skimmed milk is preheated to 70 °C and concentrated in three effects boiling at about 70, 65 and 60 °C. Steam heats the first effect; the vapour of each effect heats the next one, and the vapour of the last effect is condensed. A diluted whey stream and a wastewater stream are also separated.
4. Cheese making: the concentrated milk is heated to 56 °C and cultures are added; curd and whey are separated; the curd is cooled to 16 °C and brined with salt and water at about 13 °C.
5. Cleaning in place (CIP): water is heated to 80 °C, circulated through the equipment and returned at 75 °C; about 70 % is reused and the rest is cooled to 30 °C and discharged.
6. Wastewater treatment: brine, evaporator wastewater and product losses are treated; a sludge is separated.
7. Whey: the diluted whey (4 °C) and the concentrated whey (56 °C) leave the site.

## 2. Basis and conventions

- **Reference flow:** 1 t/h of fresh milk. At this basis, a heat load in kW equals the specific energy in kWh per tonne of milk, and a mass flow in kg/h equals kg per tonne of milk.
- **Reference plant:** 28.8 t/h of fresh milk (about 28 m³/h), operated 8,760 h per year. Columns labelled "plant" are the 1 t/h values multiplied by 28.8.
- **Heat integration:** ΔTmin/2 = 5 K for liquid streams and 2 K for condensing and boiling streams, as given in Table 3 for each stream.
- Streams that change phase at constant temperature are given a span of 0.1 K. Very small mixing streams of the source model are lumped together.
- **Utilities are not part of the process data:** steam, hot water, refrigeration, cooling towers and cooling water are supplied by the utility system you design. Refrigeration demands appear as hot streams at the product temperature.

![Block flow diagram of the dairy plant](dairy_V0_flowsheet.png)

*Figure 1. Block flow diagram of variant V0, mass flows in kg/h per 1 t/h of fresh milk.*

## 3. rs: material flows

**Table 1. Material flows, per 1 t/h of fresh milk.**

| Stream | Flow (kg/h) | T (°C) |
|:---|---:|:---|
| **Raw materials and inputs (in)** |  |  |
| Fresh milk | 1,000.0 | 6 |
| Salt | 6.1 | 25 |
| Water for brining | 31.2 | 12 |
| Water for cleaning (CIP) | 150.0 | 25 |
| **Total in** | **1,187.3** |  |
| **Products, by-products and discharges (out)** |  |  |
| Cream | 59.5 | 4 |
| Cheese | 70.3 | 13 |
| Diluted whey (to external use) | 189.3 | 4 |
| Concentrated whey (to external use) | 109.4 | 56 |
| Evaporator condensate water | 448.5 | 65 |
| Treated water discharge | 155.7 | 20 |
| CIP water discharge | 150.0 | 30 |
| Sludge from wastewater treatment | 4.8 | 20 |
| **Total out** | **1,187.3** |  |
| **Internal flows** |  |  |
| Skimmed milk to evaporation | 940.5 | 4 |
| Concentrated milk to cheese making | 176.5 | 4 |
| Concentrated milk losses to wastewater | 3.6 | 4 |
| Brine to wastewater treatment | 34.2 | 13 |
| Evaporator wastewater to treatment | 122.6 | 4 |

*Inputs and outputs close at 1,187.3 kg/h. The concentrated-milk losses are the difference between the evaporator output and the cheese-making input; they are sent to wastewater treatment.*

## 4. rs: process electricity

Table 2 lists the electricity that the cheese line consumes. It is derived from sector data for Dutch cheese dairies, because the process model gives no electricity use. Refrigeration is excluded: it is a utility, and its demand appears as hot streams in Table 3.

**Table 2. Process electricity demand, per 1 t/h of fresh milk.**

| Item | kW at 1 t/h | Basis |
|:---|---:|:---|
| Electric drives: separator, pumps, agitators, curd and cheese handling, CIP pumps | 5.37 | 16 % of the primary energy of cheese production |
| Compressed air | 1.68 | 5 % of the primary energy of cheese production |
| **Total process electricity** | **7.05** | **203 kW for the plant, 1,780 MWh/y** |
| For comparison only: refrigeration compressors (not part of the process data) | 6.38 | 19 % of the primary energy of cheese production |

*Derivation: the reference specific energy use of cheese production is 4.3 GJ of primary energy per tonne of cheese (Ramírez et al., 2006, Table 7). Electricity is taken as 40 % of it, the sector-wide share stated by the same authors, and converted back to final electricity with their factor of 2.5: 191 kWh per tonne of cheese. Cooling (19 %) and compressed air (5 %) are the cheese-production shares given by Ramírez et al. (2006, Table 4) and are assumed to be entirely electric; the rest of the electricity is assigned to drives. With 70.3 kg of cheese per tonne of milk, the process electricity is 100 kWh/t of cheese, or 7.05 kWh/t of milk.*

*The refrigeration line is given for comparison only: it is the electricity that refrigeration (including cold storage) needed in the reference dairies, against which you can compare the refrigeration plant you design.*

## 5. qt: thermal streams

**Table 3. Thermal streams of variant V0. Q and mCp per 1 t/h of fresh milk; operating time 8,760 h/y.**

| ID | Stream | Tin (°C) | Tout (°C) | Q, 1 t/h (kW) | mCp, 1 t/h (kW/K) | ΔTmin/2 (K) | Q, plant (kW) |
|:---|:---|---:|---:|---:|---:|---:|---:|
| **Cold streams (to be heated)** |  |  |  |  |  |  |  |
| C1 | Pasteurisation: Fresh milk heating to pasteurisation | 4 | 75 | 76.38 | 1.076 | 5 | 2,200 |
| C2 | Evaporation: Skimmed milk preheating | 4 | 70.2 | 45.19 | 0.683 | 5 | 1,302 |
| C3 | Evaporation: Effect 1, boiling (steam-heated) | 70.2 | 70.3 | 122.01 | 1,220 | 2 | 3,514 |
| C4 | Evaporation: Effect 2, boiling | 65.3 | 65.6 | 102.32 | 341.065 | 2 | 2,947 |
| C5 | Evaporation: Effect 3, boiling | 60.7 | 61.3 | 64.27 | 107.124 | 2 | 1,851 |
| C6 | Cheese: Concentrated milk heating for curdling | 4 | 56 | 8.27 | 0.159 | 5 | 238 |
| C7 | Cheese: Brining water warming | 12 | 15.2 | 0.11 | 0.036 | 5 | 3 |
| C8 | CIP: Make-up water heating | 25 | 60 | 6.10 | 0.174 | 5 | 176 |
| C9 | CIP: Cleaning water heating | 60 | 80 | 11.63 | 0.581 | 5 | 335 |
|  | **Total cold streams** |  |  | **436.3** |  |  | **12,565** |
| **Hot streams (to be cooled)** |  |  |  |  |  |  |  |
| H1 | Pasteurisation: Raw milk cooling on reception | 6 | 4 | 2.18 | 1.092 | 5 | 63 |
| H2 | Pasteurisation: Pasteurised milk cooling | 75 | 4 | 73.13 | 1.030 | 5 | 2,106 |
| H3 | Evaporation: Effect 1 vapour, condensing | 70.2 | 69.1 | 122.15 | 111.042 | 2 | 3,518 |
| H4 | Evaporation: Effect 2 vapour, condensing | 65.6 | 65 | 104.58 | 174.300 | 2 | 3,012 |
| H5 | Evaporation: Effect 3 vapour, condensing | 61.3 | 60.1 | 65.61 | 54.673 | 2 | 1,890 |
| H6 | Evaporation: Condensate cooling | 69.9 | 25 | 21.19 | 0.472 | 5 | 610 |
| H7 | Evaporation: Concentrated milk cooling | 61.3 | 4 | 9.32 | 0.163 | 5 | 268 |
| H8 | Cheese: Curd and whey cooling | 56 | 16 | 2.19 | 0.055 | 5 | 63 |
| H9 | Cheese: Brining, cooling side (lumped) | 25 | 13 | 0.33 | 0.027 | 5 | 9 |
| H10 | CIP: Cleaning circuits, cooling | 80 | 75 | 2.91 | 0.582 | 5 | 84 |
| H11 | CIP: Returned water cooling before reuse | 75 | 60 | 6.11 | 0.407 | 5 | 176 |
| H12 | CIP: Spent water cooling before discharge | 75 | 30 | 7.84 | 0.174 | 5 | 226 |
|  | **Total hot streams** |  |  | **417.5** |  |  | **12,025** |

*mCp = Q / |Tout − Tin|. The evaporator is described effect by effect: each effect boils at one temperature and the vapour it produces condenses about 4 to 5 K higher in the next effect's heater, which is why phase-change streams use ΔTmin/2 = 2 K. Streams ending below about 20 °C need refrigeration unless another process stream absorbs their heat.*

## 6. Reference targets

Check your own problem-table or composite-curve calculation against these targets for the 21 streams of Table 3.

**Table 4. Minimum energy targets with the ΔTmin/2 values of Table 3.**

| Quantity | 1 t/h (kW) | Plant (kW) | Plant (MWh/y) |
|:---|---:|---:|---:|
| Total heating demand (cold streams) | 436.3 | 12,565 | 110,072 |
| Total cooling demand (hot streams) | 417.5 | 12,025 | 105,336 |
| Minimum hot utility | 146.5 | 4,219 | 36,956 |
| Minimum cold utility | 127.7 | 3,678 | 32,220 |
| of which below ambient (refrigeration) | 14.1 | 407 | 3,567 |
| Maximum heat recovery | 289.8 | 8,347 | 73,116 |
| Pinch temperature (shifted) | 67.3 °C | 67.3 °C |  |

*The pinch at 67.3 °C shifted lies in the evaporator, between the boiling of effect 1 and the condensation of its vapour. Plant annual energy = plant kW × 8,760 h. Refrigeration is the cold utility that must be supplied below 20 °C on hot streams when the rest of the cold utility is placed at the highest feasible temperature.*

## 7. Data basis

**Table 5. Origin of the data.**

| Data | Source |
|:---|:---|
| Stream temperatures, heat loads and mass flows of all units | DWSIM dairy model of Bhatnagar, Flórez-Orrego, Boztas and Dardor; Dardor et al. (2024); values of the latest MER runs |
| Normalisation to 1 t/h of fresh milk | Plant values divided by 28.8 t/h of fresh milk |
| Evaporator effect by effect; ΔTmin/2 = 2 K on condensing and boiling streams | Source model, with the condensing vapour of each effect grouped by effect |
| Process electricity of the cheese line: 4.3 GJ primary energy per t of cheese; electricity 40 % of primary energy, converted with a factor of 2.5; cooling (19 %) and compressed air (5 %) shares assumed fully electric; refrigeration excluded | Ramírez et al. (2006), Tables 4 and 7 and Section 5; electricity share and allocation are assumptions of this handout |
| Lumped streams (pasteurisation heating and cooling, small mixing streams, condensate cooling) | Sums of the source-model streams over their combined temperature range; origin listed in the workbook |
| Skimmed milk = fresh milk minus cream; evaporator condensate closes the evaporator balance | Mass balance |
| Concentrated-milk losses (difference between evaporator output and cheese-making input) to wastewater treatment | Mass balance; this closes the wastewater treatment balance |

## References

1. Dardor D., Flórez-Orrego D., Terrier C., Ribeiro Domingos M.E., Platteau C., da Silva J.C., Lopez M., Maréchal F. (2024). ROSMOSE: A web-based decision support tool for the design and optimization of industrial and urban energy systems. *Energy* 304, 132182. <https://doi.org/10.1016/j.energy.2024.132182>
2. Ramírez C.A., Patel M., Blok K. (2006). From fluid milk to milk powder: energy use and energy efficiency in the European dairy industry. *Energy* 31(12), 1984–2004. <https://doi.org/10.1016/j.energy.2005.10.014>
