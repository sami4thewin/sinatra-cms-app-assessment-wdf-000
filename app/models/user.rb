class User < ActiveRecord::Base
  has_secure_password
  has_many :playlists, dependent: :destroy
  has_many :songs, :through => :playlists
end
