class PlaylistController < ApplicationController

    get '/playlists/new' do
      erb :new_playlist
    end

    post '/playlists' do
      # ayo = params[:playlist][:songs][0]
      bruh = RSpotify::Artist.search(params[:playlist][:songs][0])
      binding.pry
    end
end
