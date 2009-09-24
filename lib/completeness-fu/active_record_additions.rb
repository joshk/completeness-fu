module CompletenessFu
  
  class << self
    attr_accessor :common_weightings
    attr_accessor :default_weightings
  end
    
  
  module ActiveRecordAdditions
    
    def self.included(base)
      base.class_eval do
        def self.define_completeness_scoring(&checks_block)
          class_inheritable_array :completeness_checks
          cattr_accessor :default_weighting
          cattr_accessor :model_weightings
          
          self.send :extend, ClassMethods
          self.send :include, InstanceMethods

          self.completeness_checks ||= []
          self.default_weighting   ||= CompletenessFu.default_weightings
          self.model_weightings    ||= CompletenessFu.common_weightings
          
          self.instance_eval(&checks_block)
        end
      end
    end
    
    
    module ClassMethods
      def max_completeness_score
        self.completeness_checks.inject(0) { |score, check| score += check[:weighting] }
      end
      
      private 
        def check(name, check, weighting = nil)
          weighting ||= self.default_weighting
          weighting = self.model_weightings[weighting] if weighting.is_a?(Symbol)
          self.completeness_checks << { :name => name, :check => check, :weighting => weighting}
        end
        
        def weightings(custom_weighting_opts)
          use_common = custom_weighting_opts.delete(:merge_with_common)
          if use_common
            self.model_weightings.merge!(custom_weights)
          else
            self.model_weightings = custom_weighting_opts
          end
        end
        
        def cache_score(score_type = :relative)
          before_validation lambda { |instance| instance.send :cache_completeness_score, score_type }
        end        
    end
    
    
    module InstanceMethods
      # returns an array of hashes with the translated name, description + weighting
      def failed_checks
        self.completeness_checks.inject([]) do |failures, check| 
          failures << translate_check_details(check) if not check[:check].call(self)
          failures
        end
      end
      
      # returns an array of hashes with the translated name, description + weighting
      def passed_checks
        self.completeness_checks.inject([]) do |passed, check| 
          case check[:check]
          when Proc
            passed << translate_check_details(check) if check[:check].call(self)
          when Symbol
            passed << translate_check_details(check) if self.send check[:check]
          end
          
          passed
        end
      end
      
      # returns the absolute complete score
      def completeness_score
        sum_score = 0
        passed_checks.each { |check| sum_score += check[:weighting] }
        sum_score
      end
      
      # returns the percentage of completeness (relative score)
      def percent_complete
        self.completeness_score.to_f / self.class.max_completeness_score.to_f  * 100
      end
      
      
      private 
      
        def translate_check_details(full_check)
          default_translation_path = "completeness_scoring.models.#{self.class.name.downcase}"
          title = I18n.t("#{default_translation_path}.#{full_check[:name]}.title")
          desc  = I18n.t("#{default_translation_path}.#{full_check[:name]}.description")
          extra = I18n.t("#{default_translation_path}.#{full_check[:name]}.extra")
          
          full_check.merge({ :title => title, :description => desc, :extra => extra})
        end
        
        def cache_completeness_score(score_type)
          score = case score_type
                  when :relative
                    self.percent_complete
                  when :absolute
                    self.completeness_score
                  else
                    raise ArgumentException, 'completeness scoring type not recognized'
                  end
          self.cached_completeness_score = score
        end
    end
    
  end
  
end