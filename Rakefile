require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'rubygems'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')


desc 'Default: run unit tests.'
task :default => [:test]

desc 'Test the completeness scoring plugin.'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end