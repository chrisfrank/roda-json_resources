require 'bundler/setup'
Bundler.setup
require 'pry'
require 'rack/test'
require 'rack/reducer'
require 'ostruct'

RSpec.configure do |config|
  config.color = true
  config.order = :random
  config.include Rack::Test::Methods
end

class TestModel < OpenStruct
  def self.first(id:)
    new(id: id)
  end

  def save
    self
  end
end
