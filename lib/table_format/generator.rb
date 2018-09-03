# frozen_string_literal: true
require 'active_support/core_ext/string'          # for blank?
require 'active_support/core_ext/class/attribute' # for class_attribute
require 'kconv'

module TableFormat
  mattr_accessor :default_options do
    {
      markdown: false,       # Same as {intersection: '|', :cover: false}
      header: nil,
      cover: true,
      vertical: '|',
      intersection: '+',
      intersection_both: '|',
      horizon: '-',
      padding: ' ',
      truncate: 256,
      in_code: Kconv::UTF8,
    }
  end

  def self.generate(*args, &block)
    Generator.new(*args, &block).generate
  end

  class Generator
    def initialize(rows, **options)
      @options = TableFormat.default_options.merge(options)

      if @options[:markdown]
        @options[:intersection] = '|'
        @options[:cover] = false
      end

      @rows = rows
      @column_names = nil
    end

    def generate
      if @rows.blank?
        return ''
      end

      pre_processes.each do |e|
        if e[:_case][@rows]
          @rows = e[:process][@rows]
          if @options[:header].nil?
            @options[:header] = e[:header]
          end
          @options[:align] ||= e[:align]
        end
      end

      table_rows_build

      out = []
      if @options[:cover]
        out << separater
      end
      if @column_names
        out << header
        out << separater
      end
      out << body
      if @options[:cover]
        out << separater
      end
      out.flatten * "\n" + "\n"
    end

    private

    def table_rows_build
      if @options[:header]
        @column_names = all_columns
      end
      @table_rows = @rows.collect { |e| e.values_at(*all_columns) }

      @table_rows = @table_rows.collect do |values|
        values.collect do |value|
          if value
            value = value.to_s
            value = value.gsub(/\R/, "\\n")

            if @options[:truncate]
              if value.size > @options[:truncate]
                value = value[0, @options[:truncate]] + "..."
              end
            end
          end
          value
        end
      end
    end

    def all_columns
      @all_columns ||= @rows.inject([]) { |a, e| a | e.keys }
    end

    def column_widths
      @column_widths ||= ([@column_names] + @table_rows).compact.transpose.collect do |vertical_values|
        vertical_values.collect { |e| str_width(e) }.max
      end
    end

    def separater
      @separater ||= _separater
    end

    def _separater
      s = column_widths.collect { |e|
        @options[:horizon] * (padding.size + e + padding.size)
      }
      s = s.join(@options[:intersection])
      [@options[:intersection_both], s, @options[:intersection_both]].join
    end

    def header
      @header ||= line_str(@column_names)
    end

    def body
      @table_rows.collect { |row| line_str(row) }
    end

    def line_str(row)
      s = row.collect.with_index {|e, i|
        padding + just(e, i) + padding
      }
      s = s.join(@options[:vertical])
      [@options[:vertical], s, @options[:vertical]].join
    end

    def padding
      @options[:padding]
    end

    def just(value, i)
      align = (@options[:align] || {}).fetch(all_columns[i]) do
        Float(value) && :right rescue :left
      end
      space = ' ' * (column_widths[i] - str_width(value))
      lspace = ''
      rspace = ''
      if align == :right
        lspace = space
      else
        rspace = space
      end
      # If value is `[]`,
      # executing to_s, it becomes `[]`.
      # not executing to_s, it becomes empty string
      [lspace, value.to_s, rspace].join
    end

    def str_width(str)
      str.to_s.kconv(Kconv::EUC, @options[:in_code]).bytesize
    end

    def pre_processes
      [
        # Hash
        {
          _case: -> e { e.kind_of?(Hash) },
          header: false,
          process: -> e {
            e.collect do |k, v|
              {'(key)' => k.to_s, '(value)' => v.to_s}
            end
          },
          align: {'(key)' => :right, '(value)' => :left},
        },

        # Array of Hash
        {
          _case: -> e { e.kind_of?(Array) && e.all? { |v| v.kind_of?(Hash) } },
          header: true,
          process: -> e { e },
        },

        # Array excluding Hash
        {
          _case: -> e { e.kind_of?(Array) && e.none? { |v| v.kind_of?(Hash) } },
          header: false,
          process: -> e {
            e.collect do |v|
              {'(array_element)' => v}
            end
          },
        },

        # Array containing Hash and others
        {
          _case: -> e { e.kind_of?(Array) && e.any? { |v| !v.kind_of?(Hash) } },
          header: true,
          process: -> e {
            e.collect do |v|
              if v.kind_of? Hash
                v
              else
                {'(array_element)' => v}
              end
            end
          },
        },
      ]
    end
  end
end

if $0 == __FILE__
  rows = [
    {id: 1, name: 'alice', description: '0123456789'},
    {id: 2, name: 'bob',   description: 'あいうえお'},
    {id: 3, name: 'carol'},
  ]
  print TableFormat.generate({a: []})
  print TableFormat.generate([])
  print TableFormat.generate(rows)
  print TableFormat.generate({a: 1, b: 2}, header: false)
  print TableFormat.generate([["a", "b"], ["c", "d"]])
  print TableFormat.generate([["a", "b"], {"c" => "d"}])
  print TableFormat.generate({id: 1, created_at: "2000-01-01"})
end
# >> |---+----|
# >> | a | [] |
# >> |---+----|
# >> |----+-------+-------------|
# >> | id | name  | description |
# >> |----+-------+-------------|
# >> |  1 | alice |  0123456789 |
# >> |  2 | bob   | あいうえお  |
# >> |  3 | carol |             |
# >> |----+-------+-------------|
# >> |---+---|
# >> | a | 1 |
# >> | b | 2 |
# >> |---+---|
# >> |------------|
# >> | ["a", "b"] |
# >> | ["c", "d"] |
# >> |------------|
# >> |-----------------+---|
# >> | (array_element) | c |
# >> |-----------------+---|
# >> | ["a", "b"]      |   |
# >> |                 | d |
# >> |-----------------+---|
# >> |------------+------------|
# >> |         id | 1          |
# >> | created_at | 2000-01-01 |
# >> |------------+------------|
