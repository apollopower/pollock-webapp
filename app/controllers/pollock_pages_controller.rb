require 'url_api'

class PollockPagesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :show]

  def new
  end

  def create
    redirect_to root_url
  end

  def show
    api = UrlApi.new()
    @json = api.pixabay_search(params[:business_category])
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
