class PaymentsController < ActionController::API

  # TODO: Provide actionable, application-specific details in JSON payload for all errors
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {}, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: {}, status: :unprocessable_entity
  end

  # NOTE: Even just for a tech exercise, this JSON parse loop is gross. There must
  #   be a better way for JBuilder to do this. I couldn't get .json.jbuilder views
  #   to work correctly with ActionController::API.
  def index
    payment_list = loan.payments.all.map do |payment|
      JSON.parse(payment.to_builder.target!)
    end

    render json: payment_list
  end

  def show
    payment = loan.payments.find(params[:id])

    render json: payment.to_builder.target!
  end

  def create
    loan.payments.create!(amount: params[:amount])

    render json: {}
  end

  private

  def loan
    @loan ||= Loan.find(params[:loan_id])
  end
end
