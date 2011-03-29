module CompletenessFu
  class CompletenessFuError < RuntimeError; end

  class << self
    attr_accessor :common_weightings
    attr_accessor :default_weighting
    attr_accessor :default_i18n_namespace
    attr_accessor :default_gradings
  end

  self.common_weightings  = { :low => 20, :medium => 40, :high => 60 }

  self.default_weighting  = 40

  self.default_i18n_namespace = [:completeness_scoring, :models]

  self.default_gradings = {
    :poor => 0..24,
    :low =>  25..49,
    :medium => 50..79,
    :high => 80..100
  }

  def self.setup_orm(orm_class)
    orm_class.class_eval { include CompletenessFu::ActiveModelAdditions }
  end

end

require 'completeness-fu/active_model_additions'
require 'completeness-fu/scoring_builder'


CompletenessFu.setup_orm(::ActiveRecord::Base)    if defined?(::ActiveRecord::Base)
CompletenessFu.setup_orm(::CassandraObject::Base) if defined?(::CassandraObject::Base)
CompletenessFu.setup_orm(::Mongoid::Document)     if defined?(::Mongoid::Document)
