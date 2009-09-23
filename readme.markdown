Welcome to Completeness-Fu
==========================

Quite simply put, this plugin for ActiveRecord allows you cleanly define the way a model is scored for completeness, similar to LinkedIn.

For example, if you want your model to only be regarded as complete if it has a title, description, and picture, you can do the following:

    define_completeness_scoring do
      check :title,       lambda { |per| per.title.present? },  :high
      check :description, lambda { |per| per.description.present? }, :medium
      check :main_image,  lambda { |per| per.main_image? },     :low
    end

And what you get for free on the model : _passed\_checks_, _failed\_checks_, _completeness\_score_, _percent\_complete_.

You can also add the following to an initializer to set some defaults:

    CompletenessScoring.common_weights = { :low => 30, :medium => 50, :high => 70 }

    CompletenessScoring.default_weighting = :medium

You can also override defaults per model

    define_completeness_scoring do
      weights :low => 30, :super_high => 60
      default_weighting :medium

      check :title,       lambda { |per| per.title.present? }, :super_high
      check :description, lambda { |per| per.description.present? }
      check :main_image,  lambda { |per| per.main_image? }, :low
    end
  
At present the plugin only works with Rails 2.3 onwards (I18n is required)  


Passed checks and Fails checks
------------------------------

Both the _passed\_checks_ and _failed\_checks_ methods return an array of hashes with extended information about the check.
The check hash includes a translated title, description and extra information which is based on the name of the check.
The translation structure is as such:

    en:
      completeness_scoring:
        models:
          my_model:
            name_of_check:
              title: 'Title'
              description: 'The Check Description'
              extra: 'Extra Info'


Up and coming features
----------------------

- options to save the score to a field (caching) - good for searching on
- ability to 'share' common lambdas 
- define methods on the class to use in the checks
- better docs
- more tests
- add a rails version check
- add backwards compatibility for other rails versions

