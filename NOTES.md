# Project notes – Olist E-commerce (real numbers)

## Load (rows / missing values)
| Table | Rows | Missing |
|---|---|---|
| orders | 99,441 | 4,908 |
| customers | 99,441 | 0 |
| order_items | 112,650 | 0 |
| order_payments | 103,886 | 0 |
| order_reviews | 99,224 | 145,903 (mostly empty comment fields) |
| products | 32,951 | 2,448 |
| sellers | 3,095 | 0 |
| category_translation | 71 | 0 |

## Data checks
- Status: 96,478 delivered, 1,107 shipped, 625 canceled, 609 unavailable, 314 invoiced, 301 processing, 5 created, 2 approved
- Duplicate order ids: 0 | Delivered without delivery date: 8 | Products without category: 610 | Untranslated categories: 2
- 99,441 customer_ids → 96,096 real customers (all statuses); 93,358 real customers with a delivered order
- Orders from 2016-09-04 to 2018-10-17; `sales` view = 110,197 item rows

## Headline
- Delivered orders 96,478 | customers 93,358 | revenue R$ 13,221,498 | freight R$ 2,198,276 | AOV R$ 137.04
- Jan–Aug 2018 R$ 7.22M vs Jan–Aug 2017 R$ 2.99M → +141%
- Best month Nov 2017 R$ 987,765 (+52.4% MoM); Dec 2017 −26.5%

## Categories / states
- Top category health_beauty 9.3%, watches_gifts 8.8%, bed_bath_table 7.7%; top 10 = 62.4%
- Top state SP 38.3% (39,156 customers), RJ 13.3%, MG 11.7% → top 3 = 63.3%

## Delivery & reviews
- Avg delivery 12.5 days, 8.1% late
- Review: on time 4.29 (88,653) vs late 2.57 (7,700)
- Slowest: AM 26.4 days, AL 24.5 days (23.9% late), PA 23.7; fastest SP 8.7 days (5.9% late)

## Customers
- Repeat customers: 3.0% | frequency: 90,557 bought once, 2,573 twice, 181 three times
- Top 1% → 11.5% revenue, top 10% → 41.1%, top 20% → 56.6%; top-10% avg spend R$ 582 vs R$ 93
- RFM: Lost high-value 22.0% cust / 41.8% rev; New high-value 15.5% / 29.3%; Lost/one-time 36.2% / 14.3%;
  New 23.3% / 9.2%; Loyal 1.9% / 3.7%; Loyal but slipping 1.1% / 1.8%
- Cohort: avg month-1 retention 0.47%, avg months 1–12 0.20%

## Payments
- Credit card 78.5% of value (avg 3.5 instalments), boleto 18.0%, voucher 2.2%, debit 1.4%

## Resume bullet ideas
- "RFM segmentation showed the top 10% of customers gave 41% of revenue and only 3% of customers ever reordered"
- "Found late deliveries (8.1% of orders) dropped review scores from 4.29 to 2.57 stars"
