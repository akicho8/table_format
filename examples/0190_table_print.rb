$LOAD_PATH << "../lib"
require "table_format"

require "active_support/isolated_execution_state" # workaround of /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2/lib/active_support/logger_thread_safe_level.rb:11:in 'ActiveSupport::LoggerThreadSafeLevel#local_level': uninitialized constant ActiveSupport::LoggerThreadSafeLevel::IsolatedExecutionState (NameError)
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
