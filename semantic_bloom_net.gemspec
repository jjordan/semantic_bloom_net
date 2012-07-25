# -*- encoding: utf-8 -*-
require File.expand_path('../lib/semantic_bloom_net/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeremiah Jordan"]
  gem.email         = ["jjordan@perlreason.com"]
  gem.description   = %q{TODO: A semantic net implemented using bloom filters}
  gem.summary       = %q{TODO: A gem to provide a semantic net data structure implemented using bloom filters for fast comparisons of entire nets}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "semantic_bloom_net"
  gem.require_paths = ["lib"]
  gem.version       = SemanticBloomNet::VERSION
end
