# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :username, null: false
      index :username, unique: true
    end

    alter_table :notes do
      add_foreign_key :user_id, :users
      add_index :user_id
    end
  end
end
