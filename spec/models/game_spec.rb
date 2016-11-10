require 'rails_helper'

RSpec.describe Game, type: :model do
  context "validations" do
    it { should validate_presence_of(:status)}
  end
end
