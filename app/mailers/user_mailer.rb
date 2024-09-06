class UserMailer < ApplicationMailer
  default from: 'notifications@lingoamo.ai'

  def booking_confirmation(user, ticket)
    @user = user
    @ticket = ticket
    mail(to: @user.email,
         subject: 'Booking Confirmation'
        )
  end

  def booking_reminder(user, ticket)
    @user = user
    @ticket = ticket
    mail(to: @user.email, 
          subject: 'Booking Reminder'
        )
  end
end
