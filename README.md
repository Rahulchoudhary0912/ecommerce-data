# E-commerce Data Generator

Generate synthetic e-commerce datasets, ingest them into SQLite, and run analytical SQL queries.

## Project Structure

```
data/               # Generated CSVs (customers, products, orders, order_items, payments)
ingest/ingest.py    # Loads CSVs into a SQLite database
sql/queries.sql     # Sample analytical queries
main.py             # Synthetic data generator
requirements.txt    # Python dependencies (faker, pandas)
```

## Getting Started

1. **Install dependencies**
   ```
   pip install -r requirements.txt
   ```

2. **Generate synthetic CSV files**
   ```
   python main.py
   ```
   CSVs (~500 rows each) are created in `data/`.

3. **Ingest into SQLite**
   ```
   python ingest/ingest.py
   ```
   This creates `ecom.db` with five populated tables and prints `Ingestion complete`.

4. **Run sample SQL**
   Use your preferred SQLite client to execute the queries in `sql/queries.sql`.

## GitHub Setup & Cursor Integration

1. **Create a GitHub repository**
   - Visit https://github.com/new and create a repo named `ecommerce-data` (or any name you prefer).

2. **Initialize Git locally (sample commands)**
   ```
   echo "# ecommerce-data" >> README.md
   git init
   git add README.md
   git commit -m "first commit"
   git branch -M main
   git remote add origin https://github.com/Rahulchoudhary0912/ecommerce-data.git
   git push -u origin main
   ```
   Replace the remote URL if you are using a different repository.

3. **Connect Cursor to GitHub**
   - In Cursor, open *Settings → Account → GitHub Integration*.
   - Follow the prompts to authorize Cursor with GitHub and select your repository.
   - After connecting, you can open the repo directly in Cursor for collaborative editing.

4. **Push ongoing work from Cursor**
   ```
   git add .
   git commit -m "Add synthetic data pipeline"
   git push -u origin main
   ```
   Cursor will use your local Git setup; once pushed, your GitHub repo is updated.

## SQL Highlights

- Full order line report joining customers, orders, items, products, and payments.
- Top 10 customers by total spending.

## Next Steps

- Extend `main.py` to add inventory or shipment datasets.
- Expand `queries.sql` with cohort or retention analyses.
