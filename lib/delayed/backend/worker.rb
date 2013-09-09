require_relative 'sqs_config'

module Delayed
  class Worker

    class << self
      attr_accessor :config, :sqs, :delay, :timeout, :expires_in, :aws_config

      def configure
        yield(config)

        self.default_queue_name = if !config.default_queue_name.nil? && config.default_queue_name.length != 0
                        config.default_queue_name
                      else
                        'default'
                      end
        self.delay = config.delay_seconds || 0
        self.timeout = config.visibility_timeout || 5.minutes
        self.expires_in = config.message_retention_period || 4.days
      end

      def config
        @config ||= SqsConfig.new
      end
    end

    # Override to remove reference to id: there's no id in an SQS::Job
    def job_say(job, text, level = DEFAULT_LOG_LEVEL)
      text = "Job #{job.name} #{text}"
      say text, level
    end    
  end

  module Backend
    module Sqs
      if Object.const_defined?(:Rails) and Rails.const_defined?(:Railtie)
        class Railtie < Rails::Railtie

          # configure our gem after Rails completely boots so that we have
          # access to any config/initializers that were run
          config.after_initialize do
            AWS::Rails.setup

            Delayed::Worker.sqs = AWS::SQS.new
            Delayed::Worker.configure {}
          end
        end
      else
        path = Pathname.new(Delayed::Worker.config.aws_config)

        if File.exists?(path)
          cfg = YAML::load(File.read(path))

          unless cfg.keys[0]
            raise "AWS Yaml configuration file is missing a section"
          end

          AWS.config(cfg.keys[0])
        end

        Delayed::Worker.sqs = AWS::SQS.new
        Delayed::Worker.configure {}
      end
    end
  end
end


