class UserMailer < ApplicationMailer
  default from: 'notifications@lingoamo.ai'

  def booking_confirmation(user, ticket)
    @user = user
    @ticket = ticket
    mail(
      to: @user.email,
      subject: 'Booking Confirmation'
    )
  end

  def booking_reminder(user, ticket)
    @user = user
    @ticket = ticket
    mail(
      to: @user.email, 
      subject: 'Booking Reminder'
    )
  end

  def review_reminder(user, movie)
    @user = user
    @movie = movie
    mail(
      to: @user.email,
      subject: 'We hope you enjoyed the movie! Leave a review'
    )
  end
end
