require 'sidekiq'
class HelloNameJob
  include Sidekiq::Job

  def perform(*args)
    puts "VVVVV: Sidekiq job started"
  end
end
