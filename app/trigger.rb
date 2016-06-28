require 'json'
require 'pagerduty'

class App::Trigger < Rack::App

  post '/trigger/:service_name' do
    service_name = params['service_name']
    service_key = service_key_of service_name

    message = fetch_message_from payload
    description = get_incident_description(service_name, message)

    Pagerduty.new(service_key).trigger(description)
  end


  private

  def service_key_of(service_name)
    services = JSON.parse ENV['PAGERDUTY_SERVICES']
    services[service_name]
  end


  def fetch_message_from(payload)
    hipchat_message = JSON.parse payload
    p hipchat_message['item']['message']['message']
    hipchat_message['item']['message']['message']
  end


  def get_incident_description(service_name, message)
    matches = message.match /^\/#{service_name}\s+(?<incident_description>.*)/
    matches[:incident_description]
  end

end
