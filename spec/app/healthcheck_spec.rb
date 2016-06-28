require 'spec_helper'

describe App::Healthcheck do

  include Rack::App::Test

  rack_app described_class

  describe '/healthcheck' do

    subject { get url: '/healthcheck' }

    it 'should respond with HTTP 200' do
      expect(subject.status).to eq 200
    end


    it 'should indicate success' do
      expect(subject.body).to eq '{"success":true}'
    end

  end

end
