require 'resolv'

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
    domain = Domain.new domain_params.merge({ip_address: 'n/a'})
    if domain.save
      ip_lookup domain.id, hostname: domain_params[:hostname]
      head 201, location: domain
    else
      render json: domain.errors, status: 422
    end
  end

  def update
    domain = Domain.find params[:id]
    full_params = domain_params
    full_params.merge!({ip_address: 'n/a'}) unless domain.hostname == full_params[:hostname]
    if domain.update full_params
      if full_params[:ip_address] == 'n/a'
        ip_lookup domain.id, hostname: (domain_params[:hostname] || domain.hostname)
      end
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
    params.require(:domain).permit :account_id, :hostname
  end

  def ip_lookup domain_id, hostname
    begin
      ip_address = Resolv.getaddress hostname
    rescue Resolv::ResolvError
      ip_address = 'invalid'
    end
    Domain.update domain_id, ip_address: ip_address
  end
  handle_asynchronously :ip_lookup
end

