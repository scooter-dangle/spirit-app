class Account < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :domains
end
