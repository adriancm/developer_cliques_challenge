# Gemfile
source "https://rubygems.org"

group :development, :test do
  gem "rspec"
  gem 'simplecov', '>= 0.16.1', require: false
end

group :development, :test, :production do
  gem "twitter"
  gem "dotenv"
  gem "octokit", "~> 4.0"
  gem "concurrent-ruby", require: 'concurrent'
end
