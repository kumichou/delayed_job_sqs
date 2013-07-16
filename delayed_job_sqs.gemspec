# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed/backend/version'

Gem::Specification.new do |s|
  s.require_paths = ["lib"]
  s.name          = "delayed_job_sqs"
  s.version       = Delayed::Backend::Sqs.version
  s.authors       = ["Eric Hankinson"]
  s.email         = ["eric.hankinson@gmail.com"]
  s.description   = "Amazon SQS backend for delayed_job"
  s.summary       = "Amazon SQS backend for delayed_job"
  s.homepage      = "https://github.com/kumichou/delayed_job_sqs"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency("aws-sdk", "1.11.1")
  s.add_dependency("delayed_job", ">= 3.0.0")

  s.add_development_dependency "rspec"
end

