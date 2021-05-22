class Loan < ActiveRecord::Base
  has_many :payments

  validates :funded_amount, numericality: {greater_than: 0}

  def outstanding_balance
    funded_amount - payments.sum(&:amount)
  end

  def to_builder
    Jbuilder.new do |loan|
      loan.(self, :id, :funded_amount, :outstanding_balance)
      # loan.payments self.payments, :amount
    end
  end
end
