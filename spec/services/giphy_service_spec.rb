require "rails_helper"

RSpec.describe GiphyService do
  it 'can get fixed height image by keyword' do
    keyword = 'superman'
    result = GiphyService.translate(keyword)
    byebug
  end
end
