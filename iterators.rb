require './base.rb'

n = 10_000

GC.disable
before = ObjectSpace.count_objects
Array.new(n).each do |i|
  [0,1].each do |j|
  end
end
after = ObjectSpace.count_objects
pp(after - before)

before = ObjectSpace.count_objects
Array.new(n).each do |i|
  [0,1].each_with_index do |j, index|
  end
end
after = ObjectSpace.count_objects
pp(after - before)
