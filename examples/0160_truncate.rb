$LOAD_PATH << '../lib'
require 'table_format'

TableFormat.default_options.update(truncate: 2)

tp [
  {id: 1, name: "0123456789" },
]
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | 01... |
# >> |----+-------|
