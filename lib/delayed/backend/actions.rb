module Delayed
  module Backend
    module Sqs
      module Actions
        def field(name, options = {})
          default = options[:default] || nil
          define_method name do
            @attributes ||= {}
            @attributes[name.to_sym] || default
          end

          define_method "#{name}=" do |value|
            @attributes ||= {}
            @attributes[name.to_sym] = value
          end
        end

        def before_fork
        end

        def after_fork
        end

        def db_time_now
          Time.now.utc
        end

        def find_available(worker_name, limit = 5, max_run_time = Worker.max_run_time)
          Delayed::Worker.queues.each_with_index do |queue, index|
            message = sqs.queues.named(queue_name(index)).receive_message
            return [Delayed::Backend::Sqs::Job.new(message)] if message
          end
          []
        end

        def delete_all
          deleted = 0

          Delayed::Worker.queues.each_with_index do |queue, index|
            loop do
              msgs = sqs.queues.named(queue_name(index)).receive_message({ :limit => 10})
              break if msgs.blank?
              msgs.each do |msg|
                msg.delete
                deleted += 1
              end
            end
          end

          puts "Messages removed: #{deleted}"
        end

        # No need to check locks
        def clear_locks!(*args)
          true
        end

        private

        def sqs
          ::Delayed::Worker.sqs
        end

        def queue_name(index)
          Delayed::Worker.queues[index]
        end
      end
    end
  end
end
