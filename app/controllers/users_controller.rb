class UsersController < ApplicationController

    get '/signup' do
        if logged_in?
            redirect '/tweets'
        else
            erb :'users/create_user'
        end
    end

    post '/signup' do
        if params[:username] == "" || params[:email] == '' || params[:password] == ""
            redirect to '/signup'
        else
            @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
            @user.save
            session[:user_id] = @user.id
            redirect to '/tweets'
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
        @user = User.find_by(username: params[:username])
        if @user
            session[:user_id] = @user.id
            redirect '/tweets'
        else
            redirect '/signup'
        end
    end

    get '/logout' do
        session.clear
        redirect to '/login'
    end
end
