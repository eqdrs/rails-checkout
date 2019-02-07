class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role cpf])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[role cpf])
  end

  def post_to(url:, data:, headers: nil)
    headers ||= {
      'Content-Type': 'application/json',
      'token': Rails.configuration.customer_app['token']
    }

    Net::HTTP.post(url, data.to_json, headers)
  end
end
