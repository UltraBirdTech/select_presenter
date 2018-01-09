require 'pry'
require 'net/https'

# Google Homeにリクエストを送るクラス
class RequestForGoogleHome
  attr_reader :req, :http
  def initialize(uri)
    @http = initialize_http(uri)
    @req  = generate_request(uri)
  end

  def request(presenter)
    message = "Next Presenter is #{presenter}"
    @req.set_form_data(text: message)

    p message
    @http.request(@req)
  end

  private

  def initialize_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http
  end

  def generate_request(uri)
    Net::HTTP::Post.new(uri.path)
  end
end

array = %w[presenter_1 presenter_2 presenter_3]

domain = '6162e57d.ngrok.io'
post_address = "https://#{domain}/google-home-notifier"

google_home = RequestForGoogleHome.new(URI.parse(post_address))

copy_array = Marshal.load(Marshal.dump(array))

array.each do |_|
  binding.pry # rubocop:disable all
  p copy_array
  presenter = copy_array.sample
  google_home.request(presenter)
  copy_array.delete(presenter)
end
