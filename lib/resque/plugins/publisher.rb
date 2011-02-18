require 'json'
require 'resque/time_stat'
require 'resque/plugins/stats_keeper'

module Resque
  module Plugins
    module Publisher
      extend Resque::Plugins::StatsKeeper

      def after_enqueue_publish(*args)
        Resque.redis.publish :publisher, { :event => :enqueued,
                                           :queue => @queue,
                                           :id => self.object_id,
                                           :args => args }.to_json
      end

      def before_perform_publish(*args)
        Resque.redis.publish :publisher, { :event => :started,
                                           :queue => @queue,
                                           :id => self.object_id,
                                           :args => args }.to_json
      end

      def after_perform_publish(*args)
        Resque.redis.publish :publisher, { :event => :finished,
                                           :queue => @queue,
                                           :id => self.object_id,
                                           :args => args }.to_json
      end

      def on_failure_publish(message, *args)
        Resque.redis.publish :publisher, { :event => :failed,
                                           :queue => @queue,
                                           :id => self.object_id,
                                           :message => message,
                                           :args => args }.to_json
      end
    end
  end
end
