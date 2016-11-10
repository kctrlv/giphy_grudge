class GameController < ApplicationController
  def show
    @game = Game.new
  end
end
