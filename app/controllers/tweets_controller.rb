# frozen_string_literal: true

class TweetsController < ApplicationController

  get "/create_tweet" do
    if logged_in?
      erb :tweets
    else
      redirect "/signup"
    end
  end

  post "/create_tweet" do
    if logged_in?
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect "/signup"
    end
  end
end
