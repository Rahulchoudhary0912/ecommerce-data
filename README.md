

# 📦 Synthetic E-Commerce Data Pipeline

### *Python + SQLite | Synthetic Data Generation | ETL + Analytics Engine*

This project implements a complete **synthetic e-commerce data pipeline**, built using **Cursor IDE**, **Python**, **SQLite**, and a modular A-SDLC workflow.

It includes:

* Realistic synthetic dataset generation
* Strong-schema SQLite ingestion (ETL)
* Advanced multi-table analytics with SQL
* Optional Customer Lifetime Value (LTV) reporting

This README documents the entire setup, workflow, and commands required to run and extend the project.

---

# 🏗 Project Structure

```
project/
│
├── data/                         # Auto-generated CSV files
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   ├── order_items.csv
│   └── reviews.csv
│
├── database/
│   └── ecommerce.db              # SQLite database (generated)
│
├── sql/
│   └── queries.sql               # Multi-table analytics queries
│
├── generate_data.py              # Synthetic data generator
├── ingest_to_sqlite.py           # ETL ingestion script
├── requirements.txt              # Dependencies
└── README.md                     # Project documentation
```

---

# 1️⃣ Synthetic Data Generator — `generate_data.py`

This script produces realistic, consistent e-commerce datasets using **Faker**, **NumPy**, and **Pandas**.

### 📂 Generated CSV Files

| File              | Contains                                                              |
| ----------------- | --------------------------------------------------------------------- |
| `customers.csv`   | customer_id, name, email, phone, address, join_date                   |
| `products.csv`    | product_id, name, category, price, sku                                |
| `orders.csv`      | order_id, customer_id, order_date, total, status                      |
| `order_items.csv` | order_item_id, order_id, product_id, quantity, unit_price, line_total |
| `reviews.csv`     | review_id, customer_id, product_id, rating, review_text, review_date  |

---

### ✨ Features

* **Valid relational structure** (customers → orders → order_items → reviews)
* **Deterministic generation** (seeded PRNG)
* **Scalable dataset** (`--scale` multiplies record counts)
* **Accurate totals**:
  `order.total = SUM(order_items.line_total)`
* **Realistic distribution patterns** using numpy
* **Write to `data/` folder automatically**

### 📌 Base Dataset Sizes (before scaling)

| Table       | Base Rows                |
| ----------- | ------------------------ |
| customers   | 500                      |
| products    | 200                      |
| orders      | 2,500                    |
| reviews     | ~800                     |
| order_items | auto-generated per order |

---

### ▶ Run Generator

```bash
python generate_data.py --seed 42 --scale 1.0
```

---

# 2️⃣ ETL Ingestion — `ingest_to_sqlite.py`

This script loads all CSVs into a relational SQLite database **with full constraints** and **ETL-grade validation**.

---

### 🧱 SQLite Database Schema

#### **customers**

```
customer_id INTEGER PK
name TEXT
email TEXT UNIQUE
phone TEXT
address TEXT
join_date TEXT
```

#### **products**

```
product_id INTEGER PK
name TEXT
category TEXT
price REAL
sku TEXT
```

#### **orders**

```
order_id INTEGER PK
customer_id INTEGER FK
order_date TEXT
total REAL
status TEXT
```

#### **order_items**

```
order_item_id INTEGER PK
order_id INTEGER FK
product_id INTEGER FK
quantity INTEGER
unit_price REAL
line_total REAL
```

#### **reviews**

```
review_id INTEGER PK
product_id INTEGER FK
customer_id INTEGER FK
rating INTEGER
review_text TEXT
review_date TEXT
```

---

### ⚡ Performance Indexes

* `idx_orders_customer ON orders(customer_id)`
* `idx_orders_date ON orders(order_date)`
* `idx_items_order ON order_items(order_id)`
* `idx_items_product ON order_items(product_id)`
* `idx_reviews_product ON reviews(product_id)`
* `idx_reviews_customer ON reviews(customer_id)`

---

### 🛠 ETL Features

* Reads CSVs using **csv.DictReader** (not pandas)
* Strict type conversion & validation
* Missing value checks
* Full referential integrity validation
* Updates order totals based on order_items rows
* Uses **WAL mode** + optimized SQLite pragmas
* Supports automated **Customer LTV Report**

---

### ▶ Run ETL

```bash
python ingest_to_sqlite.py --replace
```

### ▶ Generate LTV Report

```bash
python ingest_to_sqlite.py --ltv
```

LTV output file:

```
customer_ltv.csv
```

---

# 3️⃣ Multi-Table Analytics — `sql/queries.sql`

This file contains **10 fully-documented analytics queries**, optimized for SQLite.

---

## ✔ Required Analytics Queries (1–6)

1. **Top 10 customers by lifetime spend**
2. **Top 10 products by revenue + units sold**
3. **Monthly revenue trends (last 12 months)**
4. **Top 20 customers by average rating (min 3 reviews)**
5. **Revenue contribution by product category**
6. **Customer Lifetime Value (CLV) Report**

   * total spending
   * number of orders
   * average order value
   * first & last order dates
   * completed vs cancelled order ratio

---

## ✔ Additional Analytics Queries (7–10)

7. Product performance by category
8. Customer acquisition & retention trends
9. Order status distribution
10. Highest-rated products (min 5 reviews)

---

### ▶ Execute all queries

```bash
sqlite3 database/ecommerce.db ".read sql/queries.sql"
```

---

# 🧪 Quick Start (End-to-End)

```bash
# 1. Generate synthetic data
python generate_data.py --seed 42 --scale 1.0

# 2. Ingest into SQLite database
python ingest_to_sqlite.py --replace

# 3. Run analytics
sqlite3 database/ecommerce.db ".read sql/queries.sql"

# (Optional) Produce Customer LTV report
python ingest_to_sqlite.py --ltv
```

---

# 📦 Requirements

```
faker
pandas
numpy
sqlite3
```

Install:

```bash
pip install -r requirements.txt
```

---

# 📘 Implementation Status

| Component           | Status     | Notes                          |
| ------------------- | ---------- | ------------------------------ |
| generate_data.py    | ✅ Complete | Seed + scale supported         |
| ingest_to_sqlite.py | ✅ Complete | ETL validation + indexes + LTV |
| queries.sql         | ✅ Complete | 10 advanced analytics queries  |
| Project structure   | ✅ Clean    | Cursor-ready A-SDLC compliant  |

---

# 📜 License

 2025 rahul. All rights reserved.

---

