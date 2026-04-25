# Rotterdam Port Inbound Freight
## Supply Chain Disruption Analysis (2024–2026)

### Project Overview
End-to-end supply chain analytics project analysing 10,000 shipments 
into Rotterdam Port — Europe's largest freight hub — across MySQL, 
Excel, and Power BI.

### Key Findings
- Geopolitical conflict causes **122% shipping cost increase** per shipment
- **100% of disrupted Rotterdam shipments arrived late**
- Re-routing is **10x cheaper** than Expedited Air Freight for identical outcomes
- Semiconductors show highest lead time variance **(2.5 days)**
- All 1,702 Rotterdam shipments arrive exclusively via **Suez route**

### Tools & Technologies
- **MySQL** — database design, data cleaning, 10 analytical queries, 3 views
- **Excel** — disruption analysis, mitigation scorecard, product scorecard
- **Power BI** — 4-page interactive dashboard, DAX measures, navy theme

### Dashboard Pages
1. **Executive Summary** — KPIs, delivery performance, route analysis
2. **Disruption Analysis** — cost and delay impact of geopolitical events
3. **Mitigation Strategy** — Re-routing vs Expedited Air cost effectiveness
4. **Product Risk Scorecard** — lead time variance by product category

### Dataset Source
- **Source:** Kaggle — Global Supply Chain Disruption Dataset
- **Size:** 10,000 rows | 19 columns
- **Period:** 2024–2026
- **Link:** https://www.kaggle.com/datasets/bertnardomariouskono/global-supply-chain-disruption-and-resilience

### Files in This Repository
| File | Description |
|------|-------------|
| `rotterdam_supply_chain_queries.sql` | All SQL queries, views, and database setup |
| `Rotterdam_Supply_Chain_Analysis.xlsx` | Excel workbook — 4 sheets with analysis |
| `Rotterdam_Supply_Chain_Analysis.pbix` | Power BI dashboard file |

### Project Pipeline
| Step | Tool | Output |
|------|------|--------|
| 1 | Raw CSV Dataset | 10,000 rows, 19 columns |
| 2 | MySQL | Database + 10 queries + 3 views |
| 3 | Excel | 4-sheet analysis workbook |
| 4 | Power BI | 4-page interactive dashboard |


### Author
**Saquib Raza** | Supply Chain Analytics Portfolio  
Targeting Supply Chain Analyst and related roles.
