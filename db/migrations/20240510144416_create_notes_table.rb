# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :notes do
      primary_key :id
      String :content, null: false
    end
  end
end
