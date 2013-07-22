This is an [Amazon SQS](http://aws.amazon.com/sqs/) backend for [delayed_job](http://github.com/collectiveidea/delayed_job)

# Getting Started

## Get credentials

To start using delayed_job_sqs, you need to sign up for an AWS account and setup your credentials.

1. Go to https://portal.aws.amazon.com/gp/aws/developer/registration/index.html and sign up.
2. Get your AWS Access Key Id & Secret Access Key for your account.
3. Either `require 'aws-sdk'` and call `AWS.config()` prior to `require 'delayed_job_sqs'`,  or create an aws.yml that will get loaded with your app. You will need to configure Delayed::Worker below to pass in the YAML file location:

```yaml
[aws]
  access_key_id: <your access key>
  secret_access_key: <your secret key>
```

Or if using Rails, create config/initializers/aws-sdk.rb and put the following into the file:

```ruby
AWS.config({
  access_key_id: '<your access key>',
  secret_access_key: '<your secret key>',
})
```

## Installation

Add the gems to your `Gemfile:`

```ruby
gem 'delayed_job'
gem 'delayed_job_sqs'
```

Optionally: Add an initializer (`config/initializers/delayed_job.rb`):

```ruby
Delayed::Worker.configure do |config|
  # optional params:
  config.aws_config = '~/stuff/things/aws.yml' # Specify the file location of the AWS configuration YAML if you're not using Rails and you want to use a YAML file instead of calling AWS.config
  config.default_queue_name = 'default' # Specify an alternative default queue name
  config.delay_seconds = # Sets the default delay in seconds for messages sent to the queue.
  config.message_retention_period = 345600 # The number of seconds Amazon SQS retains a message. Must be an integer from 3600 (1 hour) to 1209600 (14 days). The default for this attribute is 345600 (4 days).
  config.visibility_timeout = 30 # The length of time (in seconds) that a message received from a queue will be invisible to other receiving components when they ask to receive messages. Valid values: integers from 0 to 43200 (12 hours).
  config.wait_time_seconds = # How many seconds to wait for a response
end
```

## Usage

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).

Example:

```ruby
class User
  def background_stuff
    puts "I run in the background"
  end
end
```

Then in one of your controllers:

```ruby
user = User.new
user.delay.background_stuff
```

## Start worker process

    rake jobs:work

If you want to process a specific queue that's not in your initializer or called `default`, use the `QUEUE` or `QUEUES` environment variable:

    QUEUE=tracking rake jobs:work

That will start pulling jobs off the default queue and processing them. The gem will also handle multiple named queues if you have configured `rake` or `scripts/delayed_job` accordingly however be sure to name the queue when putting objects on the queue:

```ruby
user = User.new
user.delay(queue: 'bestest_queue').background_stuff
```

