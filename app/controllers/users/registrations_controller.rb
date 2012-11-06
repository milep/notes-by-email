class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.reset_authentication_token!
  end
end
