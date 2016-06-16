class Stripe::CreateCustomer

  include Virtus.model

  attribute :stripe_token, String
  attribute :user,         User

  def call
    create_stripe_customer && save_data_from_stripe
  end

  private

  def create_stripe_customer
    begin
      @customer = Stripe::Customer.create stripe_customer_details
    rescue => e
      # Notify admin with error: e.message / e.backtrace
      false
    end
  end

  def stripe_customer_details
    {description: description, source: stripe_token}
  end

  def description
    "Customer for user id #{user.id}"
  end

  def save_data_from_stripe
    user.stripe_customer_id    = @customer.id
    user.stripe_card_type      = @customer.sources.data[0].brand
    user.stripe_card_last4     = @customer.sources.data[0].last4
    user.stripe_card_exp_month = @customer.sources.data[0].exp_month
    user.stripe_card_exp_year  = @customer.sources.data[0].exp_year
    user.save
  end

end
