$LOAD_PATH << '../lib'
require 'table_format'

tp 1, intersection_both: '+'

tp TableFormat.default_options
TableFormat.default_options.update(intersection_both: '+')
tp TableFormat.default_options

# >> +---+
# >> | 1 |
# >> +---+
# >> |-------------------+-------|
# >> |          markdown | false |
# >> |            header |       |
# >> |             cover | true  |
# >> |          vertical | |     |
# >> |      intersection | +     |
# >> | intersection_both | |     |
# >> |           horizon | -     |
# >> |           padding |       |
# >> |           in_code | UTF-8 |
# >> |-------------------+-------|
# >> +-------------------+-------+
# >> |          markdown | false |
# >> |            header |       |
# >> |             cover | true  |
# >> |          vertical | |     |
# >> |      intersection | +     |
# >> | intersection_both | +     |
# >> |           horizon | -     |
# >> |           padding |       |
# >> |           in_code | UTF-8 |
# >> +-------------------+-------+
