# Map 3 (optional). Topic co-occurrence: Italian SDG-13 publications, 2020 to 2025

Shown live only if time allows; otherwise it appears as a screenshot. It previews the SDG-landscape step of the API leg.

## Question

Which research topics travel together in Italian climate-action (SDG 13) publications? Each work carries up to three OpenAlex topics; two topics are linked when they are assigned to the same work. The map shows the sub-communities (climate modelling, energy systems, agriculture and land use, policy and economics, health) and how far the economics and management topics sit from the natural-science core.

## Request URL

```
https://api.openalex.org/works?filter=authorships.countries:IT,sustainable_development_goals.id:https://openalex.org/sdgs/13,publication_year:2020-2025
```

On 2 September 2026 this returned **24,763 works**, under the 50,000 cap. Adding `type:article` shrinks it further if needed.

## Click path (VOSviewer 1.6.21)

File > Create > **Create a map based on bibliographic data** > **Download data through API** > **OpenAlex** > API request URL (paste, key if asked) > Next > type of analysis **Co-occurrence**, unit of analysis **Topics** (added for OpenAlex in 1.6.21, replacing the deprecated concepts; if your build lists only **Keywords** under co-occurrence, use Keywords), **Full counting** > minimum number of occurrences of a topic **10** (OpenAlex has about 4,500 topics; expect a few hundred to qualify) > cap the selection at 200 topics for legibility > Finish. Overlay by **Avg. pub. year** or **Avg. norm. citations**.

## How to read the map

Look at the domain structure first (physical, life and social sciences separate into different regions), then find topic T10471 "Climate Change Policy and Economics" and its neighbours to see where economics sits relative to the natural-science core, and use the overlay to spot which topics are recent.

## Caveat

SDG tags are classifier output, and the big bibliometric databases disagree on them (Kashnitsky et al. 2024, *Quantitative Science Studies*; Ottaviani and Stahlschmidt 2024, arXiv:2405.03007, both in [../readings/](../readings/)). The map shows what OpenAlex calls SDG 13, not a ground truth.

The saved map (`maps/A3_IT_sdg13_topics_2020_2025.json`) opens in VOSviewer Online.
