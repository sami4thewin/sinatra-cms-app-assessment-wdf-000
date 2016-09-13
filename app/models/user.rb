class User < ActiveRecord::Base
  has_secure_password
  has_many :playlists
  has_many :songs, :through => :playlists
end
