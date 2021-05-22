require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'validations' do
    subject { described_class.new(loan: Loan.new(funded_amount: 100)) }

    context 'amount attribute' do
      it 'nil amount validation does not raise an exception' do
        expect {
          subject.valid?
        }.not_to raise_exception
      end

      xit 'nil loan validation does not raise an exception' do
        # TODO: Rails runs our custom validation before `validates` validations.
        #   This makes it awkward if amount or loan are nil (which is invalid) because it
        #   raises NoMethodError in those cases, which obscure the truth. Standardize our
        #   testing of that here or make the class more resilient (which could be crufty.)
      end

      it 'treats a zero amount as invalid' do
        subject.amount = 0
        expect(subject.valid?).to eq(false)
        expect(subject.errors[:amount]).to include("must be greater than 0")
      end

      it 'treats an overpayment as invalid' do
        subject.amount = subject.loan.outstanding_balance + 1
        expect(subject.valid?).to eq(false)
        expect(subject.errors[:amount]).to include("cannot exceed loan's outstanding balance")
      end
    end
  end
end
