class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    event = Stripe::Event.construct_from(JSON.parse(payload))

    case event.type
    when "payment_intent.succeeded"
      payment_intent = event.data.object
      order_id = payment_intent.metadata.order_id
      order = Order.find_by(id: order_id)
      if order
        order.update!(
          status: "paid",
          stripe_payment_id: payment_intent.id
        )
      end
    end

    render json: { received: true }
  end
end