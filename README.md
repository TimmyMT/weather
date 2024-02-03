# WEATHER_API

## Docker
```
docker-compose build
docker-compose up
```

## Set environment variables
Add API_KEY value from [Accu Weather](https://developer.accuweather.com/) into .env file
```
cp .env.example .env
```

## Run tests
```
bundle exec rspec spec
```

## Actualize swagger schema
```
RAILS_ENV=test rails rswag
```

## Stack
* Rails 6
* [Grape](https://github.com/ruby-grape/grape)
* [Rufus](https://github.com/jmettraux/rufus-scheduler) (Schedule tasks)
* [RSpec](https://github.com/rspec/rspec-rails)
* [VCR](https://github.com/vcr/vcr) (Mocking Web Requests)
* [Rswag](https://github.com/rswag/rswag) (API documentation)
