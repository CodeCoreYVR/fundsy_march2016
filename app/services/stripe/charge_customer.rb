class Stripe::ChargeCustomer

  include Virtus.model

  attribute :user,        User
  attribute :amount,      Integer
  attribute :description, String

  attribute :charge_id,   String

  def call
    begin
      charge     = Stripe::Charge.create charge_details
      @charge_id = charge.id
    rescue => e
      false
    end
  end

  private

  def charge_details
    {
      amount:      amount,
      currency:    "cad",
      customer:    user.stripe_customer_id,
      description: description
    }
  end

end
