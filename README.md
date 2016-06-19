# Echo Server

This project is designed to be a pattern back-end for other api-integrations as a potential alternative persistence for tesing and development

Rails 4.2.6, Ruby 2.2.5, Postgres 9.4+

## Dependencies
- Postgresql 9.4

## Setup
### Ruby dependencies
```
$ bundle install
```

### Configure Database
```
cp config/database.yml.example config/database.yml
rake db:setup
```

## Running the server (in development)
```
bundle install rails server
```

## Running the Tests
```
bundle exec rspec spec
```

*This project is also configured to use guard*

## Deploy to Heroku
N/A -- there is currently no reference deployment to heroku (TODO)

## Development Process
See [PROCESS.md](PROCESS.md)

## Contributing
Please fork and pull request from a feature branch, see PROCESS.md for development standards
