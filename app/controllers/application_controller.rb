# frozen_string_literal: true

require "./config/environment"

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, "public"
    set :views, "app/views"
    enable :sessions
    set :session_secret, "secret"

    get "/" do
      erb :index
    end

    def logged_in?
      current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
