require 'simplecov'
require 'dotenv'

Dotenv.load("../.env")
SimpleCov.start

def fixture filename
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end