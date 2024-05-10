# frozen_string_literal: true

Base = Class.new(Sequel::Model)
Base.instance_eval do
  plugin :validation_helpers
end
