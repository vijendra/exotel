# -*- encoding: utf-8 -*-
module Exotel
  class Response
    
    def initialize(response)
      #To handle unexpected parsing from httparty
      response = MultiXml.parse(response) unless response.is_a?(Hash) 
      response_base = response['TwilioResponse']
      unless response_base.include?('RestException')
        set_response_data(response_base)
      else
        set_response_error(response_base)
      end
    end
    
    def set_response_data(response_base)
      (response_base['Call'] or response_base['SMSMessage']).each do |key, value|
        set_variable(key, value)
      end
    end
    
    def set_response_error(response_base)
      response_base['RestException'].each do |key, value|
        set_variable(key, value)
        instance_variable_set('@status', 'DND') #Override
      end
    end
    
    def set_variable(key, value)
      attr_name = underscore_format(key)
      self.class.send(:attr_accessor, attr_name) #Set accessors dynamically
      instance_variable_set("@#{attr_name}", value)
    end
    
    protected
 
    #TODO: CamelCase to underscore: check if we have to add this to string class.
    def underscore_format(string)
      string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
