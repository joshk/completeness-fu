begin
  require 'bundler/setup'
rescue LoadError
  puts 'although not required, its recommended you use bundler when running the tests'
end

require 'test/unit'
require 'shoulda'
require 'mocha'

require 'active_model'

require 'completeness-fu'


ROOT = File.join(File.dirname(__FILE__), '..')

I18n.load_path << File.join(ROOT, 'test', 'en.yml')


def rebuild_class(class_name)
  Object.send(:remove_const, class_name) rescue nil

  klass = Object.const_set(class_name, Class.new)

  klass.class_eval do
    include ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    include CompletenessFu::ActiveModelAdditions

    attr_accessor :title
  end

  klass
end