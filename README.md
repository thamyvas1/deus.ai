# DEUS — Data Analytics Engineer Code Challenge

A reproducible dbt + DuckDB solution for the sales analytics case.

## What is included

- `seeds/` — the five supplied CSV extracts
- `models/staging/` — typed, cleaned source models
- `models/intermediate/` — invoice enrichment and attribution logic
- `models/marts/` — BI-ready monthly sales report and quarterly account ranking
- `analysis/` — SQL answers to the two questions in the brief
- `tests/` — custom data-quality assertions
- `docs/decisions.md` — business decisions, anomalies and their impact

## Headline numbers

Using one row per unique invoice ID and preserving the source sign on credit notes:

- **2025 net revenue: €9,493,212.43**
- **2025 known-cost margin: €3,967,322.00**

Margin is based only on invoices with a populated cost; see `docs/decisions.md`.

## Reproduce locally

Requirements: Python 3.11+, `dbt-core`, and `dbt-duckdb`.

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
cp profiles.yml.example ~/.dbt/profiles.yml

dbt seed
dbt run
dbt test
```

The DuckDB file is created at `deus_sales_analytics.duckdb`.

## Business outputs

### Monthly report
`mart_monthly_sales_report` contains one row per team/month in 2025, including an `Unassigned` team bucket so unattributed revenue remains visible. Columns include:

- revenue
- margin and margin %
- target
- variance to target
- target attainment %
- trailing 3-month revenue
- invoice and account counts
- unattributed revenue
- revenue affected by missing cost

### Question 1
Run `analysis/monthly_rolling_revenue.sql` for monthly revenue and trailing 3-month revenue by team.

### Question 2
Run `analysis/top_3_accounts_by_quarter.sql` for the top 3 accounts by signed revenue in each quarter.

## Key decisions

Finance invoices are the source of truth for realized revenue. Duplicate invoice IDs are deduplicated because the duplicate records are exact repeats. Credit notes are already negative in the source. Invoices without a valid CRM opportunity are retained as `Unassigned`, rather than dropped. Missing costs are not imputed.

See `docs/decisions.md` for the full rationale and quantified data-quality findings.
