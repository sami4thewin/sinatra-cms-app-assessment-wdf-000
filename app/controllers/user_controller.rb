require 'rack-flash'

class UserController < ApplicationController

  use Rack::Flash

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  get '/users/signup' do

    erb :'/users/signup'
  end

  post '/users/signup' do
    # binding.pry
    if params[:name] == "" || params[:email] == "" || params[:password_digest] == ""
      #flash message enter something into the fields
      flash[:message] = "You are missing a field."
      erb :'/users/signup'
    else
      User.all.each do |user|
        if user.name == params[:name]
          flash[:message] = "This name is already associated with an account."
          redirect to '/users/signup'
          #flash message saying this email has an account
        end
      end
      submitted_email = params[:email]
      # binding.pry
      if submitted_email.match(VALID_EMAIL_REGEX) != nil
        User.all.each do |user|
          if user.email == submitted_email
            flash[:message] = "This email is already associated with an account."
            redirect to '/users/login'
            #flash message saying this email has an account
          end
        end
        @user = User.create(params)
        session[:id] = @user.id
        flash[:message] = "Congrats on your new account."
        erb :'/users/home'
      else
        flash[:message] = "Please enter a valid email."
        #put a flash message saying enter a valid email
        erb :'/users/signup'
      end
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
    if params[:email] == "" || params[:password_digest] == ""
      #flash message enter something into the fields
      flash[:message] = "You forgot to fill out a field."
      erb :'/users/login'
    else
      @user = User.find_by(params)
      if !@user.nil?
        session[:id] = @user.id
        redirect '/users/home'
      else
        #flash message to create an account
        flash[:message] = "There is no email associated with this account, please create an account."
        erb :'/users/signup'
      end
    end
  end

  get '/users/home' do
    @user = User.find(session[:id])
    erb :'/users/home'
  end

  get '/users/logout' do
    session.clear
    flash[:message] = "Successfully logged out"
    erb :index
  end

  get '/users/:id/edit' do
    @user = User.find(session[:id])
    erb :'/users/edit'
  end

  post '/users/:id/edit' do
    @user = User.find(session[:id])
    @user.email = params[:email]
    @user.name = params[:name]
    @user.password_digest = params[:password_digest]
    @user.save
    flash[:message] = "Successfully updated your account details."
    erb :'/users/home'
    # binding.pry
  end

  get '/users/delete' do
    @user = User.find(session[:id])
    session.clear
    @user.destroy
    flash[:message] = "Account successfully deleted."
    erb :index
  end

end
