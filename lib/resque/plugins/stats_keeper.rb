module Resque
  module Plugins
    module StatsKeeper
      def after_enqueue_add_stats(*args)
        TimeStat.incr_all("#{@queue}-enqueued")
        TimeStat.incr_all("_all-enqueued")
      end

      def after_perform_add_stats(*args)
        TimeStat.incr_all("#{@queue}-complete")
        TimeStat.incr_all("_all-complete")
      end

      def on_failure_add_stats(message, *args)
        TimeStat.incr_all("#{@queue}-failed")
        TimeStat.incr_all("_all-failed")
      end
    end
  end
end
