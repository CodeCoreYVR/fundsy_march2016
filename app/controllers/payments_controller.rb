class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pledge

  def new
  end

  def create
    customer = Stripe::Customer.create(
                  description: "Customer for user id #{current_user.id}",
                  source: params[:stripe_token]
                )
    # save data from Stripe
    current_user.stripe_customer_id    = customer.id
    current_user.stripe_card_type      = customer.sources.data[0].brand
    current_user.stripe_card_last4     = customer.sources.data[0].last4
    current_user.stripe_card_exp_month = customer.sources.data[0].exp_month
    current_user.stripe_card_exp_year  = customer.sources.data[0].exp_year

    current_user.save

    charge = Stripe::Charge.create(
      amount: (@pledge.amount * 100).to_i,
      currency: "cad",
      customer: current_user.stripe_customer_id,
      description: "Charge for pledge id #{@pledge.id}"
    )

    @pledge.txn_id = charge.id
    @pledge.save

    redirect_to @pledge.campaign, notice: "Thanks for completing the payment"
  end

  private

  def find_pledge
    @pledge = Pledge.find params[:pledge_id]
  end
end
