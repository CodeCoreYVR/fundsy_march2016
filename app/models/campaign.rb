class Campaign < ActiveRecord::Base

  belongs_to :user
  has_many :pledges, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: {greater_than: 10}

  geocoded_by :address
  after_validation :geocode

  def upcased_title
    title.upcase
  end

end
