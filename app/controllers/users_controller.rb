class UsersController < ApplicationController

  def about
    @author = User.first
  end

end
