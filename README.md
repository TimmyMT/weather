# README

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
