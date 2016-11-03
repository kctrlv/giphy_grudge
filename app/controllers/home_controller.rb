class HomeController < ApplicationController
  def index
    @user = current_user if current_user
  end

  def restricted
    render text: "Sorry, this app is restricted to users of a particular Team"
  end
end
