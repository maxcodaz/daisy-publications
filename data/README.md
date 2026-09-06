# Topic lists

The circular-economy (CE) topic set used by the notebooks and the SQL scripts, plus a wider list of green OpenAlex topics.

## The CE set

The 8 OpenAlex topics returned by the topics search for "circular economy" (`https://api.openalex.org/topics?search=circular%20economy`, which matches the phrase in a topic's name, description or keywords). The notebooks run this search live; the files below hold the same 8 ids for the SQL scripts and for VOSviewer.

| topic_id | topic_name |
|---|---|
| T10539 | Sustainable Supply Chain Management |
| T11091 | Extraction and Separation Processes |
| T13180 | Chemistry and Chemical Engineering |
| T11672 | Recycling and utilization of industrial and municipal waste in materials production |
| T13240 | Bioeconomy and Sustainability Development |
| T12746 | Sustainable Industrial Ecology |
| T13045 | Industrial Engineering and Technologies |
| T13477 | Sustainable Design and Development |

## Files

| file | what it is | how to use it |
|---|---|---|
| `ce_topics.csv` | the 8 topics as a two-column CSV (`topic_id_url`, `topic_name`) | upload it into your BigQuery dataset as `daisy.ce_topics` (`sql/q02_green_by_country.sql`, step 0); read by `q02` and `q03` |
| `ce_topic_ids.txt` | the same ids, one bare id per line (`T10539`) | anything that reads a list |
| `ce_topic_ids_sql.txt` | the same ids as full URLs in a BigQuery array literal | paste into `UNNEST([...])` in SQL (`primary_topic.id` holds the full URL in BigQuery) |
| `ce_topic_ids_api.txt` | the same bare ids joined by a vertical bar | paste after `primary_topic.id:` in an OpenAlex API filter or a VOSviewer request URL (the API accepts up to 100 OR-ed values in one filter) |
| `green_topics.csv` | 523 OpenAlex topics flagged green by a keyword rule, one row per topic, grouped into five themes | a wider green list for your own exercises, see below |

## `green_topics.csv`

The 523 topics are those whose name, keywords or summary contain at least one of 20 green phrases (renewable energy, solar energy, photovoltaic, wind energy, biofuel, climate change, greenhouse gas, carbon capture, decarboniz, circular economy, recycling, waste management, wastewater, water quality, biodiversity, sustainable development, life cycle assessment, air pollution, electric vehicle, energy efficien). A substring rule of this kind is loose: it sweeps in topics whose summary merely mentions "sustainable development" or "climate change", so read the list as "topics that a simple keyword rule calls green", not as a validated classification.

Columns (UTF-8, comma separated, header row):

| column | content |
|---|---|
| `topic_id` | bare OpenAlex topic id, `T10471` (what the REST API filter wants) |
| `topic_id_url` | full id, `https://openalex.org/T10471` (what BigQuery stores in `primary_topic.id` and `topics[].id`) |
| `topic_name` | OpenAlex topic display name |
| `subfield_name`, `field_name`, `domain_name` | the three upper levels of the OpenAlex topic hierarchy |
| `is_digital` | 1 if a parallel keyword rule also flagged the topic as digital (a "twin" topic), else 0 |
| `daisy_group` | `circular_economy`, `climate_energy`, `environment_biodiversity`, `sustainability_policy`, `other_green` |
| `ce_core` | 1 for the 28 topics of the wider keyword-based CE group (`daisy_group = circular_economy`), else 0 |
| `keywords` | the ten OpenAlex keywords of the topic, `;` separated |

How `daisy_group` was assigned: a topic is `circular_economy` when a CE term (circular economy, recycl, waste management, remanufactur, industrial symbiosis, life cycle assessment, bioeconomy, resource recovery, and similar) appears in its name, or at least two distinct CE terms appear in its keywords. Every other topic is scored against three term lists (climate and energy, environment and biodiversity, sustainability policy) with weights 3 for a hit in the name, 2 in the keywords, 1 in the summary; the highest score wins, and a topic with no hit in the name and a score below 4 goes to `other_green`.

| daisy_group | topics |
|---|---|
| circular_economy | 28 |
| climate_energy | 114 |
| environment_biodiversity | 197 |
| sustainability_policy | 63 |
| other_green | 121 |
| **total** | **523** |

The 28-topic `circular_economy` group is wider than the 8-topic CE set above (all 8 are inside it). The scripts and notebooks use the 8-topic set.
