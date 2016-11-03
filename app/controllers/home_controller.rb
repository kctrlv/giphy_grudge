class HomeController < ApplicationController
  def index
    redirect_to lobby_path if current_user
  end

  def restricted
    render text: "Sorry, this app is restricted to users of a particular Team"
  end
end
