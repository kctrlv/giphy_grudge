require 'rails_helper'

RSpec.describe Card, type: :model do
  context "validations" do
    it { should validate_presence_of(:title)}
  end
end
