require 'rails_helper'

RSpec.describe Loan, type: :model do

  describe '#outstanding_balance' do
    let(:funded_amount) { 100.0 }
    let(:outstanding_balance) { subject.outstanding_balance }
    subject { described_class.create!(funded_amount: funded_amount) }

    context 'no payments' do
      it 'equal to funded_amount' do
        expect(outstanding_balance).to eq(subject.funded_amount)
      end
    end

    context 'some payments' do
      it 'returns funded_amount minus sum of all payments' do
        subject.payments.create!(amount: 5)
        subject.payments.create!(amount: 10.25)
        expect(outstanding_balance).to eq(84.75)
      end
    end
  end
end
