require 'test_helper.rb'

class CreatingAccountsTest < ActionDispatch::IntegrationTest
  test 'create new account' do
    post '/accounts',
      { account: { name: 'Whitney' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type

    account = json response.body
    assert_equal account_url(account[:id]), response.location
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
