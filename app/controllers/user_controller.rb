require 'rack-flash'

class UserController < ApplicationController

  use Rack::Flash

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  get '/users/signup' do

    erb :'/users/signup'
  end

  post '/users/signup' do
    # binding.pry
    if params[:name] == "" || params[:email] == "" || params[:password] == ""
      #flash message enter something into the fields
      flash[:message] = "You are missing a field."
      erb :'/users/signup'
    end

      # User.all.each do |user|
      #   if user.name == params[:name]
      #     flash[:message] = "This name is already associated with an account."
      #     redirect to '/users/signup'
      #     #flash message saying this email has an account
      #   end
      # end
      # submitted_email = params[:email]
      # # binding.pry
      # if submitted_email.match(VALID_EMAIL_REGEX) != nil
      #   User.all.each do |user|
      #     if user.email == submitted_email
      #       flash[:message] = "This email is already associated with an account."
      #       redirect to '/users/login'
      #       #flash message saying this email has an account
      #     end
      #   end
      if !User.valid_email?(params[:email]) || User.find_by(name: params[:name])
        # flash[:message] = "You may have an account, if not try entering a valid email."
        redirect to '/users/login'
      end

      @user = User.create(params)
      session[:id] = @user.id
      flash[:message] = "Congrats on your new account."
      erb :'/users/home'


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
    if params[:email] == "" || params[:password] == ""
      #flash message enter something into the fields
      flash[:message] = "You forgot to fill out a field."
      erb :'/users/login'
    # elsif condition
    #   !User.valid_email?(params[:email])
    else
      @user = User.find_by(email: params[:email])
      # binding.pry
      if !@user.nil? && @user.authenticate(params[:password])
        session[:id] = @user.id
        redirect '/users/home'
      elsif @user.nil?
        #flash message to create an account
        flash[:message] = "There is no email associated with this account, please create an account."
        erb :'/users/signup'
      else
        flash[:message] = "You entered the wrong password."
        erb :'/users/login'
      end
    end
  end

  get '/users/home' do
    @user = current_user
    erb :'/users/home'
  end

  get '/users/logout' do
    session.clear
    flash[:message] = "Successfully logged out"
    erb :index
  end

  get '/users/:id/edit' do
    @user = current_user
    erb :'/users/edit'
  end

  post '/users/:id/edit' do
    @user = current_user
    @user.email = params[:email]
    @user.name = params[:name]
    @user.password = params[:password]
    @user.save
    flash[:message] = "Successfully updated your account details."
    erb :'/users/home'
    # binding.pry
  end

  get '/users/delete' do
    @user = current_user
    session.clear
    @user.destroy
    flash[:message] = "Account successfully deleted."
    erb :index
  end

end
