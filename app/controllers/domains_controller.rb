class DomainsController < ApplicationController
  def index
    domains = Domain.all
    if (hostname = params[:hostname])
      domains = domains.where hostname: hostname
    end
    if (ip_address = params[:ip_address])
      domains = domains.where ip_address: ip_address
    end
    if (account_id = params[:account_id])
      domains = domains.where account_id: account_id
    end
    render json: domains, response: 200
  end

  def show
    domain = Domain.find params[:id]
    render json: domain, response: 200
  end

  def create
    domain = Domain.new domain_params
    if domain.save
      head 201, location: domain
    else
      render json: domain.errors, status: 422
    end
  end

  def update
    domain = Domain.find params[:id]
    if domain.update domain_params
      head 200
    else
      render json: domain.errors, status: 422
    end
  end

  def destroy
    domain = Domain.find params[:id]
    domain.destroy
    head 204
  end

  private
  def domain_params
    params.require(:domain).permit :domain_id, :hostname
  end
end

