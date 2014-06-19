require 'test_helper'

class ListingAccountsClass < ActionDispatch::IntegrationTest
  test 'returns accounts list' do
    Account.create! name: 'Whitney'
    get '/accounts'

    assert response.success?
    refute_empty response.body
    assert(json(response.body).one? {|account| account[:name] == 'Whitney' })
  end
end
