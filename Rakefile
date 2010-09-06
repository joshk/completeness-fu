require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
 puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'


desc 'Default: run unit tests.'
task :default => [:test]

desc 'Test the completeness scoring plugin.'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gs|
    gs.name    = "completeness-fu"
    gs.summary = "Simple dsl for defining how to calculate how complete a model instance is (similar to LinkedIn profile completeness)"
    gs.author  = "Josh Kalderimis"
    gs.email   = "josh.kalderimis@gmail.com"
    gs.homepage = "http://github.com/joshk/completeness-fu"

    gs.files = FileList[
        "init.rb",
        "lib/**/*.rb",
        "readme.textile",
        "VERSION.yml"
      ]
    gs.test_files = FileList["test/**/*"]

    gs.add_dependency 'activemodel', '~> 3.0.0'

    gs.add_development_dependency 'rake',    '~> 0.8.7'
    gs.add_development_dependency 'shoulda', '~> 2.11.3'
    gs.add_development_dependency 'mocha',   '~> 0.9.8'
    # gs.add_development_dependency 'mongoid', '~> 2.0.0.beta.17'
    # gs.add_development_dependency 'activerecord', '~> 3.0.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: `sudo gem install jeweler`"
end
