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
kpahawa = User.find_or_initialize_by(email: 'kpahawa@gmail.com')
sql = "UPDATE Users SET latitude=37.79870987,longitude=-122.49419633 WHERE email='bob@bob.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.82954724,longitude=-122.43192352 WHERE email='a@a.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.8209866,longitude=-122.4598095 WHERE email='b@b.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.8119052,longitude=-122.43173582 WHERE email='c@c.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.75647334,longitude=-122.36369386 WHERE email='d@d.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.81178359,longitude=-122.4396016 WHERE email='e@e.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.73665126,longitude=-122.40772316 WHERE email='f@f.com';"
ActiveRecord::Base.connection.execute(sql)
sql = "UPDATE Users SET latitude=37.78532126,longitude=-122.40340347 WHERE email='g@g.com';"
ActiveRecord::Base.connection.execute(sql)