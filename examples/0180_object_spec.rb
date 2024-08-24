$LOAD_PATH << "../lib"
require "table_format"
require "ostruct"

class C1
  extend Enumerable
  def self.each(&block)
    [:a, :b].each(&block)
  end
end

class C2
  extend Enumerable
  def self.each(&block)
    [[:a, :b]].each(&block)
  end
end

class C3
  extend Enumerable
  def self.each(&block)
    [
      {id: 1},
      {id: 2},
    ].each(&block)
  end
end

class C4
  extend Enumerable
  def self.each(&block)
    [
      OpenStruct.new(attributes: {id: 1}),
      OpenStruct.new(attributes: {id: 2}),
    ].each(&block)
  end
end

OpenStruct.new(attributes: {id: 1}).respond_to?(:attributes) # => true

tp C1
tp C2
tp C3
tp C4
# >> |---|
# >> | a |
# >> | b |
# >> |---|
# >> |----------|
# >> | [:a, :b] |
# >> |----------|
# >> |----|
# >> | id |
# >> |----|
# >> |  1 |
# >> |  2 |
# >> |----|
# >> |-----------------------------------|
# >> | #<OpenStruct attributes={:id=>1}> |
# >> | #<OpenStruct attributes={:id=>2}> |
# >> |-----------------------------------|
