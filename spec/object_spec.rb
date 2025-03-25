require_relative "spec_helper"
require "ostruct"

describe TableFormat do
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

  it do
    C1.to_t.should == <<~EOT
|---|
| a |
| b |
|---|
EOT

    C2.to_t.should == <<~EOT
|----------|
| [:a, :b] |
|----------|
EOT

    C3.to_t.should == <<~EOT
|----|
| id |
|----|
|  1 |
|  2 |
|----|
EOT

    C4.to_t.should == <<~EOT
|----------------------------------|
| #<OpenStruct attributes={id: 1}> |
| #<OpenStruct attributes={id: 2}> |
|----------------------------------|
EOT
  end
end
