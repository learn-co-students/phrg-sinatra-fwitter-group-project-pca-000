# frozen_string_literal: true

class TweetsController < ApplicationController
  get "/tweets" do
    if logged_in?
      @tweets = Tweet.all
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

  post "/tweets" do
    if logged_in?
      if params[:content] == ""
        redirect "tweets/new"
      else
        @tweet = current_user.tweets.build(content: params[:content])
        @tweet.save
        redirect to "/tweets"
      end
    end
  end

  get "/tweets/:id" do
    if logged_in?
      @tweet = Tweet.find_by(id: params[:id])
      erb :"tweets/show_tweet"
    else
      redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    if logged_in?
      @tweet = current_user.tweets.find_by(id: params[:id])
      erb :"tweets/edit_tweet" if @tweet
    else
      redirect "/login"
    end
  end

  patch "/tweets/:id" do
    @tweet = current_user.tweets.find_by(id: params[:id])
    @tweet.content = params[:content]
    if params[:content] == ""
      redirect "tweets/#{@tweet.id}/edit"
    else
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    end
  end

  delete "/tweets/:id/delete" do
    if logged_in?
      @tweet = current_user.tweets.find_by(id: params[:id])
      if @tweet
        @tweet.delete
        redirect "/tweets"
      end
    else
      redirect "/login"
    end
  end
end
