# Topic list

`ce_topics.csv`: the circular-economy (CE) topic set used by the SQL scripts, the 8 OpenAlex topics returned by the topics search for "circular economy" (`https://api.openalex.org/topics?search=circular%20economy`, which matches the phrase in a topic's name, description or keywords). The notebooks run this search live; the file holds the same 8 ids for BigQuery.

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

Two columns, `topic_id_url` (the full id, `https://openalex.org/T10539`, the form BigQuery stores in `primary_topic.id`) and `topic_name`, UTF-8, comma separated, header row. Upload it into your BigQuery dataset as `daisy.ce_topics` (`sql/q02_green_by_country.sql`, step 0: auto-detect off, schema `topic_id_url:STRING,topic_name:STRING`, header rows to skip 1); `q02` and `q03` read it from there.
