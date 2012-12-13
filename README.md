# exotel - A ruby wrapper for the Exotel API
======
# Installation
  gem install exotel

======  
# Usage
    # Configure authentication keys
    Exotel.configure do |c|
	    c.exotel_sid   = "Your exotel sid"
	    c.exotel_token = "Your exotel token"
    end
 
    #To send SMS
    sms = Exotel::Sms.new(from: 'FROM_NUMBER', to: 'TO_NUMBER', body: 'MESSAGE BODY')
    response = sms.send
    response.status 
======  
# Run tests
  rake test
 
======  
# TODO
Cover exotel call
