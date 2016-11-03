require 'rails_helper'

RSpec.describe Game, type: :model do
  context "validations" do
    it { should validate_presence_of(:status)}
  end

  context 'associations' do
    it { should have_many(:users) }
  end
end
