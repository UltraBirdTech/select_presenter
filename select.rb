require 'pry'
require 'net/https'

class RequestForGoogleHome
  attr_reader :req, :http
  def initialize(uri)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    @http = http
    @req = Net::HTTP::Post.new(uri.path)
  end

  def request(presenter)
    message = "Next Presenter is #{presenter}"
    @req.set_form_data({ text: message })

    p message 
    res = @http.request(@req)
  end
end

arr = %w(presenter_1 presenter_2 presenter_3)

domain = '6162e57d.ngrok.io'
post_address = "https://#{domain}/google-home-notifier"

google_home = RequestForGoogleHome.new(URI.parse(post_address))

continue_num = arr.size

for num in 0...continue_num
  binding.pry
  p arr
  presenter = arr.sample
  google_home.request(presenter)
  arr.delete(presenter)
end

