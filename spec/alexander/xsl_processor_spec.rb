require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../../lib/alexander'

class DummyApp
  attr_accessor :xml, :xsl

  def initialize
    self.xml = Rack::MockResponse.new(
      200, {"Content-Type" => "application/xml;charset=utf-8"}, [<<-XML
<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="teste.xsl"?>
<root />
      XML
    ])
    self.xsl = Rack::MockResponse.new(
      200, {"Content-type" => "application/xslt+xml"}, [<<-XSL
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html><body></body></html>
  </xsl:template>
</xsl:stylesheet>
      XSL
    ])
  end

  def call(env)
    if env["REQUEST_PATH"] =~ /.*\.xsl/
      xsl
    else
      xml
    end
  end
end

CHROME_18 = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Ubuntu/11.10 Chromium/18.0.1025.151 Chrome/18.0.1025.151 Safari/535.19"
CURL = "curl/7.21.6 (x86_64-pc-linux-gnu) libcurl/7.21.6 OpenSSL/1.0.0e zlib/1.2.3.4 libidn/1.22 librtmp/2.3"

describe Alexander::XslProcessor do

  def env_with_chrome
    {"HTTP_USER_AGENT" => CHROME_18}
  end

  def env_with_curl
    {"HTTP_USER_AGENT" => CURL}
  end

  before do
    @dummy_app = DummyApp.new
    @filter = Alexander::XslProcessor.new(@dummy_app)
  end

  def app
    @filter
  end

  describe "when response is NOT XML" do
    it "should pass the response as is" do
      @dummy_app.xml = Rack::MockResponse.new(200, {"Content-type" => "text/html"}, ["<html></html>"])
      status, headers,response = @filter.call(env_with_chrome)
      response.body.must_equal @dummy_app.xml.body
    end
  end

  describe "when response is XML" do
    describe "when request came from a XSLT enable browser" do
      it "should let response as is" do
        status, headers, response = @filter.call(env_with_chrome)
        response.body.must_equal @dummy_app.xml.body
      end
    end
    describe "when request came from a XSLT NOT enable browser" do
      it "should parse XML to HTML" do
        status, headers, response = @filter.call(env_with_curl)
        status.must_equal 200
        headers["Content-type"].must_equal "text/html"
        response.body.must_equal ["<html><body></body></html>\n"]
      end
    end
    describe "when response is a XML without stylesheet" do
      it "should let response as is" do
        @dummy_app.xml = Rack::MockResponse.new(200, {"Content-type" => "application/xml"}, [<<-XML
<?xml version="1.0" encoding="utf-8"?>
<root />
        XML
        ])
        status, header, response = @filter.call(env_with_curl)
        response.body.must_equal @dummy_app.xml.body
      end
    end
  end
end

