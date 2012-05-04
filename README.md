# Alexander

A Rack middleware to process XML through XSLT to generate HTML.

The process occur only:

1. If the file served is a XML (`mime-type: "application/xml"`);
2. **and** the XML has a stylesheet processing instruction (`<?xml-stylesheet type="text/xsl" href="/teste.xsl"?>`);
3. **and** the browser (`HTTP_USER_AGENT` header) has **no** support for XSLT processing.

If *any* of these conditions is *false*, Alexander will do nothing.

The XSLT processing can be forced in a XSLT enable browser passing "`force_xslt_parameter=true`" as URL parameter (`QUERY_STRING`). The parameter name is intentionaly long and specific to minimize chances of conflict.

## Installation

Add this line to your application's Gemfile:

    gem 'alexander'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alexander

## Usage

Add to your Rack stack:

    use Alexander::XslProcessor

## Browsers with XSLT processing support:

* Chrome &gt;= 1.0
* Firefox &gt;= 3.0
* Safari &gt;= 3.0
* Internet Explorer &gt;= 6.0
* Opera &gt;= 9.0

## CHANGELOG

0.5.0 - Initial published version
0.5.1 - "force_xslt_processing" parameter

## TODO
* Better error handling:
  * Invalid XML.
  * Invalid XSL.
  * XSL page not found.
* URL parameter to force XSLT processing.
* Config parameter to force XSLT processing.
* `Content-Type` control, make it able to produce things other than HTML.
* Examples of use in README.
  * Sinatra
  * Rails

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
