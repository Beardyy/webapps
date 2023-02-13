require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  def reset_album_table
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  def reset_artist_table
    seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_album_table
    reset_artist_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # context "GET /albums" do
  #   it 'returns 200 OK and all album names' do
  #     response = get('/albums')

  #     expected_response ='Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq(expected_response)
  #   end
  # end

  context "POST /Albums" do
    it "checks for valid params" do
      response = post(
        '/albums',
        not_a_title: 'Voyage',
        top_year: '2022',
        losing: '2')
      expect(response.status).to eq (400)
    end
    it 'creates new album (voyage/2022/2)' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: '2022',
        artist_id: '2')
  
      expect(response.status).to eq(200)
      expect(response.body).to eq('')
  
      response1 = get('/albums')
  
      expect(response1.body).to include('Voyage')
    end
  end
  
  context "GET /artists" do
    it 'returns 200 OK & All artists' do
      # Assuming the post with id 1 exists.
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('Artist: <a href="/artists/1">Pixies</a>')
    end
  end
  
  context "POST /artists" do
    it "checks for valid params" do
      response = post(
        '/artists',
        not_a_title: 'Voyage',
        top_year: '2022')
      expect(response.status).to eq (400)
    end
    it 'creates new artist (Wild nothing/Indie)' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie')
  
      expect(response.status).to eq(200)
      expect(response.body).to eq('')
  
      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end
  end
  
  context "GET /albums/:id" do
    it 'gets album id and details' do
      response = get('/albums/1')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "GET /albums" do
    it 'gets all album details' do
      response = get('/albums')
      expect(response.status).to eq 200
      expect(response.body).to include('Title: <a href="/albums/1">Doolittle</a>')
    end
  end

  context "GET /artists/:id" do
    it 'gets single artist details' do
      response = get('/artists/1')
      expect(response.status).to eq 200
      expect(response.body).to include('Artist: Pixies')
      expect(response.body).to include('Genre: Rock')
    end
  end

  context "GET /albums/new" do
    it 'returns the form page' do
      response = get('/albums/new')
  
      expect(response.status).to eq(200)
      # expect(response.body).to include('<h1>Add an Album</h1>')
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('<form method="POST" action="/albums"')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context "GET /artists/new" do
    it 'returns the form page' do
      response = get('/artists/new')
  
      expect(response.status).to eq(200)
      # expect(response.body).to include('<h1>Add an Album</h1>')
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('<form method="POST" action="/artists"')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end
  
end