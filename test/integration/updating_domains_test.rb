require 'test_helper.rb'

class UpdatingDomainsTest < ActionDispatch::IntegrationTest
  setup { @domain = Domain.create! hostname: 'thefacebook.com' }

  test 'update success' do
    patch "/domains/#{@domain.id}",
      { domain: { hostname: 'facebook.com' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert response.success?
    assert_equal 'facebook.com', @domain.reload.hostname
  end

  test 'update fail with empty hostname' do
    patch "/domains/#{@domain.id}",
      { domain: { hostname: nil } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end
end
