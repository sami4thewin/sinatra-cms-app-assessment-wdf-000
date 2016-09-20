class PlaylistController < ApplicationController

    get '/playlists/new' do
      erb :'/playlists/new_playlist'
    end

    post '/playlists' do
      if params[:playlist][:name] == nil || params[:playlist][:name] == ""
        flash[:message] = "Please input a playlist name"
        redirect to '/playlists/new'
      else
        @playlist = Playlist.create(name: params[:playlist][:name])
        params[:playlist][:songs].each do |song|
          if song != ""
            # binding.pry
            if RSpotify::Track.search(song).first != nil
              new_song = RSpotify::Track.search(song).first
              spotify = new_song.external_urls["spotify"]
              @song = Song.create(name: new_song.name, spotify: spotify)
              @playlist.songs << @song
              @user = User.find_by_id(session[:id])
              @user.playlists << @playlist
            else
              #flash message that not a valid song
              redirect to '/playlists/new'
            end
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

    get '/playlist/:id/:song_id/songdelete' do
      # @song = Song.find_by(id: params[:id])
      @playlist = Playlist.find_by(id: params[:id])
      # @playlist.songs.each do |song|
        # if song.name == @song.name
      @playlist.songs.delete(Song.find_by(id: params[:song_id]))
      # binding.pry
      redirect to "/playlist/#{@playlist.id}/edit"
      # end
    end

    get '/playlist/:id/songadd' do
      @playlist = Playlist.find_by(id: params[:id])
      erb :'/playlists/add'
      # binding.pry
    end

    post '/playlist/:id/add' do
      @playlist = Playlist.find_by(id: params[:id])
      params[:playlist][:songs].each do |song|
        if song != ""
          if RSpotify::Track.search(song).first != nil
            new_song = RSpotify::Track.search(song).first
            spotify = new_song.external_urls["spotify"]
            check = Song.create(name: new_song.name, spotify: spotify)
            # binding.pry
            if @playlist.songs.find_by(name: check.name) != nil
              check.destroy
            else
              @playlist.songs << check
            end
          # @playlist.songs.each do |check|
          #   if check.name == @song.name
          #     @song.destroy
          #     # redirect to "/playlists/#{@playlist.id}"
          #   else
          #     @playlist.songs << @song
          #   end
          end
        end
      end
      redirect to "/playlists/#{@playlist.id}"
    end

    get '/playlist/:id/delete' do
      # binding.pry
      @playlist = Playlist.find_by(id: params[:id])
      @playlist.destroy
      redirect to '/users/home'
    end

    get '/playlists/:song_id/:id/search' do
      @playlist = Playlist.find_by(id: params[:id])
      @song = Song.find_by(id: params[:song_id])
      Song.all.each do |song|
        @bruh = Song.all.where(name: @song.name).where.not(playlist_id: @playlist.id)
      end
      @array = []
      @bruh.each do |song|
        # new
        found = Playlist.find_by(id: song.playlist_id)
        if found != nil && !@array.include?(found)
          @array << found
        end
      end
      # binding.pry
      erb :'/playlists/search'
    end

    post '/found/:id' do
      @playlist = Playlist.find_by(id: params[:id])
      @songs = params[:song]
      @songs.each do |song|
        new_song = RSpotify::Track.search(song).first
        spotify = new_song.external_urls["spotify"]
        check = Song.create(name: new_song.name, spotify: spotify)
        # binding.pry
        if @playlist.songs.find_by(name: check.name) != nil
          check.destroy
        else
          @playlist.songs << check
        end
        # if RSpotify::Track.search(song).first != nil
        # new_song = RSpotify::Track.search(song).first
        # spotify = new_song.external_urls["spotify"]
        # # @song = Song.find_by(name: song)
        # @song = Song.create(name: new_song.name, spotify: spotify)
        # @playlist.songs << @song
      end
      #add a flash message congratulating on new songs
      redirect to "/playlists/#{@playlist.id}"
      # binding.pry
    end



end
