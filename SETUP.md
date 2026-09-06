# Before the session "Publications as innovation data" (DAISY 2026): a 10-minute setup

Dear participants, if you want to run the material on your laptop during or after the session, please do these four things in advance. It takes about ten minutes and no payment details are asked anywhere. What the session covers is explained in class.

**What to bring**: a laptop with a charger, the Google account you use below, and your OpenAlex API key saved somewhere you can copy it from.

## 1. OpenAlex account and free API key (2 minutes)

OpenAlex (openalex.org) is an open catalogue of scholarly works. Since February 2026 an API key is needed for anything beyond a few test calls.

1. Go to **openalex.org** and create a free account (sign up with your email and confirm it).
2. While logged in, open **openalex.org/settings/api** and create your API key.
3. Copy the key into a text file you can find again. Treat it like a password: it is tied to your account.

The free tier gives $1 of credit per day; a normal query costs a fraction of a cent, so the allowance is hard to exhaust. Requests without a key run on a shared allowance of $0.10 per day per network address, which disappears in seconds on a classroom Wi-Fi: get the key.

## 2. VOSviewer 1.6.21 (3 minutes)

VOSviewer is a free desktop program for building and drawing bibliometric maps. Install version **1.6.21** (June 2026); older versions lack the OpenAlex API key field and will not work for the session.

- **Windows**: download the exact build used in class from this repository, [VOSviewer_1.6.21_exe.zip](https://github.com/maxcodaz/daisy-publications/releases/download/vosviewer-1.6.21/VOSviewer_1.6.21_exe.zip) (63 MB). Unzip it into a new folder and start `VOSviewer.exe`.
- **macOS and other systems**: download the macOS build or the plain JAR from **vosviewer.com/download**. If macOS refuses to open an app from an unidentified developer, right-click the app and choose Open. The JAR is started with `java -jar VOSviewer.jar`.

VOSviewer needs **Java 8 or later**, which is not bundled: if it does not start, install Java from adoptium.net (or java.com) and try again.

To check the installation: start VOSviewer, then File tab > **Create** > "Create a map based on bibliographic data" > **Download data through API** > **OpenAlex**. You should see an **API key** field on that page; if you do not, you are on an older version. Close the dialog, nothing else is needed for now.

## 3. Google Colab (1 minute)

Part of the session uses Google Colab (colab.research.google.com), a free notebook service that runs in the browser with a Google account.

1. Open **colab.research.google.com** and sign in with your Google account.
2. Choose **New notebook**, type `1 + 1` in the cell and press Shift+Enter. If you get `2`, Colab works.
3. Check that **Runtime > Change runtime type** lets you pick **R** as well as Python (both are used). Switch back or just close the notebook.

## 4. Google BigQuery sandbox (4 minutes, no credit card)

BigQuery is Google's SQL warehouse. The **sandbox** is the free mode: no credit card, no billing account, 10 GB of storage, 1 TiB of query processing per month, and tables you create expire after 60 days. The goal of this step is only to have a sandbox project ready under your Google account; nothing is queried, added or starred now.

Use a **personal Gmail account**, not a university one (institutional accounts are often blocked from the Cloud console, see section 5). Do **not** go through the "Try for free" / "Start free trial" / "Activate" buttons: those are the paid path and ask for a card. The sandbox needs none of them.

1. Open **console.cloud.google.com/bigquery** in your browser and sign in with your Google account.
2. A **Welcome** window appears the first time: choose your country, tick the box to agree to the Google Cloud terms of service, and click **Agree and continue**. Leave any "email updates" box unticked.
3. The BigQuery page opens but says you have no project ("Select a project" or "Create a project" in a bar at the top). Click **Create project**. If you see instead a project selector in the top bar, click it and then **New project** at the top right of the dialog.
4. In the **New project** form, **Project name**: type any name of your choice, for example your surname followed by `-bigquery`. Do not name it after the course, it makes the Explorer pane confusing later. **Location / Organisation**: leave "No organisation". Click **Create**. Google generates a project id (your name plus a number) under the name field: you do not need to change it.
5. Wait a few seconds. A notification (bell icon, top right) says the project is created; if the page does not switch to it by itself, open the project selector in the top bar and pick it.
6. You are now in the BigQuery console of your project. At the top of the page, a blue bar says something like **"You're using the BigQuery sandbox"** with an **Activate** (or **Upgrade**) button. This bar is the confirmation that you are in the free, card-free mode. Do **not** click the button. Ignore it every time it reappears.
7. Check: in the **Explorer** pane on the left, your project name is listed. That is all. Close the tab; the sandbox stays available under this account, nothing has to be kept open.

Later, if a window ever asks for a credit card or a billing account, you have clicked on the paid path by mistake: close it and go back to **console.cloud.google.com/bigquery**.

## 5. If something does not work

Nothing is lost: the session is a live demonstration and everything can be set up and rerun at home afterwards. Two known problems:

- If your **institutional Google account** refuses to open the Cloud console or Colab ("this service is not available for your organisation" or a permission error), the administrator has switched Cloud services off for that domain: use a personal Gmail account instead.
- If Java refuses to start VOSviewer on macOS, download the JAR and run `java -jar VOSviewer.jar` in a terminal.

Bring your questions to the session.
