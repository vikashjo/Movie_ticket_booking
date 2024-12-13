require 'sidekiq'
class HelloNameJob
  include Sidekiq::Job
  sidekiq_options queue: 'critical', retry: 2

  def perform_at(name, count)
    puts "Doing hard work #{name}, #{count} times"
  end
end
