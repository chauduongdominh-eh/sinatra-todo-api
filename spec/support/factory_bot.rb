# frozen_string_literal: true

require 'factory_bot'

FactoryBot.definition_file_paths = %w[./spec/factories]
FactoryBot.find_definitions
FactoryBot.define do
  to_create(&:save)
end
