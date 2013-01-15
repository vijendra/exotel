# -*- encoding: utf-8 -*-
require 'httparty'
module Exotel
  class Sms
    include HTTParty
    base_uri "https://twilix.exotel.in/v1/Accounts"
    
    def initialize
    end
    
    def send(params={})
      if !params.key? :To or !params.key? :Body
        raise Exotel::ParamsError, "Missing required parameter"
      end
      if !params.key? :From
        params[:From] = ''
      end

      # for backward compatibility
      params.each do |k,v|
        params[k.gsub(/^([a-z])/) {$1.capitalize}] = v
      end
      
      response = self.class.post("/#{Exotel.exotel_sid}/Sms/send",  {:body => params, :basic_auth => auth })
      handle_response(response)
    end
   
    def details(sid)
      response = self.class.get("/#{Exotel.exotel_sid}/Sms/Messages/#{sid}",  :basic_auth => auth)
      handle_response(response)
    end
    
    protected
    
    def auth
      {:username => Exotel.exotel_sid, :password => Exotel.exotel_token}
    end
    
    def handle_response(response)
      case response.code.to_i
 	    when 200...300 then Exotel::Response.new(response)
      when 401 then raise Exotel::AuthenticationError, "#{response.body} Verify your sid and token." 
 	    else
 	      raise Exotel::UnexpectedError, response.body
 	    end
    end
  end
end  



