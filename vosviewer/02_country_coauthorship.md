# Map 2. Country co-authorship: Climate Change Policy and Economics, 2020 to 2025

VOSviewer 1.6.21, bibliographic-data route.

## Question

Who collaborates with whom in climate economics, and where does Italy sit? A country co-authorship network on one OpenAlex topic shows the collaboration blocks and the position of each country; coloured by average normalised citations it also shows which countries publish in the well-cited part of the field.

## Request URL

```
https://api.openalex.org/works?filter=primary_topic.id:T10471,publication_year:2020-2025
```

`T10471` is the OpenAlex topic "Climate Change Policy and Economics". `primary_topic.id` keeps only works whose first-ranked topic is T10471; `topics.id` would also include works where it is a secondary topic. In September 2026 this returned about **27,000 works**, under the 50,000 cap.

For reference, the top 10 countries by whole counting (a work counts once for every country on it), read from `group_by=authorships.countries` in September 2026, 169 countries in total:

| rank | country | works | rank | country | works |
|---|---|---|---|---|---|
| 1 | United States | 4,335 | 6 | **Italy** | **922** |
| 2 | China | 2,977 | 7 | Netherlands | 794 |
| 3 | United Kingdom | 2,409 | 8 | Canada | 735 |
| 4 | Germany | 2,097 | 9 | Australia | 693 |
| 5 | France | 1,289 | 10 | Spain | 627 |

These are the "Documents" weights VOSviewer shows per country (up to the growth of the database between that date and your run).

## Click path (VOSviewer 1.6.21)

1. **File** tab, **Create**.
2. Choose type of data: **Create a map based on bibliographic data**. Next.
3. Choose data source: **Download data through API**. Next.
4. Choose API: **OpenAlex**. Next.
5. Choose the **API request URL** option and paste the URL above (API key as in map 1).
6. Next: the download of about 27,000 works runs.
7. Type of analysis **Co-authorship**; unit of analysis **Countries**; counting method **Fractional counting** (the class map). With full counting a paper with authors from four countries creates links of strength 1 between every pair, so the large multi-country consortia typical of climate science dominate; fractional counting gives each of a paper's links a weight of 1/n. Rerun with full counting as a one-click robustness check: it changes link strengths, not who is connected to whom.
8. Thresholds: minimum number of documents of a country **20**; minimum citations 0. On the September 2026 data, **74 countries** qualify.
9. Keep all countries that meet the threshold; leave all ticked. Finish.
10. Look at **Network Visualization** first (clusters are collaboration blocks), then **Overlay Visualization** with Scores set to **Avg. norm. citations** (citations divided by the average of the same publication year, so recent papers are not penalised) or, simpler, **Avg. citations**; a third view with **Avg. pub. year** tells a timing story.

In one line: bibliographic data; OpenAlex; request URL; co-authorship; countries; fractional counting; min. 20 documents per country; overlay by average normalised citations.

## How to read the map (September 2026 build, 74 countries, 6 clusters)

The US, China, the UK and Germany are the largest circles. The single thickest link is **UK-US (410)**, well ahead of China-US (244), Germany-US (185) and Germany-UK (171). Total link strength ranks the US first (2,064), then the UK (1,676), Germany (1,161), China (1,064), France (674), the Netherlands (588) and Italy (548).

The six clusters are collaboration blocks shaped by language and history rather than plain geography:

- the **UK with North-Western Europe** (Germany, Netherlands, Switzerland, Austria, Sweden, Norway, Denmark, Finland): 9 countries, the best-cited block (average normalised citations 2.2);
- the **US with Iberia and Latin America** (Spain, Brazil, Mexico, Portugal, Chile, Colombia, Argentina, Costa Rica) plus Kenya and Nepal;
- **France with Asia-Pacific, South Asia and Africa** (Australia, India, Japan, South Korea, New Zealand, Indonesia, South Africa, Pakistan, Saudi Arabia, Nigeria, Ghana, Morocco and others): the largest block, 27 countries;
- **China with Hong Kong, Singapore and Macao** (and Bulgaria);
- **Italy with the Mediterranean and Eastern Europe** (Belgium, Russia, Poland, Turkey, Greece, Ireland, Romania, Czech Republic, Hungary, Ukraine, Iran, Slovenia, Cyprus, Israel, Slovakia and others): 21 countries;
- **Canada** alone, so tied to the US that it forms a cluster of one.

**Italy**: rank 6 with 922 works; strongest partners the UK (76), the US (72), France (56), Germany (54) and the Netherlands (42); average normalised citations **1.77**, close to the average of the mapped countries (1.64 unweighted) and below the North-Western European block (the UK 2.21, Germany 2.03, Netherlands 2.36, Switzerland 2.40).

Treat the cluster membership of mid-core countries (Belgium with Italy, Bulgaria with China) as an artifact of the clustering resolution; the robust part of the picture is distances and link thicknesses.

## Caveats

- Countries come from the institutional affiliations OpenAlex resolves; works without any resolved affiliation drop out of the map, and affiliation coverage is weaker for older and non-English records.
- A topic is classifier output: T10471 is a coherent field, but its boundary with energy economics, environmental economics and climate impact studies is algorithmic.
- Whole counting means the country column does not sum to the number of works.
- With OpenAlex data the wizard supports co-authorship, co-occurrence, citation and bibliographic coupling, but not co-citation (OpenAlex provides reference ids, not raw reference strings).

## Saved map

[maps/A2_T10471_countries_2020_2025.json](maps/A2_T10471_countries_2020_2025.json) is the map described above. Download it and open it in VOSviewer (File > Open > VOSviewer JSON file) or in VOSviewer Online (app.vosviewer.com > Open).
