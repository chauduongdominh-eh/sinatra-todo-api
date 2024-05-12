# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative './spec_helper'
require 'rack/test'
require_relative '../app'

# I'm too lazy to extract the controller out of App
RSpec.describe App do
  include Rack::Test::Methods

  def app
    App
  end

  describe 'GET /notes' do
    let!(:note) { create :note }

    it 'returns all notes' do
      get '/notes'
      expect(last_response.status).to be(200)
      expect(JSON.parse(last_response.body))
        .to include(a_hash_including({ 'content' => note.content }))
    end
  end

  describe 'GET /notes/:id' do
    let!(:note) { create :note }

    it 'returns all notes' do
      get '/notes'
      expect(last_response.status).to be(200)
      expect(JSON.parse(last_response.body))
        .to include(a_hash_including({ 'content' => note.content }))
    end
  end

  describe 'POST /notes' do
    let(:request) do
      post '/notes',
           { content: content }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    context 'when content is present' do
      let(:content) { Faker::Lorem.paragraph }

      it 'returns success' do
        request
        expect(last_response.status).to be(201)
      end

      it 'creates new note', :aggregate_failures do
        expect { request }.to change { Note.count }.by(1)
        expect(Note.last.content).to eq(content)
      end
    end

    context 'when content is blank' do
      let(:content) { '' }

      it 'returns error' do
        request
        expect(last_response.status).to eq(422)
      end

      it 'does not save the note' do
        expect { request }.to_not(change { Note.count })
      end
    end
  end

  describe 'PUT /notes/:id' do
    let(:note) { create :note }
    let(:request) do
      put "/notes/#{note.id}",
          { content: content }.to_json,
          'CONTENT_TYPE' => 'application/json'
    end

    context 'when content is present' do
      let(:content) { Faker::Lorem.paragraph }

      before do
        request
      end

      it 'returns success' do
        expect(last_response.status).to be(200)
      end

      it 'updates new note' do
        expect(note.refresh.content).to eq(content)
      end
    end

    context 'when content is blank' do
      let(:content) { '' }

      it 'returns error' do
        request
        expect(last_response.status).to eq(422)
      end

      it 'does not save the note' do
        expect { request }.to_not(change { note.refresh.content })
      end
    end
  end

  describe 'DELETE /notes/:id' do
    context 'when note exists' do
      let!(:note) { create :note }
      let(:request) { delete "/notes/#{note.id}" }

      it 'reports success' do
        request
        expect(last_response.status).to be(200)
      end

      it 'deletes the note' do
        expect { request }.to change { Note.count }.by(-1)
      end
    end

    context 'when note does not exist' do
      it 'reports success as usual' do
        delete '/notes/0'
        expect(last_response.status).to be(200)
      end
    end
  end
end
