

# ✅ **Cursor Prompt (Complete A-SDLC Task)**

#

```
You are an AI pair-programmer. Complete all steps below and generate all required code and files.

===========================
TASK 1 — GitHub Setup
===========================
Create a new project with the following structure:

/data/
    (empty initially — synthetic CSVs will be generated here)
/ingest/
    ingest.py
/sql/
    queries.sql
main.py
requirements.txt
README.md

Add clear instructions in the README on:
- Creating a GitHub repo
- Connecting Cursor to GitHub
- Pushing the generated code

===========================
TASK 2 — Generate 5 synthetic e-commerce CSV files
===========================
Write Python code in main.py to generate **5 CSV datasets** (~500 rows each):

1. customers.csv  
   - customer_id, name, email, phone, city, signup_date

2. products.csv  
   - product_id, product_name, category, price

3. orders.csv  
   - order_id, customer_id, order_date, total_amount

4. order_items.csv  
   - order_item_id, order_id, product_id, quantity, line_total

5. payments.csv  
   - payment_id, order_id, payment_method, payment_status, payment_date

Requirements:
- Use `faker` for realistic data
- Ensure foreign keys match
- Save all files in /data/

===========================
TASK 3 — Ingest data into SQLite
===========================
Write ingest/ingest.py that:

- Creates a SQLite database `ecom.db`
- Creates tables (customers, products, orders, order_items, payments)
- Loads the CSV files into the database
- Prints “Ingestion complete” after successful load

Add this CLI command in main.py:

    python ingest/ingest.py

===========================
TASK 4 — SQL query across multiple tables
===========================
Inside /sql/queries.sql generate an SQL query that:

- Joins customers, orders, order_items, products, payments
- Returns:

  customer_name,
  order_id,
  order_date,
  product_name,
  quantity,
  line_total,
  total_order_amount,
  payment_method,
  payment_status

- Add a second query: "Top 10 customers by total spending"

===========================
FINAL REQUIREMENTS
===========================
- Code must run without modification.
- Use only sqlite3 + pandas + faker.
- Keep code clean, modular, and well-structured.
```

---

I