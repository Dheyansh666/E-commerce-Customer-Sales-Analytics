# Power BI dashboard – build steps

Sources (created by `notebooks/04_powerbi_export_and_preview.ipynb` and `03_rfm_cohort.ipynb`):
`data/sales_clean.csv` and `data/rfm_segments.csv`. Static previews of both pages:
`page1_sales_overview.png`, `page2_customers_delivery.png`.

1. **Power BI Desktop → Get data → Text/CSV →** `sales_clean.csv` → Load. Repeat for `rfm_segments.csv`.
2. **Model view:** drag `customer_unique_id` from `sales_clean` onto `customer_unique_id` in `rfm_segments`
   (many-to-one, single direction).
3. **New measure** (Home tab), one at a time:
   ```DAX
   Revenue = SUM(sales_clean[price])
   Orders = DISTINCTCOUNT(sales_clean[order_id])
   Customers = DISTINCTCOUNT(sales_clean[customer_unique_id])
   Avg Order Value = DIVIDE([Revenue], [Orders])
   Late % = DIVIDE(CALCULATE(DISTINCTCOUNT(sales_clean[order_id]), sales_clean[is_late] = 1), [Orders])
   ```
4. **Page 1 – Sales overview**
   - 4 Card visuals: Revenue, Orders, Customers, Avg Order Value
   - Line chart: `month` on X-axis, Revenue on Y-axis
   - Bar chart: `category` × Revenue → Filters pane → Top N → 10 by Revenue
   - Filled map or bar chart: `customer_state` × Revenue
   - Slicer: `month`
5. **Page 2 – Customers & delivery**
   - Bar chart: `segment` × count of `customer_unique_id`
   - Bar chart: `segment` × sum of `monetary`
   - Card: Late %
   - Image: `dashboard/cohort_heatmap.png`
6. Title text box on each page; use the same colours everywhere (blue `#1f4e79`, light blue `#9dc3e6`, red `#c0504d`).
7. Save as `dashboard/olist_dashboard.pbix` and screenshot each page into `dashboard/` (Win + Shift + S).
