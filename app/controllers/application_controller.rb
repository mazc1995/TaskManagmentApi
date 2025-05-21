class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authenticate

  attr_reader :current_user

  private

  def authenticate
    authenticate_or_request_with_http_basic do |email, password|
      user = User.find_by(email: email)
      if user&.authenticate(password)
        @current_user = user
      end
    end
  end
end
