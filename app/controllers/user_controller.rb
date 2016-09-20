class UserController < ApplicationController

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  get '/users/signup' do
    erb :'/users/signup'
  end

  post '/users/signup' do
    if params[:name] == "" || params[:email] == "" || params[:password_digest] == ""
      flash[:message] = "Please input all fields"
      redirect to '/users/signup'
    else
      submitted_email = params[:email]
      if submitted_email.match(VALID_EMAIL_REGEX) != nil
        User.all.each do |user|
          if user.email == submitted_email
            redirect to '/users/login'
            flash[:message] = "It looks like you already have an account. Please login."
          end
        end
        @user = User.create(params)
        session[:id] = @user.id
        redirect '/users/home'
      else
        flash[:message] = "Please enter a valid email"
        redirect to '/users/signup'
      end
    end
  end

  get '/users/login' do
    erb :'/users/login'
  end

  post '/users/login' do
    if params[:email] == "" || params[:password_digest] == ""
      flash[:message] = "Please input all fields"
      redirect to '/users/login'
    else
      @user = User.find_by(params)
      if !@user.nil?
        session[:id] = @user.id
        redirect '/users/home'
      else
        flash[:message] = "It looks like you don't have an account. It's easy to make one!"
        redirect to '/users/signup'
      end
    end
  end

  get '/users/home' do
    @user = User.find(session[:id])
    erb :'/users/home'
  end

  get '/users/logout' do
    session.clear
    flash[:message] = "Bye!"
    redirect to '/'
  end

end
