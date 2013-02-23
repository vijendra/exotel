# exotel - A ruby wrapper for the Exotel API
[![Build Status](https://travis-ci.org/vijendra/exotel.png?branch=master)](https://travis-ci.org/vijendra/exotel)  [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/vijendra/exotel)

## Installation
  gem install exotel

## Usage
  **Configure authentication keys**
  
    Exotel.configure do |c|
      c.exotel_sid   = "Your exotel sid"
      c.exotel_token = "Your exotel token"
    end
 
  **To send SMS**
  
    response = Exotel::Sms.send(:from => 'FROM_NUMBER', :to => 'TO_NUMBER', :body => 'MESSAGE BODY')
    sms_id = response.sid #sid is used to find the delivery status and other details of the message in future.
    
  **To get the details/check the delivery status of a sms**
  
    sms = Exotel::Sms.details(sms_id)
    status = response.status
    date_sent = response.date_sent
    
  **To connect a customer to an agent in your company**
  
    response = Exotel::Call.connect_to_agent(:to => 'Your Exotel Virtual Number', :from => 'The customer phone number that will be called', :caller_id => 'Your Exotel Number', :call_type => 'trans or promo')
    call_id = response.sid #sid is used to find the details of the call. Ex: Total price of teh call. 
    
    For complete details about the parameters refer exotel api doc.
    http://goo.gl/nx4Tf
  
  **To connect a customer to an existing App/Flow**
  
    response = Exotel::Call.connect_to_agent(:to => 'Your Exotel Virtual Number', :from => 'The customer phone number that will be called', :caller_id => 'Your Exotel Number', :call_type => 'trans or promo'. :flow_id => 'App/Flow id to be connected')
    call_id = response.sid #sid is used to find the details of the call. Ex: Total price of teh call. 
    
    For complete details about the parameters refer exotel api doc.
    http://goo.gl/0zxMx
  
  **To get the details of a call**
  
    sms = Exotel::Call.details(call_id)
    price = response.price
    status = response.status
    duration = response.duration
  
  **DND numbers**  
   response.status = 'DND'
   
   response.message will be some thing like 'Call to ****** cannot be made because of TRAI NDNC regulations'
   
## Run tests
  rake test
