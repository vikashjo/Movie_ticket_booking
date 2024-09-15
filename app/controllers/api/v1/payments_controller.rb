class Api::V1::PaymentsController < ApplicationController
  def create
    begin
      ticket = Ticket.find(params[:ticket_id])
      amount = ticket.price

      payment_intent = Stripe::PaymentIntent.create({
        amount: amount * 100,
        currency: 'inr',
        metadata: { ticket_id: ticket.id },
        automatic_payment_methods: {
          enabled: true,
          allow_redirects: 'never' # Ensure that no redirect-based methods are allowed
        }
      })
      render json: { client_secret: payment_intent.client_secret }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def collect_payment_info
    begin
      # payment_method = Stripe::PaymentMethod.create({
      #   type: 'card',
      #   card: {
      #     number: params[:card_number],
      #     exp_month: params[:exp_month],
      #     exp_year: params[:exp_year],
      #     cvc: params[:cvc],
      #   },
      # })

       # Step 2: Retrieve the existing PaymentIntent (you might have created this earlier)
       payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent_id])

       # Step 3: Confirm the PaymentIntent using the payment method
      payment_intent.confirm({
        payment_method: params[:payment_method_token],
      })

      # Step 4: Check the status of the PaymentIntent and return appropriate response
      if payment_intent.status == 'succeeded'
        render json: { message: 'Payment successful!', payment_intent: payment_intent }, status: :ok
      elsif payment_intent.status == 'requires_action'
        render json: { message: 'Payment requires further action', payment_intent: payment_intent }, status: :ok
      else
        render json: { message: 'Payment failed', payment_intent: payment_intent }, status: :unprocessable_entity
      end
    
    rescue Stripe::CardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end