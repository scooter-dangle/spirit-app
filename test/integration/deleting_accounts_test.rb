require 'test_helper.rb'

class DeletingAccountsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Jonas' }

  test 'deletes account' do
    delete "/accounts/#{@account.id}"
    assert_equal 204, response.status
  end

  test 'domains owned by account are deleted with account' do
    domain = @account.domains.create hostname: 'theonion.com', ip_address: 'n/a'
    domain_id = domain.id
    # delete "/accounts/#{@account.id}"
    @account.destroy

    assert_raise ActiveRecord::RecordNotFound do
      get "/domains/#{domain_id}"
    end
    # NOTE - Not sure why the following isn't working and why I
    # have to test that the error was raised instead of 404
    # assert_equal 404, response.status
  end
end
