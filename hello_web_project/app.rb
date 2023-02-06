require 'sinatra/base'
# require 'sinatra/reloader'

class Application < Sinatra::Base
  get '/hello' do
    name = params[:name]

    return "Hello #{name}"
  end

  post "/submit" do
    # name = params[:name]
    # message = params[:message]
    name, message = params.values_at(:name, :message)

    return "Thanks #{name}, you sent this message: #{message}"
  end

  get "/names" do
    return "Julia, Mary, Karim"
  end

  post "/sort-names" do
    names = params[:names]
    sorted_names = names.split(",").sort

    return sorted_names.join(",")
  end
  
  # # This allows the app code to refresh
  # # without having to restart the server.
  # configure :development do
  #   register Sinatra::Reloader
  # end
end