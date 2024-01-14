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

## Notes

- The free version of the Twitter API allows me 1 request every 15 minutes from the 'friends' and 'followers' endpoints. I don't know if I'm missing something, but as much as I have read and reread, it seems to be the case. This has complicated my tests, and there is one test that is currently there but not executed, and the others mock the response from Twitter.

- ConnectedDevelopers#generate_graph: I have incorporated Promises when generating the graph, but these use a common hash upon which the graph is built. Due to the GIL of MRI and the use of 'concurrent-ruby' (which reimplements Array, Hash, etc.), the use of a mutable object asynchronously is Thread-Safe. The algorithm is O(n^2/2), and the benefit is a division by 2, but it still remains n^2. That's why I was thinking of refactoring this part so that each promise manages local variables and although there would be a small loss of performance, the code would be simpler, more robust, and elegant. 

- QA and CI: The tests cover the highest percentage of code but only the success cases; I have not started to do a deep battery of tests. The most critical points are the generation of the graph and then the Bron-Kerbosch algorithm; that's where I would have dedicated my efforts to cover all possible cases. The project comes with continuous integration using Codeship, test execution, coverage, static code analysis with Code Climate (Reek, Rubocop, Flog, Bundle-Audit). Bundle-Audit also checks that there are no dependencies with security flaws.

- Docker: There is a Dockerfile and a docker-compose; I have this container to play around without having to install Ruby and this project's dependencies on the machine. It's a pretty quick way to work.

- Gem: The project is packaged in gem format and uploaded to Rubygems. It installs easily and you can execute the 'devcliques' command wherever you want.

- Logging: A log file called 'application.log' is generated where the script is executed.

- Metaprogramming: There is a bit in the AppLogger, it was useful.

- SOLID: I have tried to give a single responsibility to each class and used dependency injection.
