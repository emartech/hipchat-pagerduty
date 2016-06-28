require 'spec_helper'

require 'climate_control'
require 'json'

describe App::Trigger do

  include Rack::App::Test

  rack_app described_class

  describe '/trigger' do

    let(:environment) do
      {PAGERDUTY_SERVICES: {my_test_service: 'some_service_key_123',
                            another_test_service: 'another_service_key_456'}.to_json}
    end

    around(:example) do |example|
      ClimateControl.modify environment do
        example.run
      end
    end

    it 'should trigger an incident on the requested service' do
      client = instance_double(Pagerduty)
      allow(Pagerduty).to receive(:new).with('some_service_key_123').and_return client
      expect(client).to receive(:trigger).with('some interesting incident description')

      post '/trigger/my_test_service', payload: {item: {message: {message: '/my_test_service some interesting incident description'}}}.to_json
    end

  end

end
