class UserController < ApplicationController

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  get '/users/signup' do
    erb :'/users/signup'
  end

  post '/users/signup' do
    submitted_email = params[:email]
    # binding.pry
    if submitted_email.match(VALID_EMAIL_REGEX) != nil
      User.all.each do |user|
        if user.email == submitted_email
          redirect to '/users/login'
          #flash message saying this email has an account
        end
      end
      @user = User.find_or_create_by(params)
      session[:id] = @user.id
      redirect '/users/home'
    else
      #put a flash message
      redirect to '/users/signup'
    end
  end


  # User.all.each do |user|
  #   if user.email == submitted_email
  #     redirect to '/users/login'
  #     #flash message saying this email has an account
  #   end
  # end

  # ary = []
  # code bla bla bla
  # user_email == email already registerd
  # ary << email
  # bla bla bla end
  #
  # ary.empty?


  get '/users/login' do
    erb :'/users/login'
  end

  post '/users/login' do
    @user = User.find_by(params)
    session[:id] = @user.id
    redirect '/users/home'
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
