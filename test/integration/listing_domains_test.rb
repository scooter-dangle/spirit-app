require 'test_helper'

class ListingDomainsClass < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Fred' }
  test 'returns domains list' do
    @account.domains.create ip_address: 'n/a', hostname: 'theonion.com'
    get '/domains'

    assert response.success?
    refute_empty response.body
    assert(json(response.body).one? {|domain| domain[:hostname] == 'theonion.com' })
    assert(json(response.body).any? {|domain| domain[:account_id] == @account.id  })
  end
end
