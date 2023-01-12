# WEATHER_API

## Set environment variables
Add API_KEY value from [Accu Weather](https://developer.accuweather.com/) into .env file
```
cp .env.example .env
```

## Run tests
```
bundle exec rspec spec/app
```

## Set scheduled tasks
```
whenever --update-crontab
whenever --update-crontab --set environment=production
whenever --update-crontab --set environment=development
```

## Actualize swagger schema
```
RAILS_ENV=test rails rswag
```

## Stack
* Rails 6
* [Grape](https://github.com/ruby-grape/grape)
* [Whenever](https://github.com/javan/whenever) (Schedule tasks)
* [RSpec](https://github.com/rspec/rspec-rails)
* [Webmock](https://github.com/bblimke/webmock) (Mocking Web Requests)
* [Rswag](https://github.com/rswag/rswag) (API documentation)
