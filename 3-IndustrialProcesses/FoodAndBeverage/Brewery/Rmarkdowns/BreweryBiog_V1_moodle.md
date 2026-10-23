# Brewery V1: beer production with anaerobic digestion of the spent grains

*Process data for mass and heat integration: rs and qt tables*

## 1. Process

The brewery converts malt, corn and water into bottled beer. The spent grains separated in lautering are digested anaerobically on site to produce biogas.

Process steps and conditions:

1. Mashing: malt is mixed with water in the mash tun (MAT); malt and corn are mixed with water in the mash cooker (MAK). Both mashes are brought to 48 °C by the water, heated to 65 °C, combined and heated to 75 °C, while enzymes convert the starch into sugars.
2. Lautering: the mash is filtered with sparge water at 80 °C; the spent grains are separated from the wort.
3. Wort boiling: the wort is heated to 105 °C and boiled with hops for about one hour; 10 % of the wort is evaporated and leaves as vapour.
4. Whirlpool and wort cooling: make-up water at 80 °C is added and the trub (coagulated proteins, 0.2 % of the wort) is removed in a centrifuge; the wort leaves at 102.5 °C and is cooled to 10 °C.
5. Fermentation and maturation: the wort ferments at 10 °C for 14 days; the heat of fermentation (37.14 kJ per litre of wort) must be removed. The beer is then cooled to 6 °C and matured for 10 days. The CO2 produced leaves the process.
6. Chillage and filtration: the beer is cooled to 1 °C and held so that the yeast settles, then filtered.
7. Dilution and pasteurisation: the concentrated beer is warmed to 15 °C and diluted with water at 15 °C; the beer is heated to 70 °C, held, and cooled to 5 °C before storage and filling.
8. Cleaning in place (CIP): water is heated to 80 °C and sent to clean the tanks; it is not recovered.
9. Bottle washing: returnable bottles pass through a pre-rinse bath (kept at 60 °C), a soda bath (85 °C) and a final rinse with fresh water. The final-rinse water is reused in the pre-rinse; the water leaving the pre-rinse at 40 °C is cooled to 20 °C and sent to wastewater treatment.
10. Anaerobic digestion: the spent grains (75 °C) are fed to a mesophilic digester at 35 °C, which produces biogas and a digestate.

## 2. Basis and conventions

- **Reference flow:** 1 t/h of beer (about 9.9 hl/h). At this basis, a heat load in kW equals the specific energy in kWh per tonne of beer, and a mass flow in kg/h equals kg per tonne of beer.
- **Reference plant:** 68.7 t/h of beer, operated 8,760 h per year, that is 601,685 t of beer per year. Columns labelled "plant" are the 1 t/h values multiplied by 68.7.
- **Heat integration:** ΔTmin/2 = 5 K for liquid streams and 2 K for the evaporation of the wort and the condensation of its vapour, as given in Table 3 for each stream.
- Streams that change phase or release heat at constant temperature are given a span of 0.1 K. Small streams of the source data that cover the same temperature range are lumped together.
- **Utilities are not part of the process data:** steam, hot water, the glycol-water loop, the ammonia refrigeration plant and cooling water are supplied by the utility system you design. Fermentation, maturation and chilling appear as hot streams at the beer temperature.

![Block flow diagram of the brewery](brewery_V1_flowsheet.png)

*Figure 1. Block flow diagram of variant V1, mass flows in kg/h per 1 t/h of beer.*

## 3. rs: material flows

**Table 1. Material flows, per 1 t/h of beer.**

| Stream | Flow (kg/h) | T (°C) |
|:---|---:|:---|
| **Raw materials and inputs (in)** |  |  |
| Malt | 139.9 | 15 |
| Corn (adjunct) | 11.5 | 15 |
| Water for mashing (MAK and MAT) | 388.2 | 15 |
| Sparge water | 309.9 | 15 |
| Make-up water at the whirlpool | 72.8 | 15 |
| Dilution water | 237.3 | 15 |
| Water for cleaning in place | 354.7 | 15 |
| Soda (NaOH) for bottle washing | 20.0 | 15 |
| Water for bottle washing (soda bath, pre-rinse, final rinse) | 438.1 | 15 |
| **Total in** | **1,972.4** |  |
| **Products, by-products and discharges (out)** |  |  |
| Beer | 1,000.0 | 5 |
| Biogas (55 vol % CH4) | 7.0 | 35 |
| Digestate | 32.8 | 35 |
| Vapour from wort boiling | 81.0 | 100 |
| Trub | 1.6 | 100 |
| CO2 from fermentation | 37.3 | 10 |
| Hot water to cleaning in place | 354.7 | 80 |
| Bottle-washing wastewater | 458.1 | 20 |
| **Total out** | **1,972.4** |  |
| **Internal flows** |  |  |
| Mash to lautering | 539.6 | 75 |
| Wort to boiling | 809.8 | 78 |
| Wort to fermentation | 800.0 | 10 |
| Concentrated beer to dilution | 762.7 | 1 |
| Spent grains to the digester | 39.7 | 75 |

*Inputs and outputs close at 1,972.4 kg/h. The dilution water closes the balance: it is 31 % of the concentrated beer, because the CO2 released in fermentation is subtracted from the wort. Hops are not quantified in the source and are neglected. The biogas contains 55 vol % methane; the digestate is the rest of the spent grains.*

## 4. rs: process electricity

Table 2 lists the electricity used by the process. It is derived from sector data for large breweries, because the source model gives only the electricity of the refrigeration compressors. Refrigeration and the boiler house are excluded: they belong to the utility system, and the refrigeration demand appears as hot streams in Table 3.

**Table 2. Process electricity demand, per 1 t/h of beer.**

| Item | kW at 1 t/h | Share of brewery electricity |
|:---|---:|:---|
| Packaging (filling, labelling, conveyors) | 21.67 | 25 % (range in the source: 15 to 35 %) |
| Compressed air | 8.67 | 10 % (range in the source: 10 %) |
| Brewhouse (mill, pumps, agitators, lauter tun) | 6.50 | 7.5 % (range in the source: 5 to 10 %) |
| Lighting | 5.20 | 6 % (range in the source: 6 %) |
| Other (pumps, ventilation, wastewater) | 17.34 | 20 % (range in the source: 10 to 30 %) |
| Anaerobic digestion (feeding, mixing, gas handling) | 1.18 | 4 % of the methane LHV (Maréchal et al., 2013) |
| **Total process electricity** | **60.57** | **4,160 kW for the plant, 36,441 MWh/y** |
| For comparison only: refrigeration compressors (utility, not process data) | 30.34 | 35 % (range in the source: 30 to 40 %) |
| For comparison only: boiler house (utility, not process data) | 4.33 | 5 % |

*Derivation: large breweries use 7.5 to 11.5 kWh of electricity per hectolitre of beer (IFC, 2007, from EC, 2006); the midpoint, 9.5 kWh/hl, with an assumed beer density of 1.01 kg/L, gives 94.1 kWh per tonne of beer. It is split with the midpoints of the shares reported by Galitsky et al. (2003, Table 4), normalised to 100 % because the midpoints add up to 108.5 %. The benchmark, the density and the use of midpoints are assumptions of this handout; the shares come from a survey of UK breweries.*

## 5. qt: thermal streams

**Table 3. Thermal streams of variant V1. Q and mCp per 1 t/h of beer; operating time 8,760 h/y.**

| ID | Stream | Tin (°C) | Tout (°C) | Q, 1 t/h (kW) | mCp, 1 t/h (kW/K) | ΔTmin/2 (K) | Q, plant (kW) |
|:---|:---|---:|---:|---:|---:|---:|---:|
| **Cold streams (to be heated)** |  |  |  |  |  |  |  |
| C1 | Mashing: Water to the mash cooker (MAK) | 15 | 51.5 | 5.39 | 0.148 | 5 | 370 |
| C2 | Mashing: Water to the mash tun (MAT) | 15 | 54.5 | 11.99 | 0.304 | 5 | 824 |
| C3 | Mashing: Mash heating in MAK and MAT (lumped) | 48 | 65 | 8.86 | 0.521 | 5 | 609 |
| C4 | Mashing: Combined mash heating | 65 | 75 | 5.36 | 0.536 | 5 | 368 |
| C5 | Lautering: Sparge water heating | 15 | 80 | 23.42 | 0.360 | 5 | 1,609 |
| C6 | Wort boiling: Wort heating to boiling | 78 | 105 | 24.21 | 0.897 | 5 | 1,663 |
| C7 | Wort boiling: Wort boiling, water evaporation | 105 | 105.1 | 48.33 | 483.334 | 2 | 3,320 |
| C8 | Whirlpool: Make-up water heating | 15 | 80 | 5.50 | 0.085 | 5 | 378 |
| C9 | CIP: Hot water for cleaning in place | 15 | 80 | 26.80 | 0.412 | 5 | 1,841 |
| C10 | Beer treatment: Concentrated beer warming before dilution | 1 | 15 | 11.41 | 0.815 | 5 | 784 |
| C11 | Beer treatment: Pasteurisation heating | 15 | 70 | 59.80 | 1.087 | 5 | 4,107 |
| C12 | Bottle washing: Soda bath heating | 65 | 85 | 3.67 | 0.183 | 5 | 252 |
| C13 | Bottle washing: Pre-rinse bath heating | 40 | 60 | 6.88 | 0.344 | 5 | 473 |
| C14 | Bottle washing: Soda bath make-up, water and soda (lumped) | 15 | 85 | 19.32 | 0.276 | 5 | 1,327 |
| C15 | Bottle washing: Pre-rinse make-up water heating | 15 | 60 | 0.43 | 0.009 | 5 | 29 |
| C16 | Bottle washing: Final rinse water heating | 35 | 60 | 5.81 | 0.233 | 5 | 399 |
| C17 | Digestion: Digester at 35 C (heat demand) | 35 | 35.1 | 5.91 | 59.120 | 5 | 406 |
|  | **Total cold streams** |  |  | **273.1** |  |  | **18,759** |
| **Hot streams (to be cooled)** |  |  |  |  |  |  |  |
| H1 | Wort boiling: Boiling vapour, condensation (with desuperheating) | 100.1 | 100 | 51.03 | 510.312 | 2 | 3,505 |
| H2 | Wort boiling: Vapour condensate cooling | 100 | 25 | 7.03 | 0.094 | 5 | 483 |
| H3 | Wort cooling: Wort cooling to pitching temperature | 102.5 | 10 | 79.12 | 0.855 | 5 | 5,435 |
| H4 | Fermentation: Fermentation at 10 C (heat of fermentation) | 10 | 9.9 | 7.79 | 77.862 | 5 | 535 |
| H5 | Maturation: Cooling to maturation temperature | 10 | 6 | 3.40 | 0.851 | 5 | 234 |
| H6 | Maturation: Maturation at 6 C | 6 | 5.9 | 6.19 | 61.949 | 5 | 426 |
| H7 | Chillage: Beer chilling | 6 | 1 | 10.40 | 2.080 | 5 | 714 |
| H8 | Chillage: Chillage at 1 C | 1 | 0.9 | 6.23 | 62.269 | 5 | 428 |
| H9 | Beer treatment: Pasteurised beer cooling | 70 | 5 | 70.73 | 1.088 | 5 | 4,858 |
| H10 | Bottle washing: Soda bath rinse water cooling | 85 | 60 | 6.88 | 0.275 | 5 | 473 |
| H11 | Bottle washing: Pre-rinse water to wastewater, cooling | 40 | 20 | 10.39 | 0.520 | 5 | 714 |
| H12 | Digestion: Spent grains cooling to digester temperature | 75 | 35 | 0.79 | 0.020 | 5 | 55 |
|  | **Total hot streams** |  |  | **260.0** |  |  | **17,858** |

*mCp = Q / |Tout − Tin|. The wort boils at 105 °C, while its vapour condenses at 100 °C: the vapour of the boiling cannot heat the boiling itself without raising its temperature. Streams ending below about 20 °C need refrigeration unless another process stream absorbs their heat. The hot water for cleaning in place leaves the system at 80 °C and is not recovered.*

## 6. Biogas use options

The biogas leaves the digester as a resource stream. You may either burn it in a cogeneration engine or upgrade it to biomethane with membranes and export it to the gas grid. Both are utility options: compare them with the other utilities you consider.

**Table 4. Biogas use options, per 1 t/h of beer.**

| Quantity | Cogeneration engine | Membrane upgrading and export |
|:---|---:|---:|
| Methane in the biogas (Nm³/h) | 2.98 | 2.98 |
| Methane energy, LHV (kW) | 29.56 | 29.56 |
| Electricity produced (+) or used (−) (kW) | 8.87 | −1.14 |
| Heat in flue gas, 470 to 90 °C (kW) | 9.20 | 0 |
| Heat in engine cooling water, 87 to 80 °C (kW) | 6.18 | 0 |
| Biomethane exported (kW) | 0 | 29.56 |

*75 Nm³ of methane per tonne of spent grains, LHV 35.7 MJ/Nm³. Engine efficiencies: 30.0 % electricity, 31.1 % flue-gas heat and 20.9 % cooling-water heat (Maréchal et al., 2013, Table 27.10). Membrane upgrading uses 0.21 kWh per Nm³ of biogas, with 55 vol % methane in the biogas; the methane is assumed to be exported entirely. The electricity of the digester itself is in Table 2.*

## 7. Reference targets

Check your own problem-table or composite-curve calculation against these targets for the 29 streams of Table 3.

**Table 5. Minimum energy targets with the ΔTmin/2 values of Table 3.**

| Quantity | 1 t/h (kW) | Plant (kW) | Plant (MWh/y) |
|:---|---:|---:|---:|
| Total heating demand (cold streams) | 273.1 | 18,759 | 164,326 |
| Total cooling demand (hot streams) | 260.0 | 17,858 | 156,438 |
| Minimum hot utility | 72.9 | 5,008 | 43,866 |
| Minimum cold utility | 59.8 | 4,107 | 35,977 |
| of which below ambient (refrigeration) | 51.6 | 3,541 | 31,020 |
| Maximum heat recovery | 200.2 | 13,751 | 120,460 |
| Pinch temperature (shifted) | 20 °C | 20 °C |  |

*The pinch at 20 °C shifted (15 °C on the cold side, 25 °C on the hot side) is set by the fresh water entering at 15 °C. The grand composite curve also comes close to zero at 98 °C shifted, between the boiling of the wort and the condensation of its vapour. Plant annual energy = plant kW × 8,760 h. Refrigeration is the cold utility that must be supplied below 20 °C on hot streams when the rest of the cold utility is placed at the highest feasible temperature.*

## 8. Data basis

**Table 6. Origin of the data.**

| Data | Source |
|:---|:---|
| Stream temperatures, heat loads and flows of the brewery | Maréchal et al. (2013), Table 27.5 and Figs 27.3 to 27.7; same plant as the brewery model simulated in DWSIM by Bhatnagar, Flórez-Orrego and Boztas (Bhatnagar et al., manuscript) |
| Normalisation to 1 t/h of beer | Source values divided by 68.7 t/h of beer (19.08 kg/s) |
| Operating time 8,760 h/y | Brewery model of Bhatnagar et al. (manuscript); the source uses 8,180 h/y |
| Pasteurisation heated from 15 to 70 °C and cooled from 70 to 5 °C | Source text; the source stream table heats to 80 °C. The source mCp is kept |
| Whirlpool make-up water 15 to 80 °C, load recomputed (1.389 kg/s × 4.186 kJ/kgK × 65 K) | Mass balance; the source load (857.9 kW from 52 °C) is not consistent with its own flow. The recomputed load reproduces the source wort temperature of 102.5 °C |
| Soda-bath make-up water 4.388 kg/s | Soda-bath outflow (4.770 kg/s) minus soda; consistent with the source load of 1,287.1 kW |
| CO2 0.0373 kg per kg of beer; concentrated beer = wort minus CO2; dilution water closes the balance | Maréchal et al. (2013), Table 27.1; mass balance. The warming of the concentrated beer is scaled to its flow after CO2 release |
| Malt and corn from the solids of the MAK and MAT mash flows; vapour 10 % of the wort; trub by difference (0.2 % of the wort) | Maréchal et al. (2013), Table 27.5 and text; mass balance |
| Process electricity: 9.5 kWh/hl, shares of Table 4, refrigeration and boiler house excluded | IFC (2007); Galitsky et al. (2003); midpoints and beer density 1.01 kg/L are assumptions of this handout |
| Methane yield 75 Nm³/t, LHV 35.7 MJ/Nm³; digester heat 20 % and electricity 4 % of the LHV; spent grains cooled from 75 to 35 °C (cp 1.8 kJ/kgK); engine efficiencies | Maréchal et al. (2013), Section 27.4.2 and Table 27.10; methane yield from ADEME (2011) as cited there |
| Biogas 55 vol % CH4; membrane upgrading 0.21 kWh/Nm³ of biogas | Assumption (same value as the dairy case); Bauer et al. (2013) |

## References

1. ADEME (2011). *Méthanisation à la ferme: guide pratique*. Technical report, ADEME, France (in French); cited by Maréchal et al. (2013) for the methane yield of spent grains.
2. Bauer F., Hulteberg C., Persson T., Tamm D. (2013). *Biogas upgrading: review of commercial technologies*. SGC Rapport 270, Svenskt Gastekniskt Center. <http://www.sgc.se/ckfinder/userfiles/files/SGC270.pdf>
3. Galitsky C., Martin N., Worrell E., Lehman B. (2003). *Energy efficiency improvement and cost saving opportunities for breweries: an ENERGY STAR guide for energy and plant managers*. Report LBNL-50934, Lawrence Berkeley National Laboratory. <https://escholarship.org/uc/item/17r6j759>
4. IFC (2007). *Environmental, health, and safety guidelines for breweries*. International Finance Corporation, World Bank Group. <https://www.ifc.org/content/dam/ifc/doc/2000/2007-breweries-ehs-guidelines-en.pdf>
5. Maréchal F., Sachan A.K., Salgueiro L. (2013). Application of process integration methodologies in the brewing industry. In: Klemeš J.J. (Ed.), *Handbook of Process Integration (PI): Minimisation of Energy and Water Use, Waste and Emissions*. Woodhead Publishing, Cambridge, pp. 820–863. <https://doi.org/10.1533/9780857097255.5.820>

## Further reading for students

Studies of utility integration in breweries (cogeneration, heat pumps, refrigeration), useful once you have your targets:

- Bhatnagar P., Flórez-Orrego D., Boztas O., Ribeiro Domingos M., Margni M., Maréchal F. *Decarbonizing breweries and distilleries through integrated process and energy system optimization*. Manuscript, EPFL IPESE.
- Dumbliauskaite M., Becker H., Maréchal F. (2010). Utility optimisation in a brewery process based on energy integration methodology. *Proceedings of ECOS 2010*, Lausanne, Switzerland.
