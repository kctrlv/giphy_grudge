require "rails_helper"

RSpec.describe GiphyService do
  it 'can get full translation by keyword' do
    keyword = 'superman'
    result = GiphyService.translate(keyword)
    expect(result[:data][:type]).to eq("gif")
  end

  it 'can get fixed height image by keyword' do
    keyword = 'superman'
    result = GiphyService.fixed_height_translate(keyword)
    expect(result[-7..-1]).to eq('200.gif')
  end
end
