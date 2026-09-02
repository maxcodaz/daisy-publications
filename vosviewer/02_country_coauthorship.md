# Map 2. Country co-authorship: Climate Change Policy and Economics, 2020 to 2025

The second map of leg A (VOSviewer 1.6.21, bibliographic-data route).

## Question

Who collaborates with whom in climate economics, and where does Italy sit? A country co-authorship network on one OpenAlex topic shows the US, China, UK and Germany core, the European block, and the position of Italy. Coloured by average (normalised) citations it also shows whether peripheral countries publish in the well-cited part of the field. The API leg answers the same question with `group_by=authorships.countries`, and the BigQuery leg with `UNNEST(authorships)` on the full snapshot.

## Request URL

```
https://api.openalex.org/works?filter=primary_topic.id:T10471,publication_year:2020-2025
```

`T10471` is the OpenAlex topic "Climate Change Policy and Economics". `primary_topic.id` keeps only works whose first-ranked topic is T10471; `topics.id` would also include works where it is a secondary topic. On 2 September 2026 this returned **26,954 works**, under the 50,000 cap.

For reference, the top 10 countries by whole counting (a work counts once for every country on it), read from `group_by=authorships.countries` on 2 September 2026, 169 countries in total:

| rank | country | works | rank | country | works |
|---|---|---|---|---|---|
| 1 | United States | 4,335 | 6 | **Italy** | **922** |
| 2 | China | 2,977 | 7 | Netherlands | 794 |
| 3 | United Kingdom | 2,409 | 8 | Canada | 735 |
| 4 | Germany | 2,097 | 9 | Australia | 693 |
| 5 | France | 1,289 | 10 | Spain | 627 |

These numbers match the "documents" weight VOSviewer shows per country under full counting, up to the growth of the database between that date and your run.

## Click path (VOSviewer 1.6.21)

1. **File** tab, **Create**.
2. Choose type of data: **Create a map based on bibliographic data**. Next.
3. Choose data source: **Download data through API**. Next.
4. Choose API: **OpenAlex**. Next.
5. Choose the **API request URL** option and paste the URL above (key as in map 1, if asked).
6. Next: the download of about 27,000 works runs.
7. Type of analysis **Co-authorship**; unit of analysis **Countries**; counting method **Full counting**. With full counting a paper with authors from four countries creates links of strength 1 between every pair; fractional counting gives each of the n links 1/n and tames the large multi-country consortia typical of climate science. Run full counting first, then repeat with fractional as a one-click robustness check.
8. Thresholds: minimum number of documents of a country **20**; minimum citations 0. Expect roughly 60 to 70 countries to qualify.
9. Keep all countries that meet the threshold; leave all ticked. Finish.
10. Look at **Network Visualization** first (clusters are collaboration blocks), then **Overlay Visualization** with Scores set to **Avg. norm. citations** (citations divided by the average of the same publication year, so recent papers are not penalised) or, simpler, **Avg. citations**; a third view with **Avg. pub. year** tells a timing story.

In one line: bibliographic data; OpenAlex; request URL; co-authorship; countries; full counting; min. 20 documents per country; overlay by average normalised citations.

## How to read the map

The US, China, the UK and Germany are the largest circles with the thickest links. The European block usually forms one or two clusters, with the UK bridging to the US. Italy (rank 6 of 169, 922 works) sits in the middle of the core: hover on the node to see its strongest partners, and check its overlay colour against the field average. Countries of the Global South appear at the edge; with full counting their position depends on a few large consortia, and with fractional counting they shrink.

## Caveats

- Countries come from the institutional affiliations OpenAlex resolves; works without any resolved affiliation drop out of the map, and affiliation coverage is weaker for older and non-English records.
- A topic is classifier output: T10471 is a coherent field, but its boundary with energy economics, environmental economics and climate impact studies is algorithmic.
- Full versus fractional counting changes link strengths, not who is connected to whom; the choice matters most for small countries.
- Whole counting means the country column does not sum to the number of works.
- With OpenAlex data the wizard supports co-authorship, co-occurrence, citation and bibliographic coupling, but not co-citation (OpenAlex provides reference ids, not raw reference strings).

## Why not the full circular-economy set here

The 28-topic circular-economy list in [../data/](../data/) covers about 455,000 works for 2020 to 2025 (2 September 2026), nine times the 50,000 cap, so VOSviewer cannot map it. That limit is the hand-over point of the session: the API notebook and the BigQuery scripts run the same 28-topic set on the full population. A five-topic subset that fits the cap (about 43,000 works) is:

```
https://api.openalex.org/works?filter=primary_topic.id:T12746|T13240|T14179|T13477|T14138,publication_year:2020-2025
```

The saved maps (`maps/A2_T10471_countries_2020_2025.json` and, if built, the CE subset) open in VOSviewer Online.
