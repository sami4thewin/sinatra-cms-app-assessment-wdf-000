class UserController < ApplicationController

  get '/users/signup' do
    erb :signup
  end

  post '/users' do
    @user = User.find_or_create_by(params)
    session[:id] = @user.id
    redirect '/users/home'
  end

  get '/users/login' do
    erb :login
  end

  get '/users/home' do
    @user = User.find(session[:id])
    erb :home
  end

end
