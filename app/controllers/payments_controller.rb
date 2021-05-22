class PaymentsController < ActionController::API

  # TODO: Provide actionable, application-specific details in JSON payload for all errors
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {}, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: {}, status: :unprocessable_entity
  end

  def create
    loan = Loan.find(params[:loan_id])
    loan.payments.create!(amount: params[:amount])

    render json: {}
  end
end
