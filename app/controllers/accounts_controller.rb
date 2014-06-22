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
      head 204, location: account
    else
      render json: account.errors, status: 422
    end
  end

  def update
    account = Account.find params[:id]
    if account.update account_params
      head 204
    else
      render json: account.errors, status: 422
    end
  end

  def destroy
    account = Account.find params[:id]
    account.destroy
    head 204
  end

  private
  def account_params
    params.require(:account).permit :name
  end
end
