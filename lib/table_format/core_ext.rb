require 'active_support/core_ext/kernel/concern'

module TableFormat
  concern :ActiveRecord do
    class_methods do
      def to_t(**options)
        TableFormat.generate(all.collect(&:attributes), options)
      end
    end

    def to_t(**options)
      TableFormat.generate(attributes, options)
    end
  end

  concern :ActiveRecordResult do
    def to_t(**options)
      TableFormat.generate(collect(&:to_h), options)
    end
  end
end

Object.class_eval do
  def to_t(**options)
    case
    when respond_to?(:to_a)
      if false
        if to_a.first.respond_to?(:attributes)
          return to_a.collect(&:attributes).to_t(options)
        end
      end

      to_a.to_t(options)
    when respond_to?(:to_h)
      to_h.to_t(options)
    else
      TableFormat.generate([{self.class.name => self}], {header: false}.merge(options))
    end
  end
end

Kernel.class_eval do
  private

  def tp(object, **options)
    object.tap do
      table_format(object, options).display
    end
  end

  def table_format(object, **options)
    object.to_t(options)
  end
end

Array.class_eval do
  def to_t(**options)
    TableFormat.generate(self, options)
  end
end

Hash.class_eval do
  def to_t(**options)
    TableFormat.generate(self, options)
  end
end

[Symbol, String, Numeric].each do |klass|
  klass.class_eval do
    def to_t(**options)
      TableFormat.generate([{self.class.name => self}], {header: false}.merge(options))
    end
  end
end
