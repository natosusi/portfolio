class LoansController < ApplicationController
  def index
    @loans = Loan.all
  end

  def new
    @loan = Loan.new
  end

  def create 
    @loan = Loan.new(loan_params)
    @loan.save
    redirect_to loans_path
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end 

   private
    def loan_params
      params.require(:loan).permit(:user_id, :book_id, :borrowed_date, :schedule_date, :returned_date)
    end
end
