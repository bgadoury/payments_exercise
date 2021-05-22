class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :loan, presence: true
  validates :amount, numericality: {greater_than: 0}

  validate :amount_cannot_exceed_outstanding_balance

  private

  def amount_cannot_exceed_outstanding_balance
    if amount.to_d > loan.outstanding_balance
      errors.add(:amount, "cannot exceed loan's outstanding balance")
    end
  end
end
