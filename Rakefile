require 'rubygems'
begin
  require 'bundler/setup'
  require 'appraisal'
rescue LoadError
  puts 'although not required, its recommended you use bundler during development'
end

require 'rake'

Bundler::GemHelper.install_tasks

desc 'Default: run unit tests.'
task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.libs << "test"
  t.verbose = true
end

require 'rake/rdoctask'