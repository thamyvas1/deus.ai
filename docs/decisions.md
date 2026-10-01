# Business decisions and data-quality findings

## Revenue source and grain
Finance invoices are the source of truth for realized revenue. The core fact grain is one unique `invoice_id`. CRM opportunity `amount_eur` is deal value, not billed revenue.

## Duplicate invoices
There are 7 duplicated invoice IDs in the source. The duplicated rows are exact repeats, so `stg_invoices` keeps one row per `invoice_id` using `row_number()`.

## Credit notes
Credit-note amounts are already negative in the source. We preserve the source sign rather than applying another sign.

## Invoice-to-opportunity attribution
A valid opportunity supplies rep and team. If an invoice has no opportunity or references an opportunity absent from CRM, the revenue is retained and assigned to `Unassigned` rather than dropped. In 2025, 61 unique invoices are unattributed, representing €1,912,289.25.

Three opportunity IDs referenced by invoices are absent from CRM: `OPP-9001`, `OPP-9002`, and `OPP-9003`.

## Missing costs and margin
Five unique 2025 invoices have null cost. Revenue is retained. Margin is calculated only when cost is known; null margins are not imputed. This makes the headline margin a known-cost margin. The 2025 revenue on missing-cost invoices is €685,250.00.

## Date scope
The sales-director report is limited to invoice dates in calendar year 2025. Other dates remain in the fact model but are excluded from the requested report.

## Targets and report grain
The target table is authoritative for monthly team targets. The report builds a complete month/team grid so zero-activity months remain visible.

## Rolling revenue
Trailing 3-month revenue is the current month plus the prior two calendar months for each team.

## Top accounts
Accounts are ranked by signed invoice revenue within each calendar quarter of 2025. Credit notes reduce quarterly revenue. Ties are deterministically broken by `account_id`.

## Headline numbers
After deduplicating invoice IDs and preserving source signs:

- **2025 net revenue: €10,399,987.57**
- **2025 known-cost margin: €5,081,518.76**
- **Known-cost margin / total revenue: 48.86%**

The margin percentage should be interpreted with the missing-cost caveat above.
