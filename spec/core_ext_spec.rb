require_relative 'spec_helper'

describe TableFormat do
  require 'tempfile'
  require 'active_support/testing/stream'
  include ActiveSupport::Testing::Stream

  it do
    capture(:stdout) { tp 1 }.should == <<~EOT
|---|
| 1 |
|---|
    EOT
  end

  it 'result is like p method' do
    v = Object.new
    quietly { tp v }.should == v
  end

  it 'tp with options' do
    capture(:stdout) { tp({id: 123}, truncate: 1) }.should == <<~EOT
|------+------|
| i... | 1... |
|------+------|
EOT
  end

  it 'hankaku katakana' do
    capture(:stdout) { tp("ｱ") }.should == <<~EOT
|---|
| ｱ |
|---|
EOT
  end
end
