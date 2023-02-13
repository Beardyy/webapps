# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  post '/albums' do
    status 400 and return " " if invalid_album_request_params?
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return ''
  end 

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    #response = artists.map{ |artist| artist.name }.join(", ")
    return erb(:artists)
  end

  post '/artists' do
    status 400 and return " " if invalid_artist_request_params?
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return ''
  end 

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  def invalid_album_request_params?
    return (params[:title].nil? || params[:release_year].nil? || params[:artist_id].nil?)
  end

  def invalid_artist_request_params?
    return (params[:name].nil? || params[:genre].nil?)
  end
end