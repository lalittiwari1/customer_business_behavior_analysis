# Customer Shopping Behavior Analysis 

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


## How to Run

1. Install dependencies: `pip install pandas numpy matplotlib seaborn jupyter sqlalchemy psycopg2-binary`
2. Open `Customer_Shopping_Behavior_Analysis.ipynb` and run all cells top to bottom.
   This produces `online_retail_cleaned.csv`, `customer_rfm_summary.csv`, and the charts in `/charts`.
3. Load both CSVs into PostgreSQL (see the optional cell in the notebook)
   as tables `online_retail` and `customer_rfm`.
4. Run `customer_behaviour_insights.sql` against those tables.
5. Build a Power BI / Tableau dashboard on top of
   `online_retail_cleaned.csv` and `customer_rfm_summary.csv`

