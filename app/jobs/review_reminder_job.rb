class ReviewReminderJob < ApplicationJob
  queue_as :default
  include Sidekiq::Job

  def perform(showtime)
    showtime.tickets.each do |ticket|
      UserMailer.review_reminder(ticket.user, showtime.movie).deliver_now
    end
  end
end
