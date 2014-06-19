require 'test_helper.rb'

class UpdatingAccountsTest < ActionDispatch::IntegrationTest
  setup { @account = Account.create! name: 'Kosh' }

  test 'update success' do
    patch "/accounts/#{@account.id}",
      { account: { name: 'Kosh aka Raggedy Puppy' } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert response.success?
    assert_equal 'Kosh aka Raggedy Puppy', @account.reload.name
  end

  test 'update fail with empty name' do
    patch "/accounts/#{@account.id}",
      { account: { name: nil } }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end
end
