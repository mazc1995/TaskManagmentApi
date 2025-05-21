module AuthHelper
  def auth_headers(user)
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
    { 'HTTP_AUTHORIZATION' => credentials }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end 