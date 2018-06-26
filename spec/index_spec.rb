require 'spec_helper'
require 'roda'

describe 'Listing records' do
  let(:app) do
    class App < Roda
      plugin :json_resources

      class Dataset
        extend Enumerable
        def self.each
        end
      end

      class TestDecorator < JSONDecorator
        property :id
      end

      route do |r|
        r.index Dataset, decorator: TestDecorator, filters: []
      end
    end
  end

  it 'returns records as JSON' do
    get('/') do |res|
      expect(JSON.parse(res.body)).to eq([])
    end
  end
end
