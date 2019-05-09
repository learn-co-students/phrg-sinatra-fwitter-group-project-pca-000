# frozen_string_literal: true

class UsersController < ApplicationController
  get "/signup" do
    if !!session[:user_id]
      redirect '/tweets'
    else
      erb :signup
    end
  end

  get "/login" do
    if !logged_in?
      erb :'/users/login'
    else
      redirect "/tweets"
    end
  end

  post "/signup" do
    if params[:username] == "" || params[:email] == "" || params[:password] == "" || !!session[:user_id]
      redirect "/signup"
    else
      user = User.create(
        username: params[:username],
        email: params[:email],
        password: params[:password]
        )
      session[:user_id] = user.id
      redirect "/tweets"
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      erb :"/signup"
    end
  end

  get "/logout" do
    session.clear
    redirect "/"
  end
end
