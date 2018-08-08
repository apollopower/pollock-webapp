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
  end

  def analyze
    api = ImageAnalysis.new()
    @labels = api.get_labels(params[:image_url])
    @emotions = api.get_emotions(@labels)
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
