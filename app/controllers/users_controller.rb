# frozen_string_literal: true

class UsersController < ApplicationController
  get "/signup" do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to "/tweets"
    end
  end

  post "/signup" do
    user = User.new(username: params[:username],
                    email: params[:email],
                    password: params[:password])
    user.save
    # binding.pry
    if user.username != "" \
      && user.password \
      && user.authenticate(params["password"]) \
      && user.email != ""
      session["user_id"] = user.id
      # binding.pry
      redirect "/tweets"
    else
      redirect "/signup"
    end
  end

  get "/login" do
    if !logged_in?
      erb :'users/login'
    else
      redirect "/tweets"
    end
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session["user_id"] = user.id
      redirect "/tweets"
    else
      redirect to "/signup"
    end
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get "/logout" do
    if !logged_in?
      redirect "/"
    else
      session.clear
      redirect "/login"
    end
  end
end
