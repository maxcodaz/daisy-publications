# Map 3 (optional). Topic co-occurrence: Italian SDG-13 publications, 2020 to 2025

Shown live only if time allows; otherwise it appears as a screenshot. It previews the SDG-landscape step of the API leg, and it uses the topic co-occurrence unit added for OpenAlex in VOSviewer 1.6.21.

## Question

Which research topics travel together in Italian climate-action (SDG 13) publications? Each work carries up to three OpenAlex topics; two topics are linked when they are assigned to the same work. The map shows the sub-communities of the national portfolio and how far the economics and management topics sit from the natural-science core.

## Request URL

```
https://api.openalex.org/works?filter=authorships.countries:IT,sustainable_development_goals.id:https://openalex.org/sdgs/13,publication_year:2020-2025
```

On 2 September 2026 this returned **24,763 works**, under the 50,000 cap. Adding `type:article` shrinks it further if needed. The filters are plain (no text search), so the download is billed at the cheap list rate.

## Click path (VOSviewer 1.6.21)

1. **File** tab, **Create**.
2. Choose type of data: **Create a map based on bibliographic data**. Next.
3. Choose data source: **Download data through API**. Next.
4. Choose API: **OpenAlex**. Next.
5. Choose the **API request URL** option, paste the URL above, and paste your API key in the key field. Next; the download of about 25,000 works runs.
6. Type of analysis **Co-occurrence**; unit of analysis **Topics** (confirmed present in 1.6.21 with OpenAlex data); counting method **Full counting**.
7. Threshold: minimum number of occurrences of a topic, **10** by default for an exhaustive map; raising it to around 100 keeps only the topics that at least 100 of the works carry, which gives a readable ~125-topic map for a projector.
8. Keep the topics VOSviewer proposes (cap the selection at 200 for legibility). Finish.
9. Look at **Network Visualization** for the sub-communities, then **Overlay Visualization** with Scores set to **Avg. norm. citations** (which parts of the portfolio are well cited) or **Avg. pub. year** (which are growing).

In one line: bibliographic data; OpenAlex; request URL; co-occurrence; topics; full counting; min. occurrences 10 (100 for a projector); overlay by average normalised citations.

## How to read the map

The built map (126 topics, 11 clusters) splits into a physical-hazard core that is very recognisably Italian (flood risk and landslides are the two biggest nodes on the whole map, with hydrology, meteorology and climate modelling around them), an atmospheric chemistry and health region whose health-related topics are the best-cited part of the entire portfolio, an ecology and forestry region, seismology and disaster-engineering regions, an urban region (heat islands, building energy), and one social-science cluster where climate policy and economics, sustainable finance and green bonds, and climate communication sit together, cited clearly above the map average. That cluster is where the research of most economics and management students would land.

The map also shows something the classifier would rather hide: a sizeable astrophysics and space-science cluster (cosmology, pulsars, dark matter, planetary science) inside what is nominally "Italian climate action research". Those works carry the SDG-13 tag algorithmically, and their presence is the caveat made visible.

## Caveat

SDG tags are classifier output, and the big bibliometric databases disagree on them (Kashnitsky et al. 2024, *Quantitative Science Studies*; Ottaviani and Stahlschmidt 2024, arXiv:2405.03007, both in [../readings/](../readings/)). The map shows what OpenAlex calls SDG 13, not a ground truth, and the astrophysics cluster above is the proof on screen.

The saved map (`maps/A3_IT_sdg13_topics_2020_2025.json`) opens in VOSviewer Online.
