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

  context "GET /albums" do
    it 'returns 200 OK and all album names' do
      response = get('/albums')

      expected_response ='Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /Albums" do
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
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end
  
  context "POST /artists" do
    it 'creates new artist (Wild nothing/Indie)' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie')
  
      expect(response.status).to eq(200)
      expect(response.body).to eq('')
  
      response = get('/artists')
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing')
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
end
