# frozen_string_literal: true

require_relative './config/database'
require 'sinatra'
require 'sinatra/json'

class UnauthorizedError < StandardError
end

class AccessDeniedError < StandardError
end

class NotFoundError < StandardError
end

# Keep authorization simple for now
def authorize(user, record)
  case record
  when Note
    user.id == record.user_id
  else
    false
  end
end

# Main application
class App < Sinatra::Base
  set :show_exceptions, :after_handler

  before do
    content_type 'application/json'
    require_login!
  end

  def require_login!
    username = request.env['HTTP_AUTHORIZATION']
    @current_user = User.find(username: username)
    raise UnauthorizedError unless @current_user
  end

  def error_response(status)
    [status, json(message: env['sinatra.error'].to_s)]
  end

  error Sequel::ValidationFailed do
    error_response(422)
  end

  error UnauthorizedError do
    error_response(401)
  end

  error AccessDeniedError do
    error_response(403)
  end

  error NotFoundError do
    error_response(404)
  end

  post '/users' do
    payload = JSON.parse(request.body.read)
    user = User.create(payload)
    [201, json(user.values)]
  end

  get '/notes' do
    json(Note.where(user_id: @current_user.id).order(:id).all.map(&:values))
  end

  get '/notes/:id' do |id|
    note = Note[id]
    # Raising AccessDeniedError will reveal the existence of this note
    raise NotFoundError unless authorize(@current_user, note)

    json(note.values)
  end

  post '/notes' do
    payload = JSON.parse(request.body.read)
    payload['user_id'] = @current_user.id
    note = Note.create(payload)
    [201, json(note.values)]
  end

  put '/notes/:id' do |id|
    note = Note[id]
    raise NotFoundError unless authorize(@current_user, note)

    payload = JSON.parse(request.body.read)
    note.update(payload)
    [200, json(note.values)]
  end

  delete '/notes/:id' do |id|
    Note[id]&.destroy
    [200, json(success: true)]
  end
end
