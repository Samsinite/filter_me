require 'bundler'

Bundler::GemHelper.install_tasks

task :console do
  require 'irb'
  require 'irb/completion'
  require 'my_gem' # You know what to do.
  ARGV.clear
  IRB.start
end
