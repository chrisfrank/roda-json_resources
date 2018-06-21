require 'spec_helper'
require 'roda'

describe 'CRUD actions' do
  let(:app) do
    class App < Roda
      plugin :json_resources

      class TestDecorator < JSONDecorator
        property :id
        property :name
      end

      route do |r|
        r.crud TestModel, decorator: TestDecorator
      end
    end
  end

  describe 'POST => /' do
    it 'creates a record' do
      post '/', name: 'james t. kirk' do |res|
        expect(res.status).to eq(201)
        expect(res.body).to include('kirk')
      end
    end
  end

  describe 'GET => /:id' do
    it 'reads a record' do
      get('/1') { |res| expect(res.body).to eq({ id: 1 }.to_json) }
    end
  end

  describe 'PATCH => /:id' do
    it 'updates a record' do
      patch '/1', name: 'spock' do |res|
        expect(res.body).to include('spock')
      end
    end
  end

  describe 'DELETE => /:id' do
    it 'destroys a record' do
      delete '/1' do |res|
        expect(res.status).to eq(204)
      end
    end
  end
end
