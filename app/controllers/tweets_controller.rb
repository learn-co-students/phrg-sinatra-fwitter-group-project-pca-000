# frozen_string_literal: true

class TweetsController < ApplicationController
  get "/tweets" do
    if logged_in? && current_user
      @tweets = Tweet.all
      erb :"tweets/tweets"
    else
      redirect "/login"
    end
  end

  post "/tweets" do
    if logged_in?
      if params["content"] == ""
        redirect to "/tweets/new"
      else
        @tweet = current_user.tweets.new(content: params[:content])
        if @tweet.save
          redirect to "/tweets/#{@tweet.id}"
        else
          redirect to "/tweets/new"
        end
      end
    else
      redirect to "/login"
    end
  end

  get "/tweets/new" do
    if logged_in? && current_user
      erb :"tweets/create_tweet"
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
      erb :"tweets/show_tweet"
      # binding.pry
    else
      redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    if logged_in?
      @tweet = Tweet.find_by_id(params["id"])
      if @tweet && @tweet.user == current_user
        erb :'tweets/edit_tweet'
      else
        redirect to "/tweets"
      end
    else
      redirect to "/login"
    end
  end

  patch "/tweets/:id/edit" do
    # binding.pry
    if params["content"] != ""
      @tweet = Tweet.find(params["id"])
      @tweet.content = params["content"]
      @tweet.save
    else
      @user = User.find(params["id"])
      redirect "/tweets/#{@user.id}/edit"
    end
  end

  delete "/tweets/:id/delete" do
    if logged_in?
      @tweet = Tweet.find_by_id(params["id"])
      @tweet.delete if @tweet && @tweet.user == current_user
      redirect to "/tweets"
    else
      redirect to "/login"
    end
  end
end
