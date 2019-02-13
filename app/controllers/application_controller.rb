class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    if current_user.sign_in_count == 1
      edit_passwords_path
    else
      root_path
    end
  end

  def verify_user
    current_user.admin?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role cpf])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[role cpf])
  end

  def post_to(endpoint:, data:, headers: nil)
    headers ||= {
      'Content-Type': 'application/json',
      'token': Rails.configuration.customer_app['token']
    }

    begin
      http.post(endpoint, data.to_json, headers)
    rescue StandardError
      return Net::HTTPResponse.new(1.0, 500, 'Internal Error')
    end
  end

  def http(target_address: nil, target_port: nil)
    target_address ||= Rails.configuration.customer_app['url_address']
    target_port ||= Rails.configuration.customer_app['url_port']
    Net::HTTP.new(target_address, target_port)
  end
end
