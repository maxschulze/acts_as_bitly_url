require File.dirname(__FILE__) + '/lib/acts_as_bitly_url' 
ActionView::Base.send(:include, ActsAsBitlyURL)
ActionController::Base.send(:include, ActsAsBitlyURL)
ActiveRecord::Base.send(:include, ActsAsBitlyURL)