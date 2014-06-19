class AccountsController < ApplicationController
  def index
    accounts = Account.all
    if (name = params[:name])
      accounts = accounts.where name: name
    end
    render json: accounts, response: 200
  end

  def show
    account = Account.find params[:id]
    render json: account, response: 200
  end

  def create
    account = Account.new account_params
    if account.save
      head 201, location: account
    else
      render json: account.errors, status: 422
    end
  end

  private
  def account_params
    params.require(:account).permit :name
  end
end
