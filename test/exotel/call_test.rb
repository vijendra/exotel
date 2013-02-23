require 'helper'

describe Exotel::Call do
  it 'should have a version' do
    Exotel::Call.must_include HTTParty
  end
  
  it 'should have the correct base_uri' do
    Exotel::Call.base_uri.must_equal "https://twilix.exotel.in/v1/Accounts"
  end
  
  describe '.connect_to_flow' do
    before do
      @params = {:from => '01234', :to => '04321', :caller_id => '04321', :call_type => 'trans', :flow_id => '3432'}
    end
    
    it "should pass the call to an object" do
      Exotel::Call.any_instance.expects(:connect_to_flow)
      Exotel::Call.connect_to_flow
    end
    
    describe 'success' do
      before do
        base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
        stub_request(:post, "https://test_sid:test_token@twilix.exotel.in/v1/Accounts/#{Exotel.exotel_sid}/Calls/connect").
        with(:body => {:From => '01234', :To => '04321', :CallerId => '04321', :CallType => 'trans', :Url => 'http://my.exotel.in/exoml/start/3432' }). 
        to_return(:status => 200, :body => File.new(base_path + '/fixtures/call.xml'))
      end
    
      it "should return the response object" do
        call = Exotel::Call.new
        response = call.connect_to_flow(@params)
        response.class.must_equal Exotel::Response
      end
      
      it "should set the response object values" do
        call = Exotel::Call.new
        response = call.connect_to_flow(@params)
        response.sid.must_equal 'CAe1644a7eed5088b159577c5802d8be38'
        response.date_created.must_equal 'Tue, 10 Aug 2010 08:02:17'
        response.date_updated.must_equal 'Tue, 10 Aug 2010 08:02:47' 
        response.start_time.must_equal  'Tue, 10 Aug 2010 08:02:31 +0000'
        response.end_time.must_equal  'Tue, 10 Aug 2010 08:02:47 +0000'
        response.status.must_equal 'completed'
        response.from.must_equal '01234'
        response.to.must_equal '04321'
      end
    end 
    
    describe 'autentication failed' do
      before do
        base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
        stub_request(:post, "https://test_sid:test_token@twilix.exotel.in/v1/Accounts/#{Exotel.exotel_sid}/Calls/connect").
        with(:body => {:From => '01234', :To => '04321', :CallerId => '04321', :CallType => 'trans', :Url => 'http://my.exotel.in/exoml/start/3432'}).
        to_return(:status => 401, :body => 'Authentication is required to view this page.')
      end
      
      it "should raise the authentication error" do
        call = Exotel::Call.new
        proc{call.connect_to_flow(@params)}.
            must_raise Exotel::AuthenticationError
      end
    end

    describe 'missing parameters' do
      before do
        @call = Exotel::Call.new
      end
      
      [:from, :to, :caller_id, :call_type, :flow_id].each do |param|
        it "should raise the missing params error when #{param} is missing" do
          @params.delete(param)
          proc{@call.connect_to_flow(@params)}.must_raise Exotel::ParamsError
        end
      end

       it "should raise the params exception for invalid :call_type" do
         @params[:call_type] = 'invalid'
         proc{@call.connect_to_flow(@params)}.must_raise Exotel::ParamsError
      end
    end
  end   
  
  describe '#details' do
    before do
      base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      stub_request(:get, "https://test_sid:test_token@twilix.exotel.in/v1/Accounts/#{Exotel.exotel_sid}/Calls/CAe1644a7eed5088b159577c5802d8be38").
      to_return(:status => 200, :body => File.new(base_path + '/fixtures/call.xml'))
    end
    
    it "should return the response object" do
      response = Exotel::Call.details('CAe1644a7eed5088b159577c5802d8be38')
      response.class.must_equal Exotel::Response
    end
      
    it "should set the response object values" do
      response = Exotel::Call.details('CAe1644a7eed5088b159577c5802d8be38')
      response.sid.must_equal 'CAe1644a7eed5088b159577c5802d8be38'
      response.status.must_equal 'completed'
      response.price.must_equal '2.3'
    end
  end  
  
end

