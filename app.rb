require 'bundler/setup'
require 'rack/app'

$LOAD_PATH.unshift File.expand_path('app')

class App < Rack::App
  autoload :Healthcheck, 'healthcheck'

  mount App::Healthcheck
end
