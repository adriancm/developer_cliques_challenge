# Developer Cliques Challenge
##### Note: Maintainability analyzed by bundler-audit, reek, rubocop and flog gems

[ ![Codeship Status for adriancm/developer_cliques_challenge](https://app.codeship.com/projects/b3bb64b0-aa0b-0136-3562-16991277c574/status?branch=master)](https://app.codeship.com/projects/308978)
[![Maintainability](https://api.codeclimate.com/v1/badges/efc311f644696a0c961b/maintainability)](https://codeclimate.com/github/adriancm/developer_cliques_challenge/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/efc311f644696a0c961b/test_coverage)](https://codeclimate.com/github/adriancm/developer_cliques_challenge/test_coverage)

## Install

```gem install developer_cliques```

### In gemfile

``` gem 'developer_cliques' ```

## Get Started

It needs configure [Twitter API](https://developer.twitter.com/) keys. Apply for a Developer or Enterprise Account and create an App in Twitter Developers platform.

Create a *.env* file with this data from Twitter.

```
TWITTER_CONSUMER_KEY=<YOUR_CONSUMER_KEY>
TWITTER_CONSUMER_SECRET=<YOUR_CONSUMER_SECRET>
TWITTER_ACCESS_TOKEN=<YOUR_ACCESS_TOKEN>
TWITTER_ACCESS_TOKEN_SECRET=<YOUR_ACCESS_TOKEN_SECRET>
```

An example input file *usernames*:  

``` 
user1
user2
...
usern 
```

Execute command *devcliques* with selected input file:

``` devcliques -f usernames ```

You also could choose an environment vars file from another directory or name:

``` devcliques -f username -e /path/to/my_env_vars_file```

## Build and Test inside Docker container
##### Note: Use this if you don't want to install Ruby and dependencies in your machine

Build container and run:

```docker-compose up -d```

Execute *rspec*:

```docker exec -t developer_cliques_base_ruby_1 rspec```

## Install dependencies
```bundle install```

## Run tests
```rspec```
