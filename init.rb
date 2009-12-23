require File.dirname(__FILE__) + '/lib/suture_attributes'
ActiveRecord::Base.send(:include, SutureAttributes)
