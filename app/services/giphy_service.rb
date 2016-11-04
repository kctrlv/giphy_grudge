class GiphyService
  def self.get(endpoint, params)
    params = params.merge(api_key: ENV['giphy_key'])
    conn = Faraday.new(url: "http://api.giphy.com")
    response = conn.get(endpoint, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.translate(keyword)
    get("/v1/gifs/translate", {s: keyword} )
  end

  def self.fixed_height_translate(keyword)
    result = translate(keyword)
    result[:data][:images][:fixed_height][:url]
  end
end
