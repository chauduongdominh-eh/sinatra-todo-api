# frozen_string_literal: true

require_relative './config/database'
require 'sinatra'
require 'sinatra/json'

# Main application
class App < Sinatra::Base
  set :show_exceptions, :after_handler

  before do
    content_type 'application/json'
  end

  error Sequel::ValidationFailed do
    message = env['sinatra.error'].to_s
    [422, json(message: message)]
  end

  get '/notes' do
    json(Note.order(:id).all.map(&:values))
  end

  get '/notes/:id' do |id|
    json(Note[id].values)
  end

  post '/notes' do
    payload = JSON.parse(request.body.read)
    note = Note.create(payload)
    [201, json(note.values)]
  end

  delete '/notes/:id' do |id|
    Note[id].destroy
    [200, json(success: true)]
  end
end
