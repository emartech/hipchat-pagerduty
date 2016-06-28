require 'json'

class App::Healthcheck < Rack::App

  get '/healthcheck' do
    {success: true}.to_json
  end

end
