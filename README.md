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
  
    sms = Exotel::Sms.new
    response = sms.send(from: 'FROM_NUMBER', to: 'TO_NUMBER', body: 'MESSAGE BODY')
    sms_id = response.sid #Used to find the delivery status of the message in future.

  **To make a Call**
  
    call = Exotel::Call.new
    response = call.make(To: 'Customer's number', From: 'your exotel number', CallerId: 'Virtual number', FlowId: 'flow id to connect user to')
    sid = response.sid # if you want to make the flow dynamic, use this
 
  **To get the details/check the delivery status**
  
    sms = Exotel::Sms.new
    response = sms.details(sms_id)
    status = response.status

## Run tests
  rake test

## TODO
Tests for exotel call api wrappers
