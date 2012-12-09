require 'helper'

describe Exotel::Sms do
  it 'should have a version' do
    Exotel::Sms.must_include HTTParty
  end
  
  it 'should have the correct base_uri' do
    Exotel::Sms.base_uri.must_equal "https://twilix.exotel.in/v1/Accounts/#{Exotel.exotel_sid}"
  end
  
  describe '#initialize' do
    it "should set the fields hash as required by exotel" do
      sms = Exotel::Sms.new(from: '1234', to: '4321', body: 'Test sms')
      fields_hash = {From: '1234', To: '4321', Body: 'Test sms'}
      sms.instance_variable_get(:@fields).must_equal fields_hash
    end
  end
  
  describe '#send' do
    describe 'success' do
      before do
        base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
        stub_request(:post, "https://test_sid:test_token@twilix.exotel.in/v1/Accounts/Sms/send").
        with(:body => "From=1234&To=4321&Body=Test%20sms"). 
        to_return(:status => 200, :body => File.new(base_path + '/fixtures/sms.xml'))
      end
    
      it "should return the response object" do
        sms = Exotel::Sms.new(from: '1234', to: '4321', body: 'Test sms')
        response = sms.send
        response.class.must_equal Exotel::Response
      end
      
      it "should set the response object values" do
        sms = Exotel::Sms.new(from: '1234', to: '4321', body: 'Test sms')
        response = sms.send 
        response.sid.must_equal 'SM872fb94e3b358913777cdb313f25b46f'
        response.date_created.must_equal 'Sun, 09 Dec 2012 03:48:08'
        response.date_updated.must_equal 'Sun, 09 Dec 2012 03:48:10' 
        response.date_sent.must_equal  'Sun, 09 Dec 2012 03:48:10'
        response.status.must_equal 'sent'
        response.to.must_equal '4321'
        response.from.must_equal '1234'
        response.body.must_equal 'Test sms'
      end
    end 
    
    describe 'autentication failed' do
      before do
        base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
        stub_request(:post, "https://test_sid:test_token@twilix.exotel.in/v1/Accounts/Sms/send").
        with(:body => "From=1234&To=4321&Body=Test%20sms"). 
        to_return(:status=>401, :body => 'Authentication is required to view this page.')
      end
      
      it "should return the response object" do
        sms = Exotel::Sms.new(from: '1234', to: '4321', body: 'Test sms')
        proc{sms.send}.must_raise Exotel::AuthenticationError
      end
    end
  end
end

