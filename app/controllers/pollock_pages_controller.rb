require 'url_api'
require 'analysis_api'

class PollockPagesController < ApplicationController
  before_action :logged_in_user, only: [:main, :new, :create, :show, :analyze]

  def main
  end
  
  def new
  end

  def show
    api = UrlApi.new()
    @json = api.pixabay_search(params[:business_category])
    if @json['hits'].length < 1
      redirect_to root_path
      flash[:warning] = "Sorry, Pollock can't find any images based on your query."
    end
  end

  def analyze
    api = ImageAnalysis.new()
    unless params[:image_url][0..9].include?('data:image')
      @labels = api.get_labels(params[:image_url])
      @emotions = api.get_emotions(@labels)
    else
      redirect_to root_path
      flash[:warning] = "Sorry, not a valid image URL"
    end
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # def remote_image_exists?(url)
      # return false if url[0..9].include?('data:image')
      # url = URI.parse(url)
      # Net::HTTP.start(url.host, url.port) do |http|
        # return http.head(url.request_uri)['Content-Type'].start_with? 'image'
      # end
    # end

end
