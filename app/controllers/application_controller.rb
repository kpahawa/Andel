class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  a = User.find_by(email: 'a@a.com')
  if a.longitude == nil
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
  end

end
