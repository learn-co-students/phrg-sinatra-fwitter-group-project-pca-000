# frozen_string_literal: true

require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "asdfnoi"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :'/users/create_user'
  end

  post "/signup" do
    user = User.new(username: params[:username],
                    email: params[:email],
                    password: params[:password])
    user.save
    # binding.pry
    if user.username != "" && user.password && user.authenticate(params["password"]) && user.email != ""
      session[:user_id] = user.id
      # binding.pry
      redirect "/tweets"
    else
      redirect "/signup"
    end
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/tweets'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect to '/signup'
    end
  end

  get "/tweets" do
    if logged_in? && current_user
      @user = User.find(session[:user_id])
      erb :"/tweets/tweets"
    else
      redirect "/login"
    end
  end

  get "/tweets/new" do
    if logged_in? && current_user
      erb :"/tweets/create_tweet"
    else
      redirect "/login"
    end
  end

  post "/tweets/new" do
    if logged_in? && current_user && params["content"] != ""
      @user = current_user
      @tweet = Tweet.create(content: params["content"], user_id: @user.id)
    elsif logged_in? && current_user && params["content"] == ""
      redirect "/tweets/new"
    end
  end

  get "/tweets/:id" do
    if logged_in? && current_user
      @tweet = Tweet.find(params["id"])
      erb :"/tweets/show_tweet"
    else
      redirect "/login"
    end
  end

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

end
