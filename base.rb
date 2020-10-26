require 'rubygems'
require 'bundler'
require 'pp'
Bundler.require(:default)

require "json"
require "benchmark"

class Hash
  def -(val)
    val = val.to_hash
    return {} if self.keys.sort != val.keys.sort
    result = {}
    self.each do |k, v|
      result[k] = v.to_int - val[k].to_int
    end
    result
  end
end

def measure(&block)
  no_gc = (ARGV[0] == "--no-gc")
  if no_gc
    GC.disable
  else
    # collect memory allocated during library loading
    # and our own code before the measurement
    GC.start
  end
  memory_before = `ps -o rss= -p #{Process.pid}`.to_i/1024
  gc_stat_before = GC.stat
  time = Benchmark.realtime do
    yield
  end
  obefore = ObjectSpace.count_objects
  unless no_gc
    GC.start(full_mark: true, immediate_sweep: true)
  end
  oafter = ObjectSpace.count_objects
  gc_stat_after = GC.stat
  memory_after = `ps -o rss= -p #{Process.pid}`.to_i/1024
  pp({
    RUBY_VERSION => {
      gc: no_gc ? 'disabled' : 'enabled',
      time: time.round(2),
      gc_count: gc_stat_after[:count] - gc_stat_before[:count],
      memory: "%d MB" % (memory_after - memory_before),
      object_space: (oafter - obefore)
    }
  })
end
