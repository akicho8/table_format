module TableFormat
  class Railtie < Rails::Railtie
    initializer 'table_format' do
      ActiveSupport.on_load(:active_record) do
        include TableFormat::ActiveRecord
        ::ActiveRecord::Result.include TableFormat::ActiveRecordResult

        ::ActiveRecord::Relation.class_eval do
          def to_t(options = {})
            TableFormat.generate(to_a.collect(&:attributes), options)
          end
        end
      end

      if defined?(Mongoid::Document)
        Mongoid::Document.include(TableFormat::ActiveRecord)
      end
    end
  end
end
