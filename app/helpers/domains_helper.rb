require 'resolv'

module DomainsHelper
  # From http://stackoverflow.com/questions/18513199/rails-3-delayed-job-typeerror-cant-dump-anonymous-module
  class IpLookup < Struct.new(:domain_id, :hostname)
    # probably have to move this to a helper
    def perform
      begin
        ip_address = Resolv.getaddress @hostname
      rescue Resolv::ResolvError
        ip_address = 'invalid'
      end
      Domain.update @domain_id, ip_address: ip_address
    end
  end
end
