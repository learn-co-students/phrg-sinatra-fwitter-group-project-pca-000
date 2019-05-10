# frozen_string_literal: true

class TweetsController < ApplicationController
  get "/tweets" do
    if logged_in? && current_user
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect "/login"
    end
  end

  get "/tweets/new" do
    if logged_in? && current_user
      erb :'/tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post "/tweets" do
    if logged_in? && current_user
      if params[:content] == ""
        redirect "/tweets/new"
      else
        @tweet = current_user.tweets.build(content: params[:content])
        if @tweet.save
          redirect "/tweets/#{@tweet.id}"
        else
          redirect "/tweets/new"
        end
      end
    else
      redirect "/login"
    end
  end

  get "/tweets/:id" do
    if logged_in? && current_user
      @tweet = Tweet.find(params[:id])
      erb :"tweets/show_tweet"
    else
      redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
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
    tweet = Tweet.find_by_id(params[:id])
    tweet.update(content: params[:content]) unless params[:content] == ""
    redirect "/tweets/#{tweet.id}/edit"
  end

  delete "/tweets/:id/delete" do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.delete if @tweet && @tweet.user == current_user
      redirect to "/tweets"
    else
      redirect to "/login"
    end
  end
end
