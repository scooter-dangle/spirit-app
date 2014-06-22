require 'test_helper.rb'

class CreatingAccountsTest < ActionDispatch::IntegrationTest
  test 'create new account' do
    name = 'Whitney'
    post '/accounts',
      { account: { name: name } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    account = Account.find_by name: name
    assert_equal 204, response.status
    assert_equal account_url(account.id), response.location

    # NOTE - The following test no longer applies since we're now
    # only returning a header after a successful POST
    # account = json response.body
    # assert_equal account_url(account[:id]), response.location
  end

  test 'do not create accounts without names' do
    post '/accounts',
      { account: { fake_param: '' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end


  test 'do not create accounts with duplicate names' do
    Account.create! name: 'Bobby'
    post '/accounts',
      { account: { name: 'Bobby' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end
end
