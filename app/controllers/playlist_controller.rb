class PlaylistController < ApplicationController

    get '/playlists/new' do
      erb :'/playlists/new_playlist'
    end

    post '/playlists' do
      if params[:playlist][:name] == nil || params[:playlist][:name] == ""
        #put a flash message here
        redirect to '/playlists/new'
      else
        @playlist = Playlist.create(name: params[:playlist][:name])
        params[:playlist][:songs].each do |song|
          if song != ""
            new_song = RSpotify::Track.search(song).first
            spotify = new_song.external_urls["spotify"]
            @song = Song.create(name: new_song.name, spotify: spotify)
            @playlist.songs << @song
            @user = User.find_by_id(session[:id])
            @user.playlists << @playlist
          end
        end
      end
      erb :'/users/home'
    end

    get '/playlists/:id' do
      @playlist = Playlist.find_by(id: params[:id])
      erb :'/playlists/show'
      # binding.pry
    end

    get '/playlist/:id/edit' do
      @playlist = Playlist.find_by(id: params[:id])
      erb :'/playlists/edit'
    end


end
