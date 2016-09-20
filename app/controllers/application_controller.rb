require 'rack-flash'

class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  set :public_folder , Proc.new { File.join(root, "../public/") }
  use Rack::Flash

  get '/' do
    erb :index
  end

end
