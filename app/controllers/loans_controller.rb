class LoansController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {}, status: :not_found
  end

  def index
    # NOTE: Even just for a tech exercise, this JSON parse loop is gross. There must
    #   be a better way for JBuilder to do this. I couldn't get .json.jbuilder views
    #   to work correctly with ActionController::API.
    loans = Loan.all.map { |loan| JSON.parse(loan.to_builder.target!) }
    render json: loans
  end

  def show
    loan = Loan.find(params[:id])
    render json: loan.to_builder.target!
  end
end
