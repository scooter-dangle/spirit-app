class Domain < ActiveRecord::Base
  validates :hostname,   presence: true, uniqueness: true
  validates :ip_address, presence: true
  belongs_to :account
  # There may be pitfalls to this belongs_to and validates presence...
  # Possibly see http://www.samuelmullen.com/2013/12/validating-presence-of-associations-and-foreign-keys-in-rails/
  validates :account_id, presence: true
end
