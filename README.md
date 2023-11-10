# Decidim

Free Open-Source participatory democracy, citizen participation and open
government for cities and organizations

This is Codeandomexico's own vanilla Decidim deployment.

## Local development

### Requisites

* ruby `3.0.2`
* bundler `2.3.20`
* node `16`
* yarn

### Installation

Follow these steps:

* `git clone https://github.com/okfn-brasil/minutas.git`
* `cd minutas`
* either create a postgres user and a database owned by this user or just a user
  able to create databases and use `bin/rails db:create` to create it.
* set the `DATABASE_USERNAME`, `DATABASE_PASSWORD` and `DATABASE_NAME`
  environment variables.
* run `bin/rails db:migrate` to run the migrations.
* (optional) run `bin/rails db:seed` to seed the database. This will create an
  organization and some users. Use `admin@example.org` and password
  `decidim123456789` to log in.
* Install frontend dependencies with `yarn install`
* start the server with `bin/rails server`

and refer to [the docs](https://docs.decidim.org/en/v0.27/install/manual) for
more information.

## Management

You can create a system admin account with:

    bin/rails decidim_system:create_admin

When an organization is created and an admin invited in development look for the
email in the console and maybe use something like
https://www.webatic.com/quoted-printable-convertor to decode it and follow de
invite link.

## Deployment

An image is created and deployed every time you push a tag. Use the following format: `git tag X.Y.Z` and `git push --tags`. Example: `git tag 1.6.0`

### Background tasks

Run a job queue:

    bin/rake jobs:work

## Adding gems

* modify `Gemfile` with the new dependencies
* run `bundle install`
* run the gem's specific install steps
