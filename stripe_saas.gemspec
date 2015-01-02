$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stripe_saas/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stripe_saas"
  s.version     = StripeSaas::VERSION
  s.authors     = ["Brian Sam-Bodden"]
  s.email       = ["bsbodden@integrallis.com"]
  s.homepage    = "https://github.com/integrallis/stripe_saas"
  s.summary     = "Stripe Payments/Subscription Engine for Rails 4."
  s.description = "Stripe Payments/Subscription Engine for Rails 4."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.asc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'stripe'
  s.add_dependency 'money-rails'

  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'devise', '~> 3.4.1'
end
