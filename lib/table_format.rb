require "table_format/version"
require "table_format/generator"
require "table_format/core_ext"

if defined?(Rails)
  require "table_format/railtie"
else
  if defined?(ActiveSupport)
    if ActiveSupport.respond_to?(:on_load)
      ActiveSupport.on_load(:active_record) do
        include TableFormat::ActiveRecord
        ::ActiveRecord::Result.include(TableFormat::ActiveRecordResult)

        ::ActiveRecord::Relation.class_eval do
          def to_t(options = {})
            TableFormat.generate(to_a.collect(&:attributes), options)
          end
        end
      end
    end
  end
  if defined?(Mongoid::Document)
    Mongoid::Document.include(TableFormat::ActiveRecord)
  end
end
