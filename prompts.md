✅ Cursor Prompt (Complete A-SDLC Task)
### *Use this as the official "Prompt Documentation" inside your project.*

```
You are an AI pair-programmer. Build a complete synthetic e-commerce data pipeline using Python + SQLite.  
Follow the instructions for each numbered task exactly.

====================================================================
1️⃣ TASK — Generate Synthetic E-Commerce Data (generate_data.py)
====================================================================
Create a Python script: generate_data.py

Requirements:
- Generate 5 CSV files under data/ folder:
    • customers.csv: customer_id, name, email, phone, address, join_date
    • products.csv: product_id, name, category, price, sku
    • orders.csv: order_id, customer_id, order_date, total, status
    • order_items.csv: order_item_id, order_id, product_id, quantity, unit_price, line_total
    • reviews.csv: review_id, customer_id, product_id, rating, review_text, review_date
- Ensure valid realistic relationships:
    • orders → customers (customer_id)
    • order_items → orders + products
    • reviews → customers + products
- Numeric and date fields must be consistent.
- order.total = SUM(order_items.line_total) for each order
- Add CLI args:
    --seed (int, default=42) → random seed for reproducibility  
    --scale (float, default=1.0) → dataset size multiplier
- Base dataset sizes (before scaling):
    • 500 customers
    • 200 products
    • 2500 orders
    • ~800 reviews (varies based on orders)
- Use Faker and numpy for synthetic data generation.
- Use pandas for data manipulation.
- Write all CSVs to the data/ directory.

Output:
- Python file: generate_data.py
- 5 CSV files generated inside data/


====================================================================
2️⃣ TASK — Ingest Data into SQLite (ingest_to_sqlite.py)
====================================================================
Create file: ingest_to_sqlite.py

Requirements:
- Read all 5 CSVs created earlier from data/ directory.
- Create a SQLite DB at: database/ecommerce.db
- Create the following tables with constraints:

    customers(
        customer_id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        address TEXT,
        join_date TEXT
    )
    
    products(
        product_id INTEGER PRIMARY KEY,
        name TEXT,
        category TEXT,
        price REAL,
        sku TEXT
    )
    
    orders(
        order_id INTEGER PRIMARY KEY,
        customer_id INTEGER,
        order_date TEXT,
        total REAL,
        status TEXT,
        FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    )
    
    order_items(
        order_item_id INTEGER PRIMARY KEY,
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        unit_price REAL,
        line_total REAL,
        FOREIGN KEY(order_id) REFERENCES orders(order_id),
        FOREIGN KEY(product_id) REFERENCES products(product_id)
    )
    
    reviews(
        review_id INTEGER PRIMARY KEY,
        product_id INTEGER,
        customer_id INTEGER,
        rating INTEGER,
        review_text TEXT,
        review_date TEXT,
        FOREIGN KEY(product_id) REFERENCES products(product_id),
        FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    )

- Enforce PRIMARY KEY and FOREIGN KEY constraints.
- Create indexes for performance:
    • idx_orders_customer ON orders(customer_id)
    • idx_orders_date ON orders(order_date)
    • idx_items_order ON order_items(order_id)
    • idx_items_product ON order_items(product_id)
    • idx_reviews_product ON reviews(product_id)
    • idx_reviews_customer ON reviews(customer_id)
- Use CSV DictReader (not pandas) for reading files.
- Validate referential integrity before insert.
- Handle optional columns gracefully (filter to available columns).
- Use robust ETL-style workflow:
    ✔ data type validation (convert strings to int/float)  
    ✔ missing value checks  
    ✔ try/except error handling  
    ✔ Update order totals from order_items after ingestion
- CLI arguments:
    --data-dir (default: "data") → directory containing CSV files
    --db-path (default: "database/ecommerce.db") → path to SQLite database
    --replace → remove existing DB before ingestion
    --ltv → generate customer_ltv.csv report with lifetime value metrics
- Print clear success/failure messages for each table loaded.
- Use WAL mode and proper SQLite pragmas for performance.

Output:
- Python file: ingest_to_sqlite.py
- SQLite DB created at database/ecommerce.db
- Optional: customer_ltv.csv report (if --ltv flag used)


====================================================================
3️⃣ TASK — Multi-Table SQL Analytics (queries.sql)
====================================================================
Create SQL file: sql/queries.sql

Include the following advanced multi-table analytics queries:

Required Queries (1-6):
1. Top 10 customers by lifetime spend (sum of completed orders)
   - Show customer_id, name, email, lifetime_spend, completed_orders
2. Top 10 products by revenue and total units sold
   - Show product_id, name, category, units_sold, total_revenue, avg_price
3. Monthly revenue trends (last 12 months)
   - Show order_month, revenue, order_count, avg_order_value
4. Top 20 customers by average review rating  
   - Minimum 3 reviews required
   - Show customer_id, name, email, avg_rating, review_count
5. Revenue contribution by product category
   - Show category, category_revenue, total_units_sold, product_count, revenue_percentage
6. Customer lifetime value (CLV):  
   - total spending  
   - number of orders  
   - average order value  
   - first and last order dates
   - completed vs cancelled order counts

Additional Queries (7-10):
7. Product performance by category
   - Revenue, units sold, average rating by category
8. Customer acquisition and retention trends
   - New customers by month with revenue metrics
9. Order status distribution
   - Status breakdown with percentages and revenue
10. Highest-rated products (minimum 5 reviews)
    - Products with best ratings and sales performance

Requirements:
- Use proper JOINs (INNER, LEFT), GROUP BY, ORDER BY, HAVING.
- Include CTEs (WITH clauses) where appropriate.
- Include subqueries where needed.
- All queries must run on SQLite without modification.
- Use proper date formatting with strftime for SQLite.
- Round monetary values to 2 decimal places.

Output:
- SQL file: sql/queries.sql  
- Executable with:
    sqlite3 database/ecommerce.db ".read sql/queries.sql"
- All 10 queries should be properly formatted and commented


====================================================================
FINAL REQUIREMENTS
====================================================================
- Maintain clean project structure:
    data/               # Generated CSV files
    database/           # SQLite database
    sql/                # SQL query files
    generate_data.py    # Data generation script
    ingest_to_sqlite.py # Ingestion script
    requirements.txt    # Dependencies
    README.md           # Documentation

- Generate only valid, runnable code.
- Use Python standard libraries + faker + pandas + numpy + sqlite3.
- All scripts must run end-to-end without modification.
- Code should be production-ready with proper error handling.
- Include type hints and docstrings for maintainability.
```

---

## ✅ Implementation Status

**generate_data.py** ✅ Complete
- Generates all 5 CSV files with correct schema
- Supports --seed and --scale parameters
- Base sizes: 500 customers, 200 products, 2500 orders, 800 reviews
- Uses Faker, numpy, and pandas

**ingest_to_sqlite.py** ✅ Complete
- Reads CSVs using CSV DictReader
- Creates all tables with proper constraints and indexes
- Supports --replace and --ltv flags
- Updates order totals from order_items
- Handles optional columns gracefully

**queries.sql** ✅ Complete
- Contains all 10 analytics queries
- Uses proper JOINs, CTEs, and subqueries
- All queries tested and working
- Properly formatted and commented

---

## 🚀 Quick Start

```bash
# 1. Generate data
python generate_data.py --seed 42 --scale 1.0

# 2. Ingest into database
python ingest_to_sqlite.py --replace

# 3. Run analytics
sqlite3 database/ecommerce.db ".read sql/queries.sql"

# Optional: Generate LTV report
python ingest_to_sqlite.py --ltv
```
