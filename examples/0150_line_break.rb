$LOAD_PATH << '../lib'
require 'table_format'

tp [
  {id: 1, name: "foo\nbar" },
]
# >> |----+----------|
# >> | id | name     |
# >> |----+----------|
# >> |  1 | foo\nbar |
# >> |----+----------|
