require 'test_helper.rb'

class DeletingAccountsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Jonas' }

  test 'deletes account' do
    delete "/accounts/#{@account.id}"
    assert_equal 204, response.status
  end

  test 'domains owned by account are deleted with account' do
    domain = Domain.create! account_id: @account.id, hostname: 'theonion.com'
    delete "/accounts/#{@account.id}"

    get "domains/#{domain.id}"
    assert_equal 404, response.status
  end
end
