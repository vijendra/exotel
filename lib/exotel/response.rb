# -*- encoding: utf-8 -*-
module Exotel
  class Response
    attr_accessor :sid, :date_created, :date_updated, :status, :date_sent, :to, :from, :body
    
    def initialize(response)
      parsed_response = MultiXml.parse(response)
      sms = parsed_response['TwilioResponse']['SMSMessage']
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
