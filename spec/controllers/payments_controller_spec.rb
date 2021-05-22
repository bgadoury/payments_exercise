require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#create' do
    let(:funded_amount) { 100.00 }
    let(:loan) { Loan.create!(funded_amount: funded_amount) }

    context 'invalid loan ID' do
      it 'responds with a not_found (404)' do
        post :create, params: { loan_id: -1, amount: 10.50 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'valid first payment' do
      it 'responds with a ok (200)' do
        post :create, params: { loan_id: loan.id, amount: 10.50 }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'valid second payment' do
      it 'responds with a ok (200)' do
        loan.payments.create!(amount: 5.00)
        post :create, params: { loan_id: loan.id, amount: 10.50 }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'invalid overpayment with a pre-existing valid payment' do
      it 'responds with a unprocessable_entity (422)' do
        loan.payments.create!(amount: 5.00)
        post :create, params: { loan_id: loan.id, amount: loan.outstanding_balance + 0.01 }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
