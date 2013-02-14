# -*- encoding: utf-8 -*-
require 'httparty'
module Exotel
  class Call
    include HTTParty
    base_uri "https://twilix.exotel.in/v1/Accounts"
    
    def initialize; end
    
    #TODO check if this is a good decision to provide a wrapper.
    def self.connect_to_flow(params={})
      self.new.connect_to_flow(params)
    end

    def self.connect_to_agent(params={})
      self.new.connect_to_agent(params)
    end
    
    def connect_to_flow(params={})
      if valid?(params, {:type => 'flow'})
        params = transfrom_params(params, {:type => 'flow'})
        make_call(params)
      end
    end
    
    def connect_to_agent(params={})
      if valid?(params, {:type => 'agent'})
        params = transfrom_params(params, {:type => 'agent'})
        make_call(params)
      end
    end
 
    
    protected
    
    def make_call(params)
      response = self.class.post(URI.escape("/#{Exotel.exotel_sid}/Calls/connect"), {:body => params, :basic_auth => auth })
      handle_response(response)
    end
    
    def valid?(params, options)
      mandatory_keys = [:from, :to, :caller_id, :call_type]
      mandatory_keys << :flow_id if options[:type] == 'flow'
      
      unless mandatory_keys.all?{|key| params.keys.include?(key)}
        raise Exotel::ParamsError, "Missing one or many required parameters." 
      end 
      valid_call_type?(params)
      return true  
    end
    
    def valid_call_type?(params)
      raise Exotel::ParamsError, "Call Type is not valid" unless ['trans', 'promo'].include?(params[:call_type])
    end
    
    def auth
      {:username => Exotel.exotel_sid, :password => Exotel.exotel_token}
    end
    
    def flow_url(flow_id)
      "http://my.exotel.in/exoml/start/#{flow_id}"
    end
    
    def transfrom_params(params, options)
      if options[:type] == 'flow'
        #Construct flow url and delete flow_id.
        params = params.merge(:URL => flow_url(params[:flow_id]))
        params.delete(:flow_id)
      end
        
      #Keys are converted to camelcase
      params.inject({}){ |h, (key, value)| h[camelcase_key(key)] = value; h }
    end
    
    def camelcase_key(key)
      key.to_s.split('_').map(&:capitalize).join.to_sym #Input: call_type, Output: :CallType
    end
    
    def handle_response(response)
      case response.code.to_i
 	    when 200...300 then Exotel::Response.new(response)
      when 401 then raise Exotel::AuthenticationError, "#{response.body} Verify your sid and token." 
      when 403 then Exotel::Response.new(response)
 	    else
 	      raise Exotel::UnexpectedError, response.body
 	    end
    end
  end
end  



