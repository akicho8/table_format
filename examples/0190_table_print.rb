$LOAD_PATH << '../lib'
require 'table_format'

require "active_support/logger"

AppLogger = ActiveSupport::Logger.new(STDOUT)

module TableFormat
  def self.table_print(str)
    AppLogger.debug(str.rstrip)
  end
end

tp "foo"
# >> |-----|
# >> | foo |
# >> |-----|
