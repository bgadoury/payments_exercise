class Loan < ActiveRecord::Base
  has_many :payments

  validates :funded_amount, numericality: {greater_than: 0}

  def outstanding_balance
    funded_amount - payments.sum(&:amount)
  end
end
