# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.27.5"
# Decidim-specific gems
gem "decidim", DECIDIM_VERSION
# gem "decidim-conferences", "0.27.2"
# gem "decidim-consultations", "0.27.2"
# gem "decidim-elections", "0.27.2"
# gem "decidim-initiatives", "0.27.2"
# gem "decidim-templates", "0.27.2"

gem "bootsnap", "~> 1.3"
gem "puma", ">= 5.0.0" # the web server
gem "faker", "~> 2.14"
gem "wicked_pdf", "~> 2.1"
gem "delayed_job", "~> 4.1.11"
gem "delayed_job_active_record", "~> 4.1" # runs background tasks like sending emails
gem 'daemons', '~> 1.4' # required to run the delayed_job script

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end

group :production do
end
