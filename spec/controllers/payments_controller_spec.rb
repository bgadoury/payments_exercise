require 'rails_helper'

# TODO: This could use some DRY-ing up and better organization
RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 100) }

  describe '#index' do
    before do
      loan.payments.create!(amount: 10.99)
      loan.payments.create!(amount: 20.99)
    end

    it 'responds with a ok (200)' do
      get :index, params: { loan_id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    it 'exposes expected data for all payments on a loan' do
      get :index, params: { loan_id: loan.id }
      payments = JSON.parse response.parsed_body

      expected_payload = loan.payments.map do |payment|
        { 'id' => payment.id, 'amount' => payment.amount.to_s }
      end

      expect(payments).to match_array(expected_payload)
    end
  end

  describe '#show' do
    before do
      loan.payments.create!(amount: 10.99)
    end
    let(:created_payment) { loan.payments.last }

    it 'responds with a ok (200)' do
      get :show, params: { loan_id: loan.id, id: created_payment.id}
      expect(response).to have_http_status(:ok)
    end

    it 'exposes expected data for a single payment' do
      get :show, params: { loan_id: loan.id, id: created_payment.id }
      payment = JSON.parse response.parsed_body

      expected_hash = { 'id' => created_payment.id, 'amount' => created_payment.amount.to_s }
      expect(payment).to eq(expected_hash)
    end

    context 'incorrect payment ID' do
      it 'responds with a 404' do
        get :show, params: { loan_id: loan.id, id: -1 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'incorrect loan ID' do
      it 'responds with a 404' do
        get :show, params: { loan_id: -1, id: created_payment.id }
        expect(response).to have_http_status(:not_found)
      end
    end

  end

  describe '#create' do
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
