require 'minitest/spec'
require 'minitest/autorun'
require 'webmock/minitest'
require "mocha/setup"
require 'exotel'

Exotel.configure do |c|
	c.exotel_sid   = "test_sid"
	c.exotel_token = "test_token"
end
