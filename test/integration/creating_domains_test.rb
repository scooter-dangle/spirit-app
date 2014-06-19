require 'test_helper.rb'

class CreatingDomainsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Fred' }
  test 'create new domain' do
    post '/domains',
      { domain: { account_id: @account.id, hostname: 'theonion.com' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type

    # NOTE - The following test no longer applies since we're now
    # only returning a header after a successful POST
    # domain = json response.body
    # assert_equal domain_url(domain[:id]), response.location
  end

  test 'do not create domains without hostnames' do
    post '/domains',
      { domain: { account_id: @account.id, fake_param: '' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end


  test 'do not create domains with duplicate hostnames' do
    @account.domains.create hostname: 'theonion.com', ip_address: 'n/a'
    post '/domains',
      { domain: { account_id: @account.id, hostname: 'theonion.com' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end

  test 'do not create domains without an account' do
    post '/domains',
      { domain: { hostname: 'theonion.com', ip_address: 'n/a' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end
end
