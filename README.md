# Customer Shopping Behavior Analysis (Online Retail Dataset)

An end-to-end RFM (Recency, Frequency, Monetary) analysis of a real
UK-based online retailer's transaction data, identifying which customers
drive the most revenue and how to prioritize retention efforts.

## Dataset

**UCI "Online Retail" dataset** — 541,909 real invoice line items from a
UK-based online gift retailer, 01-Dec-2010 to 09-Dec-2011. Many customers
are wholesalers buying in bulk, not typical single-item retail shoppers,
which is reflected in the findings below.

## Business Question

> Which customers generate the most revenue and show the strongest
> loyalty signals, and what does their purchasing behavior (recency,
> frequency, order value, country, product mix) tell us about how to
> retain and grow the highest-value segments?

## Stack

- **Python** (pandas, matplotlib, seaborn) — data cleaning, EDA, RFM segmentation
- **SQL** (PostgreSQL syntax) — segment-level business queries with CTEs and window functions
- **Jupyter Notebook** for the analysis walkthrough

## Repository Structure

```
├── Customer_Shopping_Behavior_Analysis.ipynb   # cleaning, EDA, RFM segmentation
├── online_retail.csv                           # raw input data (from Online Retail.xlsx)
├── online_retail_cleaned.csv                   # cleaned transactions + rfm_segment (feeds SQL/BI)
├── customer_rfm_summary.csv                    # one row per customer: R/F/M values, scores, segment
├── customer_behaviour_insights.sql             # segment-based SQL analysis
├── REPORT.md                                   # findings & recommendations
└── charts/                                     # exported EDA & segmentation charts
```

## How to Run

1. Install dependencies: `pip install pandas numpy matplotlib seaborn jupyter sqlalchemy psycopg2-binary`
2. Open `Customer_Shopping_Behavior_Analysis.ipynb` and run all cells top to bottom.
   This produces `online_retail_cleaned.csv`, `customer_rfm_summary.csv`, and the charts in `/charts`.
3. Load both CSVs into PostgreSQL (see the optional cell in the notebook)
   as tables `online_retail` and `customer_rfm`.
4. Run `customer_behaviour_insights.sql` against those tables.
5. (Optional) Build a Power BI / Tableau dashboard on top of
   `online_retail_cleaned.csv` and `customer_rfm_summary.csv` — see note below.

## Method: RFM Segmentation

Because this dataset has real invoice dates, RFM is computed directly
(not approximated): each customer is scored 1–4 on Recency, Frequency,
and Monetary value (quartile-based), and the combined score maps to a
segment.

| Segment | Meaning |
|---|---|
| **Champions** | Recent, frequent, high-spending customers |
| **Loyal** | Consistently good customers, slightly below top tier |
| **Potential Loyalist** | Decent recent activity, not yet high-frequency |
| **At Risk** | Used to be active, recency/frequency has dropped |
| **Needs Attention** | Low across recency, frequency, and spend |

## Key Findings

See [REPORT.md](REPORT.md) for the full write-up with numbers and recommendations.

## Note on the Dashboard

This version of the project does not include a Power BI file. The
original repo's `.pbix` was built against a different (fashion-retail)
dataset schema and doesn't map onto the Online Retail dataset's columns
(invoices, countries, dates) — rebuilding it would mean starting a new
dashboard, not editing the old one. `online_retail_cleaned.csv` and
`customer_rfm_summary.csv` are ready to plug straight into a fresh Power
BI / Tableau file if you want to add one.
