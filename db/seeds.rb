# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

bob = User.find_by(email: 'bob@bob.com')
a = User.find_by(email: 'a@a.com')
b = User.find_by(email: 'b@b.com')
c = User.find_by(email: 'c@c.com')
d = User.find_by(email: 'd@d.com')
e = User.find_by(email: 'e@e.com')
f = User.find_by(email: 'f@f.com')
sql = "UPDATE Users SET latitude=37.746570,longitude=-122.416657 WHERE email='bob@bob.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.754811,longitude=-122.413212 WHERE email='a@a.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.764667,longitude=-122.425175 WHERE email='b@b.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.758119,longitude=-122.453338 WHERE email='c@c.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.717962,longitude=-122.442148 WHERE email='d@d.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.669092,longitude=-122.475350 WHERE email='e@e.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.606561,longitude=-122.389519 WHERE email='f@f.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.572495,longitude=-122.340770 WHERE email='h@h.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.692128,longitude=-122.482219 WHERE email='i@i.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.756894,longitude=-122.495609 WHERE email='j@j.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.783490,longitude=-122.478786 WHERE email='k@k.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.801667,longitude=-122.440162 WHERE email='l@l.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.807499,longitude=-122.411666 WHERE email='m@m.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.795427,longitude=-122.407546 WHERE email='n@n.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.422588,longitude=-122.084155 WHERE email='g@g.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.787559,longitude=-122.391238 WHERE email='o@o.com';"
ActiveRecord::Base.connection.execute(sql)

# usera_all = User.all
#
# usera_all.each do |user|
#   puts(user.email)
#   puts(user.username)
#
#   puts(user.longitude)
#   puts(user.latitude)

# end