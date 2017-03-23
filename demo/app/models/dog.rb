require 'sqlite3'

DOGS = {
  'pupper1' => "http://stories.barkpost.com/wp-content/uploads/2013/02/tumblr_mbl5larwCV1qdoqhwo1_500.gif",
  'pupper2' => "http://stories.barkpost.com/wp-content/uploads/2013/02/tumblr_mahffvX0He1r2gqh6o1_500.gif",
  'pupper3' => "http://s3.amazonaws.com/barkpost-assets/50+GIFs/37.gif",
  'pupper4' => "http://www.doggifpage.com/gifs/143.gif",
  'pupper5' => "http://stories.barkpost.com/wp-content/uploads/2013/03/oie_5181838bU3HJXJp.gif",
  'pupper6' => "https://media.giphy.com/media/cWKovZswJIEqA/giphy.gif",
  'pupper7' => "http://www.doggifpage.com/gifs/110.gif",
  'pupper8' => "https://media.giphy.com/media/13mLwGra9bNEKQ/giphy.gif"
}

db = SQLite3::Database.new 'dogs.db'

dogs = db.execute <<-SQL
  CREATE TABLE dogs (
    name VARCHAR(30),
    age INT
  );
SQL

DOGS.each do |pair|
  db.execute 'insert into dogs values (?, ?)', pair
end


db.execute 'SELECT * FROM dogs' do |row|
  p row
end
