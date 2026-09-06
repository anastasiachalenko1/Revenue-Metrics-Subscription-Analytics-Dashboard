# SaaS Subscription Revenue & Retention Dashboard
A five-view Tableau dashboard for tracking revenue dynamics in a subscription business, built on metrics extracted from PostgreSQL with SQL.

Overview

The goal was to give a product team a single view for monitoring month-over-month revenue movement and identifying what drives it.

The work had two parts. First, SQL queries against a PostgreSQL database to calculate the core subscription metrics: MRR, ARPPU, paid users, new and churned users, churn rate, revenue churn rate, expansion MRR, contraction MRR, customer lifetime (LT) and lifetime value (LTV). Second, a Tableau dashboard built on that output, with filters for period, user language and age group.

Two of the five views are dedicated to decomposing month-over-month change in revenue and paid users, so the drivers behind a movement are visible rather than just the movement itself.

Key findings

Growth stopped while revenue was at its highest. Net revenue change fell from +$2,109.84 in April to +$14.79 in December. MRR itself stayed near its yearly high of about $8.5K, the revenue was still there, it just stopped growing.

Existing customers were paying less over time. Contraction MRR reached −$2,380.68 while upgrades Expansion MRR were only $1,713.03. Net revenue retention was below 100%, meaning the current customer base would shrink even without new churn.

The customers leaving were the cheaper ones. Customer churn was 0.32 while revenue churn was 0.21. Departing accounts were worth about two-thirds of an average one. The business was losing its low-value users, not its best ones.

But average revenue per user never moved. Since cheaper customers were leaving, ARPPU should have gone up on its own. It stayed between 43.00 and 46.70 for nine months. New customers were arriving at the same low value as the ones leaving.

What this means. MRR grew about 6x, and all of that came from adding more customers, not from customers paying more. The limit on growth is the quality of new customers, not the quantity.

What this data cannot answer. LTV only means something when compared to CAC, and CAC is not in this dataset. No conclusion about whether LTV is healthy can be drawn here.


Tools

SQL (PostgreSQL) · Tableau Public · data modelling · data visualization
