# -*- encoding: utf-8 -*-
module Exotel
  class Response
    attr_accessor :sid, :date_created, :date_updated, :status, :date_sent, :to, :from, :body
    
    def initialize(response)
      #To handle unexpected parsing from httparty
      response = MultiXml.parse(response) unless response.is_a?(Hash) 
      
      sms = response['TwilioResponse']['SMSMessage']
      @sid          = sms['Sid']
      @date_created = sms['DateCreated']
      @date_updated = sms['DateUpdated']
      @status       = sms['Status']
      @date_sent    = sms['DateSent']
      @to           = sms['To']
      @from         = sms['From']
      @body         = sms['Body']
    end
  end
end
