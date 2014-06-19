require 'test_helper.rb'

class DeletingDomainsTest < ActionDispatch::IntegrationTest
  setup do
    @account = Account.create! name: 'Fred'
    @domain  = @account.domains.create hostname: 'theonion.com', ip_address: 'n/a'
  end

  test 'deletes domain' do
    delete "/domains/#{@domain.id}"
    assert_equal 204, response.status
  end
end
