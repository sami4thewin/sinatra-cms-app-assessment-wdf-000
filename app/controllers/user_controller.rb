class UserController < ApplicationController

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  get '/users/signup' do
    erb :'/users/signup'
  end

  post '/users' do
    submitted_email = params[:email]
    binding.pry
    if submitted_email.match(VALID_EMAIL_REGEX) != nil
      @user = User.find_or_create_by(params)
      session[:id] = @user.id
      redirect '/users/home'
    else
      #put a flash message
      redirect to '/users/signup'
    end
  end

  get '/users/login' do
    erb :'/users/login'
  end

  get '/users/home' do
    @user = User.find(session[:id])
    erb :'/users/home'
  end

  get '/users/logout' do
    session.clear
    redirect to '/'
  end

end
