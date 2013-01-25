# -*- encoding: utf-8 -*-
module Exotel
  class Response
    attr_accessor :sid, :date_created, :date_updated, :status, :date_sent, :to, :from, :body
    
    def initialize(response)
      #To handle unexpected parsing from httparty
      response = MultiXml.parse(response) unless response.is_a?(Hash) 
      
      params = response['TwilioResponse']

      (params['Call'] or params['SMSMessage']).each do |k, v|
        instance_variable_set "@#{underscore k}", v
      end

    end

    def underscore string
      string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
