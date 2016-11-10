class User < ApplicationRecord
  validates :uid, presence: true
  validates :name, presence: true

  def first_name
    name.split(' ').first
  end

  def add_point
    increment!(:points)
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'user_update_points',
      uid: id,
      points: points
    }

  end
end
