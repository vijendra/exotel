# -*- encoding: utf-8 -*-
require 'httparty'
module Exotel
  class Call
    include HTTParty
    base_uri "https://twilix.exotel.in/v1/Accounts"
    
    def initialize
    end
    
    def make(params={})
      if !params.key? :From or !params.key? :To or !params.key? :CallerId or !params.key? :CallType
        raise Exotel::ParamsError, "Missing required parameter"
      end
      if !['trans', 'promo'].include? params[:CallType]
        raise Exotel::ParamsError, "CallType is not valid"
      end

      # make the params sensible
      swap = params[:From]
      params[:From] = params[:To]
      params[:To] = swap
      
      if params[:FlowId]
        params[:Url] = "http://my.exotel.in/exoml/start/#{params[:FlowId]}"
        params[:FlowId] = nil
      end
      
      response = self.class.post("/#{Exotel.exotel_sid}/Calls/connect",  { :body => params, :basic_auth => auth })
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



