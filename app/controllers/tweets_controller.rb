# frozen_string_literal: true

class TweetsController < ApplicationController
  get "/tweets" do
    # @user = User.find_by_id(session[:user_id])
    @tweets = Tweet.all
    if logged_in?
      erb :'tweets/tweets'
    else
      redirect "/login"
    end
  end

  get "/tweets/new" do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post "/tweets/new" do
    if params[:content] != ""
      @tweet = Tweet.new(content: params[:content], user_id: session[:user_id])
      @tweet.save
      redirect "/users/#{current_user.slug}"
    else
      redirect "/tweets/new"
    end
  end

  get "/tweets/:id" do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      erb :'tweets/show_tweet'
    else
      redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      erb :'tweets/edit_tweet'
    else
      redirect "/login"
    end
  end

  patch "/tweets/:id" do
    @tweet = Tweet.find_by_id(params[:id])
    if params[:content] != ""
      @tweet.content = params[:content]
      @tweet.save
      redirect "tweets/#{@tweet.id}"
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  delete "/tweets/:id/delete" do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && current_user.id == @tweet.user_id
      @tweet.delete
      redirect "/tweets"
    else
      redirect "/login"
    end
  end
end
