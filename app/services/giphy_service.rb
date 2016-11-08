class GiphyService
  def self.get(endpoint, params)
    params = params.merge(api_key: ENV['giphy_key'])
    conn = Faraday.new(url: "http://api.giphy.com")
    response = conn.get(endpoint, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.translate(keyword)
    result = get("/v1/gifs/translate", {s: keyword.tr(' ','+')} )
    if !result[:data] || result[:data].empty?
      get("/v1/gifs/translate", {s: 'error'} )
    else
      result
    end
  end

  def self.fixed_height_translate(keyword)
    result = translate(keyword)
    result[:data][:images][:fixed_height][:url]
  end

  def self.random_image
    result = get("/v1/gifs/random", {})
    result[:data][:fixed_height_downsampled_url]
  end
end
