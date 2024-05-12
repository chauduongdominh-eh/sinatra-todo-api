# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    content { Faker::Lorem.paragraph }
  end
end
