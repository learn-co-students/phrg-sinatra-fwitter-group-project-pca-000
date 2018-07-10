# frozen_string_literal: true

require "./config/environment"

class ApplicationController < Sinatra::Base
  configure do
    enable :sessions
    set :public_folder, "public"
    set :views, "app/views"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    user = nil
    if !User.all.empty?
      user = User.all[0]
      session[:user_id] = user.id
    end

    if logged_in? && current_user
      redirect "/tweets"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
    user.save
    if user.username != "" && user.password && user.authenticate(params["password"]) && user.email != ""
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/signup"
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

  get "/login" do

    if logged_in? && current_user
      redirect "/tweets"
    else
      erb :"/users/login"
    end

  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
        redirect "/tweets"
    else
        redirect "/login"
    end
  end

  get "/logout" do
    if logged_in? && current_user
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end

  get "/users/:slug" do
    @user = User.find_by(username: params["slug"])

    erb :"/users/show"
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
    elsif
      logged_in? && current_user && params["content"] == ""
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

  delete "/tweets/:id/delete" do

    @user = User.find(params["id"])

    if current_user == @user

      @tweet = Tweet.find(params["id"])
      @tweet.destroy
    else
      redirect "/tweets"
    end
  end

  get "/tweets/:id/edit" do

    if logged_in?
      @tweet = Tweet.find(params["id"])
    erb :"/tweets/edit_tweet"
  else
      redirect "/login"
    end
  end

  patch "/tweets/:id" do

    if params["content"] != ""
      @tweet = Tweet.find(params["id"])
      @tweet.content = params["content"]
      @tweet.save
    else
      @user = User.find(params["id"])
      redirect "/tweets/#{@user.id}/edit"
    end
    # binding.pry
    # erb :"/tweets/show_tweet"
  end

  def current_user
    User.find(session[:user_id])
  end

  def logged_in?
    !!session[:user_id]
  end
end
