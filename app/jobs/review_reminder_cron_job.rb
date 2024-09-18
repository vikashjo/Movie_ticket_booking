class ReviewReminderCronJob < ApplicationJob
  queue_as :default
  include Sidekiq::Job

  def perform
    # Find all showtimes that ended today
    showtimes = Showtime.where('end_time < ?', Time.current)
                        .where('end_time >= ?', Time.current.beginning_of_day)

    # Schedule review reminders for all showtimes
    showtimes.each do |showtime|
      ReviewReminderJob.set(wait_until: showtime.end_time + 1.hour).perform_later(showtime)
    end
  end
end