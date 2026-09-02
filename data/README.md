# DAISY 2026 session data: green OpenAlex topics and the circular-economy id lists

Built 2026-08-18 by `_build\build_green_topics.py` (run from `session\_build`, Python 3.12, pandas). Rerun the script after any change to the term lists or to the hand overrides; it overwrites the four data files below.

## Files

| file | what it is | used by |
|---|---|---|
| `green_topics.csv` | 523 OpenAlex topics flagged green by the DATT 2026 pipeline, one row per topic, with `daisy_group` and `ce_core` added | notebooks (leg B), BigQuery upload if the group breakdown is wanted (leg C), slides |
| `ce_topic_ids.txt` | the circular-economy set, one bare id per line (`T10171`) | anything that reads a list |
| `ce_topic_ids_sql.txt` | the same ids as full URLs in a BigQuery array literal, ready to paste into `UNNEST([...])` | `sql\q01`, `q02`, `q03` (leg C) |
| `ce_topic_ids_api.txt` | the same bare ids joined by `|`, ready to paste after `primary_topic.id:` in an OpenAlex filter | VOSviewer request URL (leg A), openalexR / pyalex notebooks (leg B) |

Column layout of `green_topics.csv` (UTF-8, comma separated, header row):

| column | content |
|---|---|
| `topic_id` | bare OpenAlex topic id, `T10471` (what the REST API filter wants) |
| `topic_id_url` | full id, `https://openalex.org/T10471` (what BigQuery stores in `primary_topic.id` and `topics[].id`) |
| `topic_name` | OpenAlex topic display name |
| `subfield_name`, `field_name`, `domain_name` | the three upper levels of the OpenAlex topic hierarchy |
| `is_digital` | 1 if the DATT pipeline also flagged the topic as digital (a "twin" topic), else 0 |
| `daisy_group` | `circular_economy`, `climate_energy`, `environment_biodiversity`, `sustainability_policy`, `other_green` (rules below) |
| `ce_core` | 1 for the 28 topics in the circular-economy set, else 0 (`ce_core = 1` and `daisy_group = circular_economy` are the same thing) |
| `keywords` | the ten OpenAlex keywords of the topic, `;` separated (kept so the instructor can prune by eye) |

## Provenance

- `EISD\2026\DATT\material_for_students\oa_topics.csv` (file dated 21 April 2026): the full OpenAlex topic catalogue, 4,516 topics with subfield, field, domain, keywords, summary and Wikipedia URL. The topic taxonomy has counted 4,516 topics since OpenAlex released it in early 2024, and the 28 CE ids all resolved on the API on 2026-08-18 (counts below). TODO (instructor): the exact OpenAlex snapshot behind this export is not recorded anywhere in the DATT folder; note the date if it can be recovered, otherwise cite the file date. TODO (rehearsal): spot-check two or three topic names against `https://api.openalex.org/topics/T10471` in case display names were edited after April 2026.
- `EISD\2026\DATT\topics_green_digital.csv` (file dated 22 April 2026): output of the DATT class 6 notebook (`datt_class6_commented_notebook.ipynb`, section 5). That notebook lower-cases `topic_name + keywords + summary` and flags a topic as green when the text contains at least one of 20 phrases (renewable energy, solar energy, photovoltaic, wind energy, biofuel, climate change, greenhouse gas, carbon capture, decarboniz, circular economy, recycling, waste management, wastewater, water quality, biodiversity, sustainable development, life cycle assessment, air pollution, electric vehicle, energy efficien) and as digital with a parallel list of 20 phrases. Result: 864 topics, of which 523 green (474 green only, 49 green and digital) and 341 digital only.
- `green_topics.csv` keeps exactly the 523 rows with `is_green = 1` and merges in `domain_name`, `keywords` and `summary` from the catalogue (the merge is 1:1, no topic is lost). Nothing is added from outside the DATT green list; see "Circular-economy candidates outside the green list" for what that leaves out.

A caveat that matters for the slides: the DATT flag is a 20-phrase substring match on prose, meant as a class exercise. It sweeps in topics whose summary merely mentions "sustainable development" or "climate change" (Flannery O'Connor and Thomas Merton, Graphic Design and Typography, Semiconductor Quantum Structures and Devices, Belt and Road Initiative, and so on). The `daisy_group` rules below push most of those into `other_green`, but the 523 should be presented as "topics that a simple keyword rule calls green", not as a validated green classification. This is the same measurement point the theory hour makes about SDG classifiers (Kashnitsky et al. 2024; Ottaviani and Stahlschmidt 2024).

## Rules (readable version; the script is the authority)

All matching is on lower-cased text with Python regular expressions; `|` means OR inside a term, `\b` a word boundary. A "hit" is a distinct term of a list found in a text field, counted once however often it occurs.

### Rule 1: `ce_core` (circular economy)

A topic is `ce_core = 1` when at least one CE term appears in its **name**, or at least two distinct CE terms appear in its **keywords**. The summary is not used (it mentions recycling or waste in passing far too often). Before matching, a few false-friend phrases are blanked out: `photon recycling` (solar-cell physics), `nuclear waste`, `radioactive waste`, `adaptive reuse` (heritage buildings), `end-of-life care/issues/decision`, `palliative`.

CE terms (from `CE_TERMS` in the script):

`circular economy`, `circularity`, `recycl`, `waste management`, `solid waste`, `waste-to-energy`, `waste utilisation/utilization`, `waste valorisation/valorization`, `e-waste`, `electronic waste`, `plastic waste`, `food waste`, `organic waste`, `construction waste`, `household waste`, `waste reduction`, `waste materials`, `waste heat recovery`, `valorisation/valorization`, `remanufactur`, `refurbish`, `upcycl`, `industrial symbiosis`, `industrial ecology`, `eco-industrial`, `life cycle assessment`, `life cycle costing`, `life cycle analysis`, `lca`, `carbon footprint`, `water footprint`, `bioeconomy`, `biorefiner`, `bio-based`, `lignocellulos`, `biomass utilisation/valorisation/conversion`, `biochar`, `secondary raw material`, `industrial by-product(s)`, `by-product utilisation`, `bauxite residue`, `red mud`, `resource recovery`, `metal recovery`, `nutrient recovery`, `phosphorus recovery`, `struvite`, `resource efficiency`, `material flow`, `material efficiency`, `end-of-life`, `decommission`, `urban mining`, `critical raw material`, `compost`, `anaerobic digestion`, `biogas`, `wastewater reuse`, `water reuse`, `reuse of`, `eco-design`, `product-service system`, `sharing economy`, `extended producer responsibility`.

Hand overrides, applied after the rule and meant for pruning: `CE_MANUAL_EXCLUDE = ["T13804"]` (Physical Activity and Education Research: a junk cluster whose keywords happen to contain "recycled water use" and "waste management"); `CE_MANUAL_INCLUDE = []`; `CE_EXTRA_IDS = []` (ids from outside the green list to append to the three id files only). Add ids to these lists and rerun.

### Rule 2: `daisy_group` for everything that is not CE

Three term lists, one per group. For each group the score is `3 x (distinct terms in the name) + 2 x (distinct terms in the keywords) + 1 x (distinct terms in the summary)`. The group with the highest score wins; ties go to `sustainability_policy`, then `environment_biodiversity`, then `climate_energy` (so that "Sustainability and Climate Change Governance" lands in policy). A topic is `other_green` when its best score is 0, or below 4 without any hit in the name (one keyword plus one summary mention is not enough; one term in the name is).

`climate_energy` terms: `climate`, `global warming`, `greenhouse gas/effect`, `ghg`, `co2`, `carbon dioxide`, `carbon emission/capture/sequestration/neutral/pricing/tax/market/storage/footprint`, `sequestration`, `ccs`, `ccus`, `decarboni`, `emission`, `net zero`, `low carbon`, `energy transition`, `energy polic`, `energy security`, `energy efficien`, `energy storage/system/consumption/management/harvesting/saving/demand/market/conservation/poverty/access`, `renewable`, `solar`, `photovoltaic`, `wind energy/power/turbine/farm`, `geothermal`, `hydropower`, `biofuel`, `biodiesel`, `bioethanol`, `bioenergy`, `biomass`, `hydrogen`, `fuel cell`, `battery/batteries`, `electric vehicle`, `electric mobility`, `e-mobility`, `power system`, `power grid`, `smart grid`, `microgrid`, `power generation`, `power plant`, `nuclear energy/power`, `combustion`, `engine(s)`, `heat pump`, `refrigeration`, `cooling`, `thermal`, `building energy`, `cryospher`, `permafrost`, `glacier`, `sea level`, `cyclone`, `drought`, `heat island`, `paleoclimat`, `atmospher`.

`environment_biodiversity` terms: `biodiversity`, `ecolog`, `ecosystem`, `conservation`, `wildlife`, `species`, `habitat`, `forest`, `wetland`, `peatland`, `marine`, `coastal`, `ocean`, `fisher`, `coral`, `reef`, `soil`, `groundwater`, `watershed`, `hydrolog`, `river`, `lake`, `freshwater`, `water resource/quality/treatment/management/scarcity/purification/supply/use/governance/polic`, `wastewater`, `pollut`, `contaminat`, `remediation`, `air quality`, `particulate`, `toxic`, `ecotoxic`, `heavy metal`, `microplastic`, `pesticide`, `nutrient`, `land use`, `land degradation`, `deforestation`, `agricultur`, `agro`, `crop`, `livestock`, `plant`, `vegetation`, `botan`, `insect`, `entomolog`, `taxonom`, `fauna`, `flora`, `bird`, `avian`, `fish`, `amphibian`, `reptile`, `mammal`, `parasite`, `invasive`, `nature`, `landscape`, `protected area`, `environmental chemistry/monitoring/impact/quality/toxicology/health/science`, `green space`, `urban green`, `geolog`, `geochem`, `sediment`, `flood`, `erosion`, `phylogen`, `biogeograph`. Note that agriculture and agricultural economics fall here, not in policy.

`sustainability_policy` terms: `sustainab`, `sdg`, `agenda 2030`, `environmental policy/policies/law/regulation/governance/economics/management/education/ethics/justice/philosophy/accounting/reporting/disclosure/history/literature/humanities/movement/activism/attitude/awareness/behavio/participation`, `green economy/economics/growth/finance/bond/innovation/jobs/transition/deal/procurement/practices/building/infrastructure/technolog/product/consum/market/urbanism`, `esg`, `corporate social responsibility`, `csr`, `eco-innovation`, `ecological modernisation/transition/economics`, `pro-environmental`, `ecocritic`, `ecofeminis`, `anthropocene`, `degrowth`, `climate policy/policies/governance/finance/justice/adaptation/mitigation/action`, `natural resource`, `resource curse/governance/economics`, `food security`, `resilien`, `disaster`, `ecotourism`, `sustainable tourism`, `territorial governance`, `triple bottom line`, `water-energy-food`, `nexus`.

Bare words such as "policy", "governance", "development", "innovation", "management", "education" are deliberately absent from the policy list: with them, every DATT false positive scored as policy and `other_green` was empty.

## Counts (build of 2026-08-18)

| daisy_group | topics | of which is_digital = 1 |
|---|---|---|
| circular_economy | 28 | 0 |
| climate_energy | 114 | 16 |
| environment_biodiversity | 197 | 9 |
| sustainability_policy | 63 | 5 |
| other_green | 121 | 19 |
| **total** | **523** | **49** |

`other_green` is large (23%) because the DATT flag is loose; it holds education, generic economics, ICT engineering, materials science and area-studies clusters that carry "sustainable development" or "climate change" somewhere in their keywords or summary. Nothing in that bucket is used by the demo.

## The circular-economy set (28 topics), with names, for pruning

Work counts are from the OpenAlex REST API on 2026-08-18 (keyless call, `corpus=core` default), filter `primary_topic.id:<CE list>,type:article,publication_year:2016-2025`, grouped by `primary_topic.id`. Total for the set: **434,731 articles 2016-2025** (1,537,152 works of all types and years). Sorted by size.

| topic_id | topic_name | subfield | articles 2016-2025 | pruning note |
|---|---|---|---|---|
| T10753 | Microplastics and Plastic Pollution | Pollution | 50,051 | first candidate to drop: a pollution topic that enters through the keywords "waste management" and "recycling"; it is 11.5% of the set |
| T10171 | Biofuel production and bioconversion | Biomedical Engineering | 35,474 | bioeconomy (lignocellulosic biorefinery); drop if CE should exclude bioenergy |
| T10539 | Sustainable Supply Chain Management | Strategy and Management | 32,084 | keep: circular economy, remanufacturing, business models |
| T11091 | Extraction and Separation Processes | Mechanical Engineering | 31,160 | keep: battery recycling, metal recovery |
| T10264 | Asphalt Pavement Performance Evaluation | Civil and Structural Engineering | 27,674 | recycled materials + LCA; borderline |
| T14179 | Waste Management and Recycling | Waste Management and Disposal | 22,833 | keep |
| T12017 | Recycling and Waste Management Techniques | Waste Management and Disposal | 22,594 | keep (e-waste) |
| T10435 | Environmental Impact and Sustainability | Environmental Engineering | 21,414 | keep: LCA, footprints, input-output |
| T11108 | Municipal Solid Waste Management | Waste Management and Disposal | 18,537 | keep |
| T10284 | Anaerobic Digestion and Biogas Production | Building and Construction | 18,382 | keep (waste-to-energy) |
| T11847 | Recycled Aggregate Concrete Performance | Building and Construction | 17,159 | keep |
| T12920 | Healthcare and Environmental Waste Management | Public Health, Env. and Occupational Health | 14,436 | medical waste, COVID-19 heavy; borderline |
| T13045 | Industrial Engineering and Technologies | Mechanical Engineering | 14,182 | mineral-resource-sector cluster (summary: digital economy, resource efficiency and circular economy principles); borderline |
| T12186 | Phosphorus and nutrient management | Waste Management and Disposal | 13,959 | keep: nutrient recovery from wastewater (struvite) |
| T13180 | Chemistry and Chemical Engineering | Environmental Chemistry | 12,987 | green chemistry metrics, LCA; borderline |
| T11672 | Recycling and utilization of industrial and municipal waste in materials production | Building and Construction | 12,094 | keep |
| T11781 | Wastewater Treatment and Reuse | Waste Management and Disposal | 9,996 | keep (water reuse, resource recovery) |
| T11275 | Composting and Vermicomposting Techniques | Soil Science | 9,608 | keep |
| T13240 | Bioeconomy and Sustainability Development | General Agricultural and Biological Sciences | 8,018 | keep |
| T12118 | Forest Biomass Utilization and Management | Mechanics of Materials | 7,289 | bioeconomy; borderline |
| T12838 | Photovoltaic Systems and Sustainability | Environmental Engineering | 6,363 | PV LCA, recycling, end-of-life; borderline |
| T12774 | Bauxite Residue and Utilization | Mechanical Engineering | 5,967 | keep (red mud valorisation) |
| T14164 | Marine and Offshore Engineering Studies | Ocean Engineering | 5,608 | ship recycling, decommissioning; borderline |
| T13140 | Materials Engineering and Processing | Mechanical Engineering | 5,169 | foundry waste, industrial by-products in concrete; keep |
| T12746 | Sustainable Industrial Ecology | Industrial and Manufacturing Engineering | 5,086 | keep: industrial symbiosis |
| T13477 | Sustainable Design and Development | Building and Construction | 2,918 | keep |
| T13790 | Waste Management and Environmental Impact | Mechanical Engineering | 1,906 | coal waste, fly ash; keep |
| T14138 | Life Cycle Costing Analysis | Accounting | 1,783 | keep |

The set is below the 30-to-100 target the plan asked for. This is a property of the taxonomy, not of the rule: applied to all 4,516 topics the same rule finds only five more CE clusters (next section), and relaxing it to one keyword hit brings in polymer physics, cruise tourism and edible oils. Twenty-eight topics and 435k articles are plenty for the demo; the API OR-list stays far below the 100-value cap.

### Circular-economy candidates outside the DATT green list

The CE rule applied to the full catalogue also flags these five topics, which the DATT green regex missed (`is_green = 0`, so they are not in `green_topics.csv`). To use them in the demo, put their ids in `CE_EXTRA_IDS` in the script and rerun; they will be appended to the three id files only.

| topic_id | topic_name | subfield | keywords (first five) |
|---|---|---|---|
| T12583 | Food Waste Reduction and Sustainability | Food Science | Food Waste; Supply Chain; Household Behavior; Environmental Impact; Waste Reduction |
| T12392 | Sharing Economy and Platforms | Marketing | Sharing Economy; Collaborative Consumption; Peer-to-Peer Accommodation; Sustainability; Trust and Reputation |
| T11208 | Lignin and Wood Chemistry | Biomedical Engineering | Lignin Valorization; Catalytic Transformation; Renewable Chemicals; Biorefinery; Lignocellulose Fractionation |
| T10088 | Thermochemical Biomass Conversion Processes | Biomedical Engineering | Biomass; Pyrolysis; Bio-oil; Hydrothermal Carbonization; Gasification |
| T11009 | Catalysis for Biomass Conversion | Biomedical Engineering | Biomass; Catalytic Conversion; Renewable Resources; Platform Chemicals; Green Chemistry |

Food waste (T12583) and sharing economy (T12392) are the two that a CE economist would expect to see; the three biomass-chemistry ones are bioeconomy.

## How each leg of the demo uses these files

**Leg A, VOSviewer (1.6.21, "Download data through API" > OpenAlex > paste a request URL).** VOSviewer reads only the `search` and `filter` parameters of the URL and caps an analysis at about 50,000 works. The whole CE set is far above the cap even for a single recent year window (435k articles 2016-2025), so for VOSviewer use one topic or a title search, for example
`https://api.openalex.org/works?filter=primary_topic.id:T10539,type:article,publication_year:2020-2025` (Sustainable Supply Chain Management: check the count at rehearsal) or the plan's A1 URL `filter=title.search:circular%20economy,type:article,publication_year:2016-2025`. If a multi-topic map is wanted, paste a short subset of `ce_topic_ids_api.txt` (three or four ids) after `primary_topic.id:` and check `meta.count` first with the same URL in a browser.

**Leg B, OpenAlex API in Colab.** The whole set fits one filter value: paste the content of `ce_topic_ids_api.txt` after `primary_topic.id:` (28 ids joined by `|`; the API accepts up to 100 OR-ed values in one filter). openalexR: `oa_fetch(entity = "works", primary_topic.id = "T10171|T10264|...", publication_year = "2016-2025", type = "article", group_by = "publication_year")`; pyalex: `Works().filter(primary_topic={"id": "T10171|T10264|..."}, type="article", publication_year="2016-2025").group_by("publication_year").get()`. The same call with `group_by = "authorships.countries"` gives the geography (200-group cap of the API applies). For a green-versus-CE comparison, `green_topics.csv` gives the 523 green ids; split them into chunks of at most 100 ids per call.

**Leg C, BigQuery (`subugoe-collaborative.openalex_walden.works`, fallback `nber-i3.openalex.works_<date>`).** `primary_topic.id` holds the full URL, so paste `ce_topic_ids_sql.txt` as the array literal:

```sql
WITH ce AS (
  SELECT topic_id FROM UNNEST([
    'https://openalex.org/T10171', 'https://openalex.org/T10264', /* ... paste ce_topic_ids_sql.txt ... */
  ]) AS topic_id
)
SELECT w.publication_year, COUNT(*) AS n_articles
FROM `subugoe-collaborative.openalex_walden.works` AS w
JOIN ce ON w.primary_topic.id = ce.topic_id          /* Stata: merge m:1 topic_id using ce, keep(3) */
WHERE w.type = 'article' AND NOT w.is_xpac
GROUP BY w.publication_year                           /* Stata: collapse (count) n_articles, by(publication_year) */
ORDER BY w.publication_year;
```

For the group breakdown (all 523 topics by `daisy_group`), upload `green_topics.csv` to `arboreal-avatar-477416-i4.daisy.green_topics` from the console (auto-detect off, `topic_id_url STRING`, skip 1 header row, as in `__research\geography_of_science\RUNME_bigquery.md`) and join on `w.primary_topic.id = g.topic_id_url`. Numbers from leg B (API, `corpus=core`) and leg C (snapshot, `NOT is_xpac`) will differ by the xpac and snapshot-date gap; say so on the slide.

## Open points for the instructor

- CE set has 28 topics, under the 30-to-100 target; the five outside candidates above are the only way up without loosening the rule. Decide before the notebooks and SQL are frozen, since the ids are inlined there.
- Prune by hand: T10753 (microplastics) is the obvious one; the "borderline" rows are listed above. Edit `CE_MANUAL_EXCLUDE`, rerun, then re-paste the id lists into `sql\` and `notebook\`.
- OpenAlex snapshot date behind `oa_topics.csv` is not documented (TODO above); the ids resolve today, so this affects citation only.
- The 523-topic green list is a class exercise output; if it appears on a slide, present it as "keyword-flagged" and point to the `other_green` bucket as the illustration of why classifiers disagree.
