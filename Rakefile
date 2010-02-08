require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the acts_as_asset_dispatcher plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/**/*_test.rb'
end
