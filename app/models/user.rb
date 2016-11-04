class User < ApplicationRecord
  validates :uid, presence: true
  validates :name, presence: true

  def first_name
    name.split(' ').first
  end
end
