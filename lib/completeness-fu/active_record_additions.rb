module CompletenessFu
  
  class << self
    attr_accessor :common_weightings
    attr_accessor :default_weighting
    attr_accessor :default_i18n_namespace
    attr_accessor :default_gradings
  end
    
  class CompletenessFuError < Exception; end
  
  module ActiveRecordAdditions
    
    def self.included(base)
      base.class_eval do
        def self.define_completeness_scoring(&checks_block)
          class_inheritable_array :completeness_checks
          cattr_accessor :default_weighting
          cattr_accessor :model_weightings
          
          self.send :extend, ClassMethods
          self.send :include, InstanceMethods
          
          checks_results = CompletenessFu::ScoringBuilder.generate(self, &checks_block)
          
          self.default_weighting   = checks_results[:default_weighting]
          self.completeness_checks = checks_results[:completeness_checks]
          self.model_weightings    = checks_results[:model_weightings]
          self.before_validation checks_results[:cache_score_details] if checks_results[:cache_score_details]
        end
      end
    end
    
    
    module ClassMethods
      def max_completeness_score
        self.completeness_checks.inject(0) { |score, check| score += check[:weighting] }
      end
    end
    
    
    module InstanceMethods
      # returns an array of hashes with the translated name, description + weighting
      def failed_checks
        all_checks_which_pass(false)
      end
      
      # returns an array of hashes with the translated name, description + weighting
      def passed_checks
        all_checks_which_pass
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
      
      # returns a basic 'grading' based on percent_complete, defaults are :high, :medium, :low, and :poor
      def completeness_grade
        CompletenessFu.default_gradings.each do |grading| 
          return grading.first if grading.last.include?(self.percent_complete.round) 
        end
        raise CompletenessFuError, "grade could not be determined with percent complete #{self.percent_complete.round}"
      end
      
      
      private 
      
        def all_checks_which_pass(should_pass = true)
          self.completeness_checks.inject([]) do |results, check|
            check_result = run_check(check[:check]) 
            results << translate_check_details(check) if (should_pass ? check_result : !check_result)
            results
          end
        end
        
        def run_check(check)
          case check
          when Proc
            return check.call(self)
          when Symbol
            return self.send check
          else
            raise CompletenessFuError, "check of type #{check.class} not acceptable"
          end
        end
        
        def translate_check_details(full_check)
          namespace = CompletenessFu.default_i18n_namespace + [self.class.name.downcase.to_sym, full_check[:name]]
          
          translations = [:title, :description, :extra].inject({}) do |list, field|
                           list[field] = I18n.t(field.to_sym, :scope => namespace)
                           list
                         end
          
          full_check.merge(translations)
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
          self.cached_completeness_score = score.round
          true
        end
    end
    
  end
  
end