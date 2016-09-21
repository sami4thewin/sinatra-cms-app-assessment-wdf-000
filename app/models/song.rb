class Song < ActiveRecord::Base
  has_many :song_playlists
  has_many :playlists, :through => :song_playlists
  has_many :users, :through => :playlists

  def recommendations
    # @matched_songs = Song.all.where(name: self.name).where.not(id: self.id)
    @matched_playlists = self.playlists
    # @matched_songs.each do |song|
      # binding.pry
    @matched_songs = []

    # self.playlists.each do |playlist|
    #   @matched_playlists << playlist
    # end
    # @matched_playlists = @matched_playlists.select {|playlist| playlist.songs.length > 1}
    # @matched_playlists.each do |playlist|
    #   if playlist.songs.length == 1
    #     @matched_playlists.delete(playlist)
    #   end
    # end
    @matched_playlists.each do |playlist|
      playlist.songs.each do |song|
        @matched_songs << song
      end
    end
    @matched_songs = @matched_songs.uniq
    # binding.pry
    # binding.pry
    # current_user.generate_recommndations(@song)
    # @playlist = Playlist.find_by(id: params[:id])
    # @song = Song.find_by(id: params[:song_id])
    # # Song.all.each do |song|
    #   # @bruh = Song.all.where(name: @song.name).where.not(playlist_id: @song.playlist.id)
    # # end
    # @array = []
    # @bruh.each do |song|
    #   # new
    #   found = Playlist.find_by(id: song.playlist_id)
    #   if found != nil && !@array.include?(found)
    #     @array << found
    #   end
    # end
    # # binding.pry
    #
    # # playlist_w_song = Playlist.all.select { |pl| pl.songs.include?(@song) }
    # # playlist_w_song.map { |pl| pl.songs }.flatten.uniq
    # # playlist_w_song.map { |pl| pl.remove_song(@song) }
    # erb :'/playlists/search'
  end

end
