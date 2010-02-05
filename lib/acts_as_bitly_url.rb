# Author:: Max Schulze <max@maxschulze.com>
# Based on acts_as_tinyurl

require 'open-uri'
require 'json'

module ActsAsBitlyURL

  class ActsAsBitlyURLError < StandardError; end;    
  
  API_KEY = "" # Fill in API Key
  LOGIN = ""
  VERSION = "2.0.1"
  
  def bitly_url(uri, options = {}) 
    defaults = { :validate_uri => false }
    options = defaults.merge options
    return validate_uri(uri) if options[:validate_uri]
    return generate_uri(uri)
  end 

  private
  
  def validate_uri(uri)
    confirmed_uri = uri[/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix]
    if confirmed_uri.blank?
      return false
    else
      return true
    end
  end
  
  def generate_uri(uri)
    confirmed_uri = uri[/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix]
    if !confirmed_uri.blank?
      
      url = "http://api.bit.ly/shorten?version=#{VERSION}&longUrl=#{confirmed_uri}&login=#{LOGIN}&apiKey=#{API_KEY}"
      buffer = open(url.to_s).read
      result = JSON.parse(buffer)
      
      logger.info "Results from Bit.ly #{result.inspect}"
      
      shorturl = result['results'][confirmed_uri]['shortUrl'] unless result.blank?
      
      return shorturl
    else
      raise ActsAsBitlyURLError.new("Provided URL is incorrectly formatted.")
    end
  end
  
end