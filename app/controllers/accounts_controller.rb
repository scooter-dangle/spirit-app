class AccountsController < ApplicationController
  def index
    accounts = Account.all
    render json: accounts, response: 200
  end
end
