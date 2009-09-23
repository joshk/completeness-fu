require 'completeness-fu/active_record_additions'

module ActiveRecord
  Base.class_eval do
    include CompletenessFu::ActiveRecordAdditions
  end
end

CompletenessFu.common_weightings = { :low => 20, :medium => 40, :high => 60 }
CompletenessFu.default_weightings = 40