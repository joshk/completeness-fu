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


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name    = "completeness-fu"
    gemspec.summary = "Simple dsl for defining how to calculate how complete a model instance is (similar to LinkedIn profile completeness)"
    gemspec.author  = "Josh Kalderimis"
    gemspec.email   = "josh.kalderimis@gmail.com"
    gemspec.homepage = "http://github.com/joshk/completeness-fu"
    
    gemspec.files = FileList[
        "init.rb",
        "lib/**/*.rb",
        "readme.textile",
        "VERSION.yml"
      ]
    gemspec.test_files = FileList["test/**/*"]
    
    gemspec.add_dependency 'activerecord', '>= 2.3.3'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
