require 'test_helper.rb'

class DeletingAccountsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Jonas' }

  test 'deletes account' do
    delete "/accounts/#{@account.id}"
    assert_equal 204, response.status
  end
end
