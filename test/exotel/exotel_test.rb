require 'helper'

describe Exotel do
  it 'should have a version' do
    Exotel::VERSION.wont_be_nil
  end
  
  it 'should have exotel_sid class variable' do
    Exotel.respond_to?('exotel_sid').must_equal true
    Exotel.respond_to?('exotel_sid=').must_equal true
  end
  
  it 'should have exotel_token class variable' do
    Exotel.respond_to?('exotel_token').must_equal true
    Exotel.respond_to?('exotel_token=').must_equal true
  end
  
  describe '.configure' do
    it 'should set the class variable values' do
      Exotel.exotel_sid.must_equal "test_sid"
      Exotel.exotel_token.must_equal "test_token"
    end
  end
end

