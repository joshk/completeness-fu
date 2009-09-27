Welcome to Completeness-Fu
==========================

In short, completeness-fu for ActiveRecord allows you cleanly define the way a model instance is scored for completeness, similar to LinkedIn user profiles.


When should I use it?
---------------------

When you want your objects/models/instances to be of a certain standard, if it be data presence, format or what values are allowed and not allowed,
before an object can be saved or updated then you use validations. But when you want to allow more information to be entered, thus relaxing some 
of the validation rules and prompt the user to enrich the data, then completeness-fu is your cup of tea. 

Take an events web site for example, you may want to import information from various sources which might have varied data quality. 
If your validations are too strict then the information won't import, but if you relax your validations too much then you risk
having quantity but not quality. What you can do is relax the validations and add some quality checks which calculate a score
which is then used to determine if the event information is shown on the public site or is listed in the admin panel prompting 
staff to enrich the data before it is made public.


How do you use it?
------------------

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

You can also override defaults per model or use symbols for the checks instead of lambdas, thus allowing you to place check logic as methods in your class (public or private).

    define_completeness_scoring do
      weights :low => 30, :super_high => 60
      default_weighting :medium

      check :title,       lambda { |per| per.title.present? }, :super_high
      check :description, :description_present?
      check :main_image,  :main_image_or_pretty_picture?, :low
    end
  
And if you want to cache the score to a field so you can use it in database searches you just have to add the following:

    define_completeness_scoring do
      cache_score :absolute # the default is :relative

      check :title,       lambda { |per| per.title.present? }, :super_high
      check :description, :description_present?
    end

At present the plugin only works with Rails 2.3 onwards (I18n is required)  


Passed checks and Failed checks and i18n
----------------------------------------

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

- enhance caching so filter type can be changed and field to save score to can be customized
- ability to 'share' common lambdas 
- better docs
- more tests
- add a rails version check
- add backwards compatibility for other rails versions


Change Log
----------

28 Sep 09

- move the scoring check builder into its own class so that it works within a clean room

24 Sep 09

- options to save the score to a field (caching) - good for searching on
- define methods on the class to use in the checks ( 24-Sep )