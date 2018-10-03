
require 'logger'

class AppLogger

  LEVELS = ["info", "warn", "debug", "error", "fatal"]

  class << self

    def logger
      Logger.new('application.log', 'monthly')
    end

  end

  LEVELS.each do |level|
    define_singleton_method level.to_sym do |message|
      logger.send level.to_sym, message
    end
  end

end