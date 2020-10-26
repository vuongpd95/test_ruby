require './base.rb'

str = "X" * 1024 * 1024 * 10

measure do
  str = str.downcase
end

measure do
  str.downcase!
end