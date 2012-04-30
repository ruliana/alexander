# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sandra/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ronie Uliana"]
  gem.email         = ["ronie.uliana@gmail.com"]
  gem.description   = %q{A Rack middleware to compile XML+XSLT into HTML for unsupported browsers only}
  gem.summary       = %q{XSLT is old and still sexy, but not for the masses. Sandra will do the work for lazy browsers, and will do nothing for the muscly ones}
  gem.homepage      = ""

  gem.add_dependency("nokogiri", "~>1.5")
  gem.add_dependency("useragent", "~>0.4")

  gem.add_development_dependency("reloader", "~>0.1")
  gem.add_development_dependency("minitest", "~>2.12")
  gem.add_development_dependency("minitest-matchers", "~>1.2")
  gem.add_development_dependency("minitest-colorize", "~>0.0.4")
  gem.add_development_dependency("guard", "~>1.0")
  gem.add_development_dependency("guard-minitest", "~>0.5")
  gem.add_development_dependency("simplecov", "~>0.6")

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sandra"
  gem.require_paths = ["lib"]
  gem.version       = Sandra::VERSION
end
