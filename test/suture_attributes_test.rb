require File.dirname(__FILE__) + '/test_helper'

class SutureAttributesTest < ActiveSupport::TestCase
  def setup
    setup_db
    @rabbit = Rabbit.new
  end

  def teardown
    teardown_db
  end

  test 'should strip everything except digits from integer attributes' do
    @rabbit.legs  = ' $45 '
    @rabbit.valid?
    assert_equal 45, @rabbit.legs
  end

  test 'should strip everything except digits and dots from float attributes' do
    @rabbit.weight = ' $45.56 u '
    @rabbit.valid?
    assert_equal 45.56, @rabbit.weight
  end

  test 'should ignore commas' do
    @rabbit.weight = '400,500'
    @rabbit.valid?
    assert_equal 400500, @rabbit.weight
  end

  test 'should allow negative numbers' do
    @rabbit.weight = '- $45.56 '
    @rabbit.valid?
    assert_equal -45.56, @rabbit.weight
  end

  test 'should allow nil values' do
    @rabbit.weight = nil
    @rabbit.valid?
    assert_nil @rabbit.weight
  end

  test 'should not change nonnumeric fields' do
    @rabbit.name = '$ foo 45,56 bar'
    @rabbit.valid?
    assert_equal '$ foo 45,56 bar', @rabbit.name
  end
  
  test 'should strip spaces from specified fields' do
    @rabbit.email = ' foo@bar.com '
    @rabbit.valid?
    assert_equal 'foo@bar.com', @rabbit.email
  end

  test 'should preserve nil values' do
    @rabbit.email = nil
    @rabbit.valid?
    assert_nil @rabbit.email
  end

  test 'should not strip spaces from other fields' do
    @rabbit.name = ' Rabbit '
    @rabbit.valid?
    assert_equal ' Rabbit ', @rabbit.name
  end
end
