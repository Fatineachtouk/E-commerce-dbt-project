import duckdb

connection = duckdb.connect('dev.duckdb')

tables = ['orders', 'events', 'users', 'inventory_items', 'products', 'order_items']

for table in tables:
    connection.execute(f"""
       CREATE OR REPLACE TABLE {table} AS
       SELECT * FROM read_csv_auto('data/{table}.csv',
       sample_size=-1);
    """)
# sample_size=-1 tells duckdb to inpect th entire dataset , because duckdb guessed the gender column as Boolean

print('Tables loadd successfully!')
connection.close()