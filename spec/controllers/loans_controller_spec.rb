require 'rails_helper'

# TODO: This could use some DRY-ing up and better organization
RSpec.describe LoansController, type: :controller do
  let(:expected_fields) { Set.new(%w[id funded_amount outstanding_balance]) }

  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context 'expected fields' do
      before do
        Loan.create!(funded_amount: 100)
        Loan.create!(funded_amount: 200.99)
        get :index
      end
      let(:loans) { JSON.parse response.parsed_body }

      it 'exposes expected field names in JSON for all loans' do
        expect(loans.size).to eq(2)
        loans.each do |loan|
          expect(loan.keys.to_set).to eq(expected_fields)
        end
      end

      it 'exposes correct outstanding_balance values' do
        balances = loans.map { |loan| loan['outstanding_balance'] }.to_set
        expect(balances).to eq(%w[100.0 200.99].to_set)
      end
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, params: { id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'expected fields' do
      it 'exposes expected field names in JSON for a single loan' do
        loan.payments.create!(amount: 1.00)
        loan.payments.create!(amount: 9.00)

        get :show, params: { id: loan.id }

        loan = JSON.parse response.parsed_body
        expect(loan.keys.to_set).to eq(expected_fields)
      end
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
