require 'httparty'

class UrlApi
  PIXABAY_URL = 'https://pixabay.com/api/?key='

  def pixabay_search(search_query)
    key = ENV['PIXABAY_KEY'] + '&q='
    response = HTTParty.get(PIXABAY_URL + key + search_query)
    print(PIXABAY_URL + key + search_query)
    json = JSON.parse(response.body)
  end
end
