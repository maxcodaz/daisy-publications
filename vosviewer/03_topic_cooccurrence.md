# Map 3. Topic co-occurrence: Italian SDG-13 publications, 2020 to 2025

VOSviewer 1.6.21, bibliographic-data route, using the topic co-occurrence unit available for OpenAlex data since version 1.6.21.

## Question

Which research topics travel together in Italian climate-action (SDG 13) publications? Each work carries up to three OpenAlex topics; two topics are linked when they are assigned to the same work. The map shows the sub-communities of the national portfolio, and how far the economics and management topics sit from the natural-science core.

## Request URL

```
https://api.openalex.org/works?filter=authorships.countries:IT,sustainable_development_goals.id:https://openalex.org/sdgs/13,publication_year:2020-2025
```

In September 2026 this returned about **24,800 works**, under the 50,000 cap. Adding `type:article` shrinks it further if needed. The filters are plain (no text search), so the download is billed at the cheap list rate.

## Click path (VOSviewer 1.6.21)

1. **File** tab, **Create**.
2. Choose type of data: **Create a map based on bibliographic data**. Next.
3. Choose data source: **Download data through API**. Next.
4. Choose API: **OpenAlex**. Next.
5. Choose the **API request URL** option, paste the URL above, and paste your API key in the key field. Next; the download of about 25,000 works runs.
6. Type of analysis **Co-occurrence**; unit of analysis **Topics**; counting method **Full counting**.
7. Threshold: minimum number of occurrences of a topic. **100** gives the 126-topic map used in class; the default of 10 gives an exhaustive but unreadable one.
8. Keep the topics VOSviewer proposes. Finish.
9. Look at **Network Visualization** for the sub-communities, then **Overlay Visualization** with Scores set to **Avg. norm. citations** (which parts of the portfolio are well cited) or **Avg. pub. year** (which are growing).

In one line: bibliographic data; OpenAlex; request URL; co-occurrence; topics; full counting; min. occurrences 100; overlay by average normalised citations.

## How to read the map (September 2026 build, 126 topics, 11 clusters)

Node size is the number of works carrying the topic (34,361 topic assignments over the 126 topics), a link is co-assignment to the same work. The two largest nodes are **climate variability and models** (1,832 works) and **meteorological phenomena and simulations** (1,338), which also form the strongest link of the map (902); then **flood risk assessment and management** (1,124), **landslides and related hazards** (1,044), cryospheric studies (992), atmospheric gas dynamics (828) and **climate change policy and economics** (727).

The clusters, from the largest by number of works:

- **Climate modelling and cryosphere** (13 topics, 6,285 occurrences): climate variability and models, meteorology, cryosphere, cyclones, permafrost, wind, polar ice.
- **Hydrogeological risk** (14 topics, 4,994): flood risk, landslides, hydrology and watersheds, drought, precipitation, soil moisture, soil erosion, dam safety. This is the most recognisably Italian region of the map.
- **Climate policy, economics and society** (19 topics, 4,277): climate change policy and economics, impacts on agriculture, communication and perception, governance, adaptation and migration, sustainable finance and green bonds, energy-environment-growth, market dynamics and volatility, environmental education. Cited above the map average (1.56 against 1.24, occurrence-weighted), with sustainable finance and green bonds at 2.32 and market dynamics at 2.54. This is the corner where economics and management research lands.
- **Earth and space physics** (22 topics, 3,313): astro and planetary science, geophysics and gravity, planetary exploration, cosmology, ionosphere, particle physics, black holes, dark matter, pulsars and gravitational waves. None of this is climate action; see the caveat.
- **Seismology and geology** (12 topics, 3,343): earthquakes and tectonics, seismic waves and imaging, geochemistry.
- **Atmosphere, air quality and health** (8 topics, 3,157): atmospheric gas dynamics, chemistry and aerosols, ozone, air quality, and the two best-cited large topics of the whole map, **climate change and health impacts** (3.25 on 499 works) and **air quality and health impacts** (3.05 on 296). Among topics with more than 250 works, the health-climate interface is the best-cited thing Italy does under SDG 13.
- **Ecology, forests and agriculture** (13 topics, 3,156): plant water relations and carbon, fire effects, species distribution, tree rings, remote sensing in agriculture; the second-best-cited cluster (1.59).
- **Urban and buildings** (10 topics, 2,490): urban heat islands, building energy, land use and ecosystem services, urban planning, cultural heritage surveying.
- **Disaster engineering** (10 topics, 2,354): disaster management and resilience, seismic performance, structural health monitoring, infrastructure vulnerability.
- Two small clusters: **paleoclimate and archaeology** (3 topics) and **antennas and metasurfaces** (2 topics, boundary noise).

Seismology and disaster engineering are the least-cited regions (0.68 and 0.97 occurrence-weighted); the Earth-and-space cluster is around 1.

## Caveat

SDG tags are classifier output, and the big bibliometric databases disagree on them (Kashnitsky et al. 2024, *Quantitative Science Studies*; Ottaviani and Stahlschmidt 2024, arXiv:2405.03007, both in [../readings/](../readings/)). The map shows what OpenAlex calls SDG 13, not a ground truth: a whole cluster of astrophysics, planetary and particle physics inside "Italian climate action" (about a tenth of the topic assignments on the map) is the classification boundary made visible.

## Saved map

[maps/A3_IT_sdg13_topics_2020_2025.json](maps/A3_IT_sdg13_topics_2020_2025.json) is the map described above. Download it and open it in VOSviewer (File > Open > VOSviewer JSON file) or in VOSviewer Online (app.vosviewer.com > Open).
