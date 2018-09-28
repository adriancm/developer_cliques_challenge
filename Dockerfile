FROM ruby:latest

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN gem install rspec

ENTRYPOINT ["tail", "-f", "/dev/null"]
