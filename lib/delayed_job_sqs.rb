# encoding: utf-8
require 'aws-sdk'
require 'delayed_job'
require 'active_support'

module ActiveSupport
  Inflector.inflections do |inflect|
    inflect.irregular('sqs', 'sqs')
  end
end

require_relative 'delayed/serialization/sqs'
require_relative 'delayed/backend/actions'
require_relative 'delayed/backend/sqs_config'
require_relative 'delayed/backend/worker'
require_relative 'delayed/backend/version'
require_relative 'delayed/backend/sqs'

Delayed::Worker.backend = :sqs

