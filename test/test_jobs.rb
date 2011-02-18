class DefaultJob
  extend Resque::Plugins::Publisher

  @queue = :default

  def self.perform(input)
  end
end

class FailJob
  extend Resque::Plugins::Publisher

  @queue = :default

  def self.perform(input)
    raise "I FAILED"
  end
end

