spec = Gem::Specification.new do |s|
  s.name              = 'resque-publisher'
  s.version           = '0.1.0'
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = 'A resque plugin that publishes resque events to redis pubsub'
  s.homepage          = 'http://github.com/mnutt/resque-publisher'
  s.authors           = ['Michael Nutt']
  s.email             = 'michael@nuttnet.net'
  s.has_rdoc          = false

  s.files             = %w(Rakefile README.md)
  s.files            += Dir.glob('{test/*,lib/**/*}')
  s.require_paths     = ['lib']

  s.add_dependency('resque', '>= 1.8.0')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('turn')

  s.description       = <<-EOL
  resque-publisher publishes resque worker events (enqueue, start, finish, fail) to redis pubsub.
  EOL
end
