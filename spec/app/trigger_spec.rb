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
      incident = instance_double(PagerdutyIncident).as_null_object

      allow(Pagerduty).to receive(:new).with('some_service_key_123').and_return client
      expect(client).to receive(:trigger).with('some interesting incident description').and_return incident

      post '/trigger/my_test_service', payload: {item: {message: {message: '/my_test_service some interesting incident description'}}}.to_json
    end


    it 'should respond with the triggered incident key' do
      client = instance_double(Pagerduty)
      incident = instance_double(PagerdutyIncident)

      allow(Pagerduty).to receive(:new).and_return client
      allow(client).to receive(:trigger).and_return incident

      allow(incident).to receive(:incident_key).and_return 'triggered_incident_key_789'

      response = post '/trigger/my_test_service', payload: {item: {message: {message: '/my_test_service some interesting incident description'}}}.to_json

      expect(response.status).to eq 200
      expect(JSON.parse response.body).to eq({'color' => 'green',
                                              'message' => 'incident key: triggered_incident_key_789',
                                              'notify' => false,
                                              'message_format' => 'text'})
    end

  end

end
