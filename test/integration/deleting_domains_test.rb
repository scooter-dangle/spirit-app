require 'test_helper.rb'

class DeletingDomainsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Fred' }
  setup { @domain  = Domain.create!  account_id: @account.id, hostname: 'theonion.com' }

  test 'deletes domain' do
    delete "/domains/#{@domain.id}"
    assert_equal 204, response.status
  end
end
