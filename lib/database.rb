require 'sqlite3'


def database(db_name)
  SQLite3::Database.new '${db_name}.db'
end

dogs = db.execute <<-SQL
  CREATE TABLE dogs (
    name VARCHAR(30),
    url VARCHAR(30)
  );
SQL
