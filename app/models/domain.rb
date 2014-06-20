require 'resolv'

class Domain < ActiveRecord::Base
  validates :hostname,   presence: true, uniqueness: true
  validates :ip_address, presence: true
  belongs_to :account
  # There may be pitfalls to this belongs_to and validates presence...
  # Possibly see http://www.samuelmullen.com/2013/12/validating-presence-of-associations-and-foreign-keys-in-rails/
  validates :account_id, presence: true

  # From https://devcenter.heroku.com/articles/delayed-job
  def ip_lookup!
    begin
      ip_address = Resolv.getaddress self.hostname
    rescue Resolv::ResolvError
      # Don't like having to rescue  :(
      # Possibly use public_suffice to eliminate invalid domains
      # by just parsing before calling out to the DNS with Resolv
      ip_address = 'invalid'
    end
    self.ip_address = ip_address
    save
  end
end
