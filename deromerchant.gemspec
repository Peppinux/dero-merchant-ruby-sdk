Gem::Specification.new do |s|
  s.name        = "deromerchant"
  s.version     = "1.0.0"
  s.date        = "2020-08-05"
  s.summary     = "Ruby SDK for DERO Merchant REST API"
  s.description = "Library with bindings for the DERO Merchant REST API"
  s.authors     = ["Peppinux"]
  s.files       = `git ls-files`.split("\n")
  s.homepage    = "https://github.com/Peppinux/dero-merchant-ruby-sdk"
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.5"
  s.add_runtime_dependency("httparty", "~> 0.18", ">= 0.18.1")
end
