require 'sqlite3'
require 'active_record'


ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'THE_ROCKS',
  username: 'KYLE',
  password: 'PASSWORD',
  port: '8080',
  host: 'localhost'
)
