# frozen_string_literal: true

require_relative './config/database'
require 'sinatra'
require 'sinatra/json'

# Main application
class App < Sinatra::Base
  before do
    content_type 'application/json'
  end

  get '/' do
    json({ message: 'Hello' })
  end
end
