# file: spec/integration/application_spec.rb

require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  context "GET /" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/names')

      expect(response.status).to eq(200)

      expected_response = "Julia, Mary, Karim"

      expect(response.body).to eq expected_response

      # expect(response.body).to eq(expected_response)
    end
  end
  context "POST /sort-names" do
    it 'returns 200 OK & names sorted' do
      response = post('/sort-names?names=Joe,Alice,Zoe,Julia,Kieran')

      expect(response.status).to eq(200)
      expected_response = "Alice,Joe,Julia,Kieran,Zoe"
      expect(response.body).to eq(expected_response)
    end

    # it 'returns 400 Bad Request' do
    #   response = post('/sort-names?names=')

    #   expect{response.status}.to eq(400)
    # end
  end
end