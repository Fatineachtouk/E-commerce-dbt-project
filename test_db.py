import duckdb

conn = duckdb.connect("dev.duckdb")

print(conn.execute("SHOW TABLES").fetchall())

conn.close()