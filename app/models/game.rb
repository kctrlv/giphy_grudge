class Game < ApplicationRecord
  has_many :users
  validates_presence_of :status
end
