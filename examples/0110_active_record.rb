$LOAD_PATH << '../lib'
require 'active_record'
require 'table_format'

# tp ::ActiveRecord::Result.ancestors

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

['alice', 'bob', 'carol'].each { |e| User.create!(name: e) }

tp User.limit(2)

tp User
tp User.first

p User.limit(1).class.name      # => "ActiveRecord::Relation"
tp User.limit(1)
puts table_format(User.limit(1))

tp ActiveRecord::Base.connection.select_all('SELECT * FROM users')
tp ActiveRecord::Base.connection.select_one('SELECT * FROM users')
tp ActiveRecord::Base.connection.select_value('SELECT 1 + 2')

puts User.first.to_t

puts table_format(User.first)

puts Struct.new(:a, :b).new(1, 2).to_h.to_t

# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> |----+-------|
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> |  3 | carol |
# >> |----+-------|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
# >> "ActiveRecord::Relation"
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |----+-------|
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |----+-------|
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> |  3 | carol |
# >> |----+-------|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
# >> |---|
# >> | 3 |
# >> |---|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
# >> |---+---|
# >> | a | 1 |
# >> | b | 2 |
# >> |---+---|
