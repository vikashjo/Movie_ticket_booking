class ReminderEmailJob < ApplicationJob
  queue_as :default
  include Sidekiq::Job

  def perform(*args)
    today = Time.current.in_time_zone('Asia/Kolkata').to_date
    
    # Find all showtimes for today
    showtimes = Showtime.where(start_time: today.beginning_of_day..today.end_of_day)

    showtimes.each do |showtime|
      showtime.tickets.each do |ticket|
        UserMailer.booking_reminder(ticket.user, ticket).deliver_now
      end
    end
  end
end
