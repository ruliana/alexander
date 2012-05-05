require 'rack'
require 'useragent'
require 'nokogiri'

module Alexander
  FORCE_PROCESSING_PARAMETER = "force_xslt_processing"

  Browser = Struct.new(:browser, :version)
  XSLT_ENABLE_BROWSERS = [
    Browser.new("Chrome", "1.0"),
    Browser.new("Firefox", "3.0"),
    Browser.new("Internet Explorer", "6.0"),
    Browser.new("Opera", "9.0"),
    Browser.new("Safari", "3.0")
  ]

  class XslProcessor

    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def call(env)
      response = @app.call(env)
      status, headers, body = response

      return response unless xml?(headers)

      force = force_processing?(env)
      return response if xlst_enable_browser?(env) && !force

      html_body = to_html(env, body)
      return response unless html_body

      headers["Content-type"] = "text/html"
      Rack::Response.new([html_body], status, headers).finish
    end

    def xml?(headers)
      headers["Content-Type"] =~ /\bapplication\/xml\b/
    end

    def xlst_enable_browser?(env)
      return false unless env && env["HTTP_USER_AGENT"]
      user_agent = UserAgent.parse(env["HTTP_USER_AGENT"])
      XSLT_ENABLE_BROWSERS.detect { |browser| user_agent >= browser }
    end

    def force_processing?(env)
      return true if @options[FORCE_PROCESSING_PARAMETER.to_sym]
      request = Rack::Request.new(env)
      request.params[FORCE_PROCESSING_PARAMETER] == "true"
    end

    def to_html(env, body)
      xml = body_to_string(body)
      xslt_request = find_xslt_path_in(xml)
      return unless xslt_request

      ask_xslt = env.dup
      ask_xslt["PATH_INFO"] = xslt_request
      ask_xslt["REQUEST_PATH"] = xslt_request
      ask_xslt["REQUEST_URI"] = xslt_request
      ask_xslt["QUERY_STRING"] = ""
      status, _, xslt = @app.call(ask_xslt)
      return unless status == 200

      xml_parsed = Nokogiri::XML(xml)
      xsl_parsed = Nokogiri::XSLT(body_to_string(xslt))
      xsl_parsed.transform(xml_parsed).to_s
    end

    def find_xslt_path_in(xml)
      match = xml.match(/<\?xml-stylesheet.*href="([^"]+)"/)
      match[1] if match
    end

    def body_to_string(body)
      result = ""
      body.each { |it| result << it }
      body.close if body.respond_to? :close
      result
    end
  end
end
