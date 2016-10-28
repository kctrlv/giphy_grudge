class User < ApplicationRecord
  validates :uid, presence: true
  validates :name, presence: true
end
