# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
class Seed

  def self.start
    seed_cards
  end

  def self.seed_cards
    cards_file = File.open('./data/cards.txt')
    cards_file.readlines.each do |line|
      Card.create(title: line.strip)
    end
  end
end

Seed.start
