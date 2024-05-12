# frozen_string_literal: true

require 'sequel'
DB = Sequel.connect(ENV['DB_URL'])
Sequel::Model.plugin :subclasses
require_relative '../models/all'
Sequel::Model.freeze_descendents
DB.freeze
