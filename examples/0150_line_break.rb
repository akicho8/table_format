$LOAD_PATH << '../lib'
require 'table_format'

TableFormat.default_options.update(truncate: 2)

tp [
  {id: 1, name: "foo\nbar" },
]
# >> |----+----------|
# >> | id | name     |
# >> |----+----------|
# >> |  1 | foo\nbar |
# >> |----+----------|
