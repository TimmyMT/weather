# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.7', '>= 6.1.7.6'

gem 'active_model_serializers'
gem 'dotenv-rails'
gem 'grape'
gem 'grape-active_model_serializers'
gem 'grape_on_rails_routes'
gem 'net-http'
gem 'rest-client'
gem 'rswag'
gem 'rubocop'
gem 'uri', '0.10.0'
gem 'whenever', require: false

gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'timecop'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
