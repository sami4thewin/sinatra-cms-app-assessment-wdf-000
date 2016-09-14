# require 'rack-flash'

class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/' do
    erb :index
  end

  post '/sponatras' do
    @user = User.find_or_create_by(params)
    session[:id] = @user.id
    redirect '/sponatras/home'
  end

  get '/sponatras/login' do
    erb :login
  end

  get 'playlists/new' do
    erb :new_playlist
  end

  get '/sponatras/home' do
    @user = User.find(session[:id])
    erb :home
  end

end
