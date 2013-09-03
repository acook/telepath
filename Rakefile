require 'bundler/gem_tasks'

begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :test_with_coveralls => [:spec, :features, 'coveralls:push']
rescue LoadError
  puts "Couldn't load Coveralls tasks, hope you didn't need those for anything!"
end
