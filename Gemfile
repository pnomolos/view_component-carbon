# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake", "~> 13.0"

group :development, :test do
  gem "minitest", "~> 5.0"
  gem "capybara", "~> 3.0"
  gem "lookbook", ">= 2.0"
end

group :development do
  gem "rubocop", "~> 1.50", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-rails", require: false
end

# Dummy app dependencies
gem "rails", ">= 7.2.0"
gem "propshaft"
gem "dartsass-rails"
gem "importmap-rails"
gem "stimulus-rails"
gem "sprockets-rails", require: false
gem "puma"
gem "sqlite3"
