module Resque
  # The time stat subsystem.  Tracks stats based on day, hour, minute, or second
  module TimeStat
    extend self
    extend Helpers

    EXPIRATIONS = {
      :minute => 60 * 60, # minute stats expire after an hour
      :hour => 60 * 60 * 24, # hour stats expire after a day
      :day => 60 * 60 * 24 * 30 # day stats expire after a month
    }

    # Get all of the dates for a stat
    def get(stat, time_unit)
      keys = timestamp_range(time_unit).map{ |ts| "stat:#{timestamped_stat(stat, time_unit, ts)}" }
      values = redis.mget(*keys) || []

      results = {}
      keys.compact.each_with_index do |key, i|
        results[key.sub(/^stat:#{stat}-#{time_unit}-/, '')] = values[i].to_i
      end

      results
    end

    # Alias of 'get'
    def [](stat)
      get(stat)
    end

    # Increments the stat, bucketing based on the timestamp.
    #
    # Valid time_unit values are :day, :hour, :minute, and :second. Can
    # optionally accept a third int parameter.  The stat is then incremented
    # by that much
    def incr(stat, time_unit, by = 1)
      timestamped_key = "stat:#{timestamped_stat(stat, time_unit)}"
      redis.incrby(timestamped_key, by)

      # expire will work correctly in >= 2.1.3
      # redis.expire(timestamped_key, EXPIRATIONS[time_unit.to_sym]) if EXPIRATIONS[time_unit.to_sym]

      timestamped_key
    end

    # Increments the stat, bucketing based on day, hour, and minute
    def incr_all(stat, by = 1)
      [:day, :hour, :minute].each do |time_unit|
        incr(stat, time_unit, by)
      end
    end

    # Increments stat by one, bucketing based on the timestamp.
    def <<(stat, time_unit)
      incr stat, time_unit
    end

    # For a string stat name, decrements the stat by one, bucketing based on the timestamp.
    #
    # Valid time_unit values are :day, :hour, :minute, and :second. Can
    # optionally accept a third int parameter.  The stat is then decremented
    # by that much
    def decr(stat, time_unit, by = 1)
      timestamped_key = "stat:#{timestamped_stat(stat, time_unit)}"
      redis.decrby(timestamped_key, by)

      # expire will work correctly in >= 2.1.3
      # redis.expire(timestamped_key, EXPIRATIONS[time_unit.to_sym]) if EXPIRATIONS[time_unit.to_sym]

      timestamped_key
    end

    # Decrements stat by one, bucketing based on the timestamp.
    def >>(stat, time_unit)
      decr stat, time_unit
    end

    # Clears all timestamps for the stat.
    def clear(stat)
      redis.keys("stat:#{stat}-*").each { |key| redis.del(key) }
    end

    protected

    def now
      @now || Time.now
    end

    def now=(time)
      @now = time
    end

    def timestamp(time_unit)
      timestamp = now.utc
      case time_unit.to_s
        when 'day' then timestamp - (timestamp.hour * 60 * 60) - (timestamp.min * 60) - timestamp.sec
        when 'hour' then timestamp - (timestamp.min * 60) - timestamp.sec
        when 'minute' then timestamp - timestamp.sec
        else timestamp
      end
    end

    def timestamp_range(time_unit)
      now_timestamp = timestamp(time_unit)

      timestamps = [now_timestamp]
      case time_unit.to_s
        when 'day' then
          (1..29).to_a.each { |i| timestamps.push now_timestamp - (i * 60 * 60 * 24) }
        when 'hour' then
          (1..23).to_a.each { |i| timestamps.push now_timestamp - (i * 60 * 60) }
        when 'minute' then
          (1..59).to_a.each { |i| timestamps.push now_timestamp - (i * 60) }
      end

      timestamps
    end

    def timestamped_stat(stat, time_unit, time=nil)
      "#{stat}-#{time_unit}-#{(time || timestamp(time_unit)).strftime('%Y-%m-%d_%H:%M:%S')}"
    end

  end
end
