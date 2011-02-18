require File.dirname(__FILE__) + '/test_helper'

class PublisherTest < Test::Unit::TestCase
  def setup
    Resque.redis.flushall
    @worker = Resque::Worker.new(:default)
    @worker.register_worker
    Resque.redis = Redis.new
    @redis = Resque.redis
  end

  def test_resque_plugin_lint
    assert_nothing_raised do
      Resque::Plugin.lint(Resque::Plugins::Publisher)
    end
  end

  def test_begin_job
    @messages = watch_redis_channel("publisher") do
      Resque.enqueue(DefaultJob, 'hello')
    end

    assert_equal(["enqueued"],
                 @messages.map{|m| JSON.parse(m)['event'] })

    @response = JSON.parse(@messages.first)

    assert_equal "default", @response['queue']
    assert_equal "enqueued", @response['event']
    assert_equal ["hello"], @response['args']

    perform_next_job(@worker)
  end

  def test_start_job
    @messages = watch_redis_channel("publisher") do
      Resque.enqueue(DefaultJob, 'hello')
      perform_next_job(@worker)
    end

    @response = JSON.parse(@messages[1])

    assert_equal "default", @response['queue']
    assert_equal "started", @response['event']
    assert_equal ["hello"], @response['args']
  end

  def test_finish_job
    @messages = watch_redis_channel("publisher") do
      Resque.enqueue(DefaultJob, 'hello')
      perform_next_job(@worker)
    end

    assert_equal(["enqueued", "started", "finished"],
                 @messages.map{|m| JSON.parse(m)['event'] })

    @response = JSON.parse(@messages[2])

    assert_equal "default",@response['queue']
    assert_equal "finished", @response['event']
    assert_equal ["hello"], @response['args']
  end

  def test_failed_job
    @messages = watch_redis_channel("publisher") do
      Resque.enqueue(FailJob, 'hello')
      perform_next_job(@worker)
    end

    assert_equal(["enqueued", "started", "failed"],
                 @messages.map{|m| JSON.parse(m)['event'] })

    @response = JSON.parse(@messages[2])

    assert_equal "default", @response['queue']
    assert_equal "failed", @response['event']
    assert_equal ["hello"], @response['args']
  end

end
