class WelcomeController < ApplicationController
  def home
    @user = User.all
  end
end
