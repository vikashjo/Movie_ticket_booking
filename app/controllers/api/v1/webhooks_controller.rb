class Api::V1::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = nil
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, secret)
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: :bad_request
      return
    end

    # Handle the event
    case event['type']
    when 'payment_intent.succeeded'
      handle_successful_payment(event['data']['object'])
    when 'payment_intent.payment_failed'
      payment_intent = event['data']['object']
      handle_payment_failure(payment_intent)
    else
      # Other event types
      puts "Unhandled event type: #{event['type']}"
    end

    render json: { message: 'Success' }
  end

  private

  def handle_successful_payment(payment_intent)
    ticket_id = payment_intent.metadata['ticket_id']
    ticket = Ticket.find(ticket_id)
    ticket.update(status: 'booked') #add status TODO
    UserMailer.payment_receipt(ticket.user, ticket).deliver_later
  end

  def handle_payment_failure(payment_intent)
    # Find the ticket by payment_intent.id
    ticket = Ticket.find_by(payment_intent_id: payment_intent['id'])
    return unless ticket

    ticket.update!(status: 'failed')      #add status TODO
    UserMailer.payment_failed(ticket.user, ticket).deliver_later
  end
end
