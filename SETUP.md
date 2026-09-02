# Before the session "Publications as innovation data" (DAISY 2026): a 10-minute setup

Dear participants, the session on publication data (OpenAlex, VOSviewer, BigQuery) is a live demonstration: nothing below is required to follow it, and every script, notebook and map will be shared afterwards. If you want to run the same queries on your laptop during or after the session, please do these four things in advance (about ten minutes, no payment details anywhere).

**What to bring**: a laptop with a charger, the Google account you set up below, and the OpenAlex key saved somewhere you can copy it from.

## 1. OpenAlex account and free API key (2 minutes)

OpenAlex (openalex.org) is the open catalogue of about 250 million scholarly works we will use in all three parts. Since February 2026 an API key is needed for anything beyond a few test calls. Create a free account on openalex.org, then go to **openalex.org/settings/api** and create a key. The free tier gives $1 of credit per day; a list or filter query costs $0.0001 and a search query $0.001, so a full rerun of our notebooks costs well under one cent. Keep the key private (it is tied to your account) and paste it where the notebooks say `API_KEY = "..."`. Requests without a key still work at $0.10 per day, enough to try one URL in a browser.

## 2. VOSviewer 1.6.21 (3 minutes)

VOSviewer builds and draws bibliometric maps and can download data from OpenAlex directly. Download version 1.6.21 (12 June 2026) from **vosviewer.com/download**: there is a Windows build, a macOS build, and a plain JAR for other systems. It needs Java 8 or later, which is not bundled: if you do not have Java, install it from java.com or adoptium.net first. Unzip the download into a new folder and start `VOSviewer.exe` (Windows) or the VOSviewer app (macOS; if macOS refuses to open an app from an unidentified developer, right-click the app and choose Open). To check that everything works: File tab > **Create** > "Create a map based on bibliographic data" > **Download data through API** > **OpenAlex** > choose the request-URL option and paste
`https://api.openalex.org/works?filter=authorships.author.id:A5073659024,primary_location.source.type:journal`
then Next until the co-authorship map appears (about 115 works, a few seconds). In the download step, paste your OpenAlex API key in the **API key** field (present since VOSviewer 1.6.21; make sure you are not on an older build, which has no key support and falls back to a shared keyless allowance too small for the bigger queries).

## 3. Google account and a BigQuery sandbox (4 minutes, no credit card)

BigQuery is Google's SQL warehouse; the whole of OpenAlex (510 million records) sits there in public tables and a query over all of it takes seconds. The **sandbox** is free and needs no card: 10 GB of storage, 1 TiB of query processing per month, and tables you create expire after 60 days.

1. With a Google account, open **console.cloud.google.com/bigquery**. Accept the terms; if asked, create a project (any name). A "Sandbox" badge appears at the top of the page.
2. In the Explorer panel on the left click **+ Add** (or "Add data") > **Star a project by name** and type `subugoe-collaborative`, then Star. Repeat for `patcit-public-data` and `nber-i3`. The three projects now appear in your Explorer with their public datasets (OpenAlex, Crossref, Unpaywall, PatCit front-page citations, Reliance on Science, PatentsView). If `nber-i3` does not show up or refuses queries from a sandbox, that is not your mistake: its user guide asks for an account with billing enabled; the session runs on the other two projects.
3. Open a query tab and paste

   ```sql
   SELECT COUNT(*)
   FROM `subugoe-collaborative.openalex_walden.works`
   WHERE publication_year = 2024 AND NOT is_xpac
   ```

   Before pressing **Run**, look at the top right of the editor: the green tick shows "This query will process X GB when run". That estimate is free and is the habit to keep: BigQuery bills by bytes scanned, and this query touches only two small columns of the table (expect a few GB, far from the free 1 TiB), whereas `SELECT *` on the same table would scan the whole thing. Then run it; you should get a count of several million works published in 2024.

## 4. Colab notebooks (1 minute)

The API part uses Google Colab (colab.research.google.com), free with the same Google account. Open the two notebooks (links to be sent with the material: `[R notebook, openalexR]` and `[Python notebook, pyalex]`); for the R notebook choose **Runtime > Change runtime type > R** before running. Each notebook installs its own packages and asks only for your OpenAlex key.

## 5. If something does not work

Nothing is lost: the session is a demonstration, and all material (slides, VOSviewer maps, notebooks, SQL scripts, this guide) is available afterwards, so you can set things up at home and rerun everything. If your **institutional Google account** refuses to open the Cloud console or Colab ("this service is not available for your organisation" or a permission error), the administrator has switched Cloud services off for that domain: use a personal Gmail account instead. If Java refuses to start VOSviewer on macOS, the JAR download plus `java -jar VOSviewer.jar` in a terminal is the fallback. Bring your questions to the session.
