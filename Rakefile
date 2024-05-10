# frozen_string_literal: true

MIGRATIONS_DIR = 'db/migrations'

def sequel_run(&block)
  require 'sequel/core'
  Sequel.extension :migration
  Sequel.connect(ENV['DB_URL'], &block)
end

def next_to_last_version
  versions = Dir["#{MIGRATIONS_DIR}/*"]
  if versions.size < 2
    0
  else
    versions[-2]
  end
end

namespace :db do
  desc 'Run all pending migrations'
  task :migrate do
    sequel_run do |db|
      Sequel::Migrator.run(db, MIGRATIONS_DIR)
    end
  end

  desc 'Rollback the last recent migration'
  task :rollback do
    sequel_run do |db|
      Sequel::Migrator.run(db, MIGRATIONS_DIR, target: next_to_last_version)
    end
  end
end
