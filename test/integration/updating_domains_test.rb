require 'test_helper.rb'
# For testing ip lookup
require 'resolv'

Delayed::Worker.delay_jobs = false

class UpdatingDomainsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Zucks' }
  setup { @domain  = @account.domains.create  hostname: 'thefacebook.com', ip_address: '0.0.3.3' }

  test 'update success' do
    patch "/domains/#{@domain.id}",
      { domain: { hostname: 'facebook.com' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 204, response.status
    assert_equal 'facebook.com', @domain.reload.hostname
  end

  test 'update with valid hostname updates ip_address' do
    # See configuration above for Delayed::Worker...
    # This test will *not* behave asynchronously.
    hostname = 'example.com'
    patch "/domains/#{@domain.id}",
      { domain: { hostname: hostname } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    domain = Domain.find_by hostname: hostname

    begin
      ip_address = Resolv.getaddress hostname
    rescue Resolv::ResolvError
      ip_address = 'invalid'
    end

    assert_equal domain.ip_address, ip_address
  end

  test 'update with invalid hostname updates ip_address to invalid' do
    # See configuration above for Delayed::Worker...
    # This test will *not* behave asynchronously.
    hostname = 'not_a_real_hostname'
    patch "/domains/#{@domain.id}",
      { domain: { hostname: hostname } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    domain = Domain.find_by hostname: hostname

    assert_equal domain.ip_address, 'invalid'
  end

  test 'update fail with empty hostname' do
    patch "/domains/#{@domain.id}",
      { domain: { hostname: nil } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end
end
