class ReviewReminderJob < ApplicationJob
  queue_as :default

  def perform(showtime)
    showtime.tickets.each do |ticket|
      UserMailer.review_reminder(ticket.user, showtime.movie).deliver_now
    end
  end
end
