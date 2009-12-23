require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

$stdout = StringIO.new

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :rabbits do |t|
      t.string  :name
      t.integer :legs
      t.float   :weight
      t.string  :email
      t.timestamps
    end
  end  
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end  
end

#setup_db
class Rabbit < ActiveRecord::Base
  strip_attributes :email
end
#teardown_db
