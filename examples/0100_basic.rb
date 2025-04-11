$LOAD_PATH << "../lib"
require "table_format"

tp :ok
tp "foo"
tp :foo
tp [:alice, :bob]
tp({id: 1, name: "alice"})
tp [{id: 1, name: "alice"}, {id: 2, name: "bob"}]
puts [{id: 1, name: "alice"}, {id: 2, name: "bob"}].to_t
puts [{"a": ["a"]}].to_t
puts [{"a": {"a": 1}}].to_t
# >> |----|
# >> | ok |
# >> |----|
# >> |-----|
# >> | foo |
# >> |-----|
# >> |-----|
# >> | foo |
# >> |-----|
# >> |-------|
# >> | alice |
# >> | bob   |
# >> |-------|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
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
# >> |----+-------|
# >> |-------|
# >> | a     |
# >> |-------|
# >> | ["a"] |
# >> |-------|
# >> |--------|
# >> | a      |
# >> |--------|
# >> | {a: 1} |
# >> |--------|
