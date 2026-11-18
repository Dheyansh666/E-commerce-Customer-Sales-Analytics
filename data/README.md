# Data

The CSV files are not stored in git (≈ 150 MB). To get them:

1. Download **Brazilian E-Commerce Public Dataset by Olist** from Kaggle:
   https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
   (or: `curl -L -o olist.zip https://www.kaggle.com/api/v1/datasets/download/olistbr/brazilian-ecommerce`)
2. Unzip all CSV files into this `data/` folder.

Files created by the notebooks (also not in git):
- `sales_clean.csv` – export of the MySQL `sales` view (Power BI source)
- `rfm_segments.csv` – RFM scores and segment per customer (Power BI source)
