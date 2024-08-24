$LOAD_PATH << "../lib"
require "table_format"

tp 1, intersection_both: "+"

tp TableFormat.default_options
TableFormat.default_options.update(intersection_both: "+")
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
# >> |          truncate | 256   |
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
# >> |          truncate | 256   |
# >> |           in_code | UTF-8 |
# >> +-------------------+-------+
