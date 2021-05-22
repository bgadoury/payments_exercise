class LoansController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {}, status: :not_found
  end

  # NOTE: Even just for a tech exercise, this JSON parse loop is gross. There must
  #   be a better way for JBuilder to do this. I couldn't get .json.jbuilder views
  #   to work correctly with ActionController::API.
  def index
    loans = Loan.all.map do |loan|
      JSON.parse(loan.to_builder.target!)
    end

    render json: loans
  end

  def show
    loan = Loan.find(params[:id])

    render json: loan.to_builder.target!
  end
end
