class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2Facebook::FacebookConsumerHelper
  
  def auth
    url = send("fb_#{resource_name}_callback_url".to_sym)
    redirect_to facebook_client.authorization.authorize_url(:redirect_uri => url , :scope => Devise.facebook_permissions)
  end

  def callback
    Devise.facebook_callback_url = send("fb_#{resource_name}_callback_url".to_sym)
    resource = warden.authenticate!(:scope => resource_name)
    set_flash_message :notice, :signed_in
    sign_in_and_redirect(resource_name, resource)
  end

end