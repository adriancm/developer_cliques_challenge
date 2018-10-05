require 'simplecov'
SimpleCov.start

def fixture filename
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end