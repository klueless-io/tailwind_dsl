KManager.action :surround do
  action do




start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts 'xmen are cool - starting'
puts 'do some code'
sleep 3  # long running process
puts 'do some more code'

puts "xmen are cool - took: #{Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time} seconds"



















  end
end

KManager.opts.sleep = 5
