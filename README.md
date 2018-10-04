# Developer Cliques Challenge
[ ![Codeship Status for adriancm/developer_cliques_challenge](https://app.codeship.com/projects/b3bb64b0-aa0b-0136-3562-16991277c574/status?branch=master)](https://app.codeship.com/projects/308978)

## Build and Run inside Docker container
### Note: Use this if you don't want to install Ruby and dependencies in your machine
```docker-compose up -d```

```docker exec -ti developer_cliques_base_ruby_1 /bin/bash```

## Install dependencies
```bundle install```

## Run tests
```bundle exec rspec```
