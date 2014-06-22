require 'test_helper.rb'
# For testing ip lookup
require 'resolv'

Delayed::Worker.delay_jobs = false

class CreatingDomainsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Fred' }
  test 'create new domain' do
    hostname = 'theonion.com'
    post '/domains',
      { domain: { account_id: @account.id, hostname: hostname } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    domain = Domain.find_by hostname: hostname
    assert_equal 204, response.status
    assert_equal domain_url(domain.id), reponse.location

    # NOTE - The following test no longer applies since we're now
    # only returning a header after a successful POST
    # domain = json response.body
    # assert_equal domain_url(domain[:id]), response.location
  end

  test 'create new domain with correct ip address' do
    # See configuration above for Delayed::Worker...
    # This test will *not* behave asynchronously.
    hostname = 'example.com'
    post '/domains',
      { domain: { account_id: @account.id, hostname: hostname } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    domain = Domain.find_by hostname: hostname

    begin
      ip_address = Resolv.getaddress hostname
    rescue Resolv::ResolvError
      ip_address = 'invalid'
    end

    assert_equal domain.ip_address, ip_address
  end

  test 'create new domain with invalid ip address' do
    # See configuration above for Delayed::Worker...
    # This test will *not* behave asynchronously.
    hostname = 'not_a_real_hostname'
    post '/domains',
      { domain: { account_id: @account.id, hostname: hostname } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    domain = Domain.find_by hostname: hostname

    assert_equal domain.ip_address, 'invalid'
  end

  test 'do not create domains without hostnames' do
    post '/domains',
      { domain: { account_id: @account.id } }.to_json,
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
