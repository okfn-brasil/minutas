# Decidim

Free Open-Source participatory democracy, citizen participation and open
government for cities and organizations

This is Codeandomexico's own vanilla Decidim deployment.

## Local development

### Requisites

* ruby `3.0.2`
* node `16`
* yarn

### Installation

Follow these steps:

* `git clone https://git.codeandomexico.org/codeandomexico/decidim.git`
* `cd decidim`
* either create a postgres database user and database owned by this user or just
  a user able to create databases and use `bin/rails db:create` to create the
  databases.
* set the `DATABASE_USERNAME`, `DATABASE_PASSWORD` and `DATABASE_NAME`
  environment variables.
* run `bin/rails db:migrate` to run the migrations.
* (optional) run `bin/rails db:seed` to seed the database.
* start the server with `bin/rails server`

and refer to [the docs](https://docs.decidim.org/en/v0.27/install/manual) for
more information.

## Management

You can create a system admin account with:

    bin/rails decidim_system:create_admin
