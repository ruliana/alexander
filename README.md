# Alexander

A Rack middleware to process XML through XSLT to generate HTML.

It use the `<?xml-stylesheet ...?>` processing instruction found in XML to find wich XSLT to use. It works only if the XSLT is hosted inside the same application as the XML, as it does another call the the same Rack stack to find it.

The process occur only:

1. If the file served is a XML (`mime-type: "application/xml"`);
2. **and** the XML has a stylesheet processing instruction (`<?xml-stylesheet type="text/xsl" href="/teste.xsl"?>`);
3. **and** the browser (`HTTP_USER_AGENT` header) has **no** support for XSLT processing.

If *any* of these conditions is *false*, Alexander will do nothing.

The XSLT processing can be forced in a XSLT enable browser passing "`force_xslt_processing=true`" as URL parameter (`QUERY_STRING`). The parameter name is intentionaly long and specific to minimize chances of conflict.

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

If you want to force ALL requests to be processed by the server:

    use Alexander::XslProcessor, force_xslt_processing: true

## Browsers with XSLT processing support:

* Chrome &gt;= 1.0
* Firefox &gt;= 3.0
* Safari &gt;= 3.0
* Internet Explorer &gt;= 6.0
* Opera &gt;= 9.0

## CHANGELOG

* 0.5.0 - Initial published version
* 0.6.0 - Adding "force_xslt_processing" parameter to URL and config

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
