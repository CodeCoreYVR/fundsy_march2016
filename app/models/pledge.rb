class Pledge < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign, touch: true

  validates :amount, presence: true, numericality: {greater_than_or_equal_to: 1}
end
