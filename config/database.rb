# frozen_string_literal: true

require 'sequel'
DB = Sequel.connect(ENV['DB_URL'])
require_relative '../models/all'
DB.freeze
