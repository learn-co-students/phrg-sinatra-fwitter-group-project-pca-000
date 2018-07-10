class TweetsController < ApplicationController


    get '/tweets/new' do
        erb :'tweets/create_tweet'
    end

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        redirect to '/tweets'
    end

    get '/tweets/:id' do

    end

    get '/tweets/:id/edit_tweet' do

    end

    post '/tweets/:id' do

    end
end
