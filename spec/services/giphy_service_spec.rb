require "rails_helper"

RSpec.describe GiphyService do
  it 'can get full translation by keyword' do
    keyword = 'superman is cool'
    result = GiphyService.translate(keyword)
    expect(result[:data][:type]).to eq("gif")
  end

  it 'can get fixed height image by keyword' do
    keyword = 'superman'
    result = GiphyService.fixed_height_translate(keyword)
    expect(result[-7..-1]).to eq('200.gif')
  end

  it 'can get random image' do
    result = GiphyService.random_image
    expect(result[-9..-1]).to eq('200_d.gif')
  end
end
