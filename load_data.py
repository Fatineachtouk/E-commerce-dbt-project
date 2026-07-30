import duckdb
from pathlib import Path

connection = duckdb.connect('dev.duckdb')

files = {
    'orders': 'orders.csv',
    'events': 'events.csv',
    'users': 'users.csv',
    'inventory_items': 'inventory_items.csv',
    'products': 'products.csv',
    'order_items': 'order_items.csv',
}


for table, filename in files.items():
    path = (Path('data') / filename).as_posix()
    connection.execute(f"""
       CREATE OR REPLACE TABLE {table} AS
       SELECT * FROM read_csv_auto('{path}', sample_size=-1);
    """)
# sample_size=-1 tells duckdb to inspect the entire dataset, because duckdb guessed the gender column as Boolean

print('Tables loaded successfully!')
connection.close()