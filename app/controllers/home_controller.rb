class HomeController < ApplicationController
  def index
  end

  def restricted
    render text: "Sorry, this app is restricted to users of a particular Team"
  end
end
