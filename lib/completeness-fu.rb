module CompletenessFu
  class CompletenessFuError < RuntimeError; end

  class << self
    attr_accessor :common_weightings
    attr_accessor :default_weighting
    attr_accessor :default_i18n_namespace
    attr_accessor :default_gradings
  end
end

CompletenessFu.common_weightings  = { :low => 20, :medium => 40, :high => 60 }
CompletenessFu.default_weighting  = 40
CompletenessFu.default_i18n_namespace = [:completeness_scoring, :models]
CompletenessFu.default_gradings = {
  :poor => 0..24,
  :low =>  25..49,
  :medium => 50..79,
  :high => 80..100
}

require 'completeness-fu/active_model_additions'
require 'completeness-fu/scoring_builder'


::ActiveRecord::Base.class_eval    { include CompletenessFu::ActiveModelAdditions } if defined?(::ActiveRecord::Base)
::CassandraObject::Base.class_eval { include CompletenessFu::ActiveModelAdditions } if defined?(::CassandraObject::Base)
::Mongoid::Document.class_eval     { include CompletenessFu::ActiveModelAdditions } if defined?(::Mongoid::Document)
