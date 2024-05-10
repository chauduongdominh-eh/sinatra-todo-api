## Dev env setup

Enable direnv:

```sh
direnv allow
```

Install dependencies:

```sh
bundle install
```

Build Yard docs for Solargraph:

```sh
yard gems
```

Start the server:

```sh
rackup
```

By default, the server runs on port `9292`

## Database migration

Migrate:

```sh
sequel -m db/migrations "$DB_URL"
```

Rollback everything:

```sh
sequel -m db/migrations -M 0 "$DB_URL"
```

Replace `0` with the timestamp of a migration, all migrations created after the
specified migration will be rolled back.
