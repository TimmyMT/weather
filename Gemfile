source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'rails', '~> 6.1.7', '>= 6.1.7.6'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'

gem 'grape'
gem 'grape_on_rails_routes'
gem "net-http"
gem 'rest-client'
gem 'uri', '0.10.0'
gem 'whenever', require: false
gem 'dotenv-rails'
gem 'rswag'
gem 'active_model_serializers'
gem 'grape-active_model_serializers'

gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'pry'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem "webmock"
  gem 'timecop'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
