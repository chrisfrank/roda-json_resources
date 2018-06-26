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
        options = { decorator: TestDecorator, actions: [:read, :update] }
        r.crud TestModel, options do |model|
          r.get 'custom' do
            model.class.to_s
          end
        end
      end
    end
  end

  describe 'POST => /' do
    it '404s' do
      post('/') { |res| expect(res.status).to eq(404) }
    end
  end

  describe 'GET => /:id/custom' do
    it 'handles a custom action' do
      get('/1/custom') { |res| expect(res.body).to eq('TestModel') }
    end
  end

  describe 'GET => /:id' do
    it 'reads a record' do
      get('/1') { |res| expect(res.body).to eq({ id: '1' }.to_json) }
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
    it '404s' do
      delete('/1') { |res| expect(res.status).to eq(404) }
    end
  end

end
