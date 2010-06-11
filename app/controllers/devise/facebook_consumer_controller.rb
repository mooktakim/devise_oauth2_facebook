class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2Facebook::FacebookConsumerHelper
  
  def auth
    url = send("fb_#{resource_name}_callback_url".to_sym)
    redirect_to facebook_client.authorization.authorize_url(:redirect_uri => url , :scope => Devise.facebook_permissions)
  end
  
  def callback
    # sign_in_and_redirect(resource_name, User.first)
    # set_flash_message :notice, :signed_in
    # return
    url = send("fb_#{resource_name}_callback_url".to_sym)
    
    client = facebook_client
    client.authorization.process_callback(params[:code], :redirect_uri => url)

    token = client.access_token
    fb_user = client.selection.me.info!

    Rails.logger.info "FB USER:"
    Rails.logger.info fb_user.inspect

    resource = resource_class.find_with_facebook_user(fb_user, token)
    unless resource
      resource = resource_class.create_with_facebook_user(fb_user, token)
    end
    set_flash_message :notice, :signed_in
    sign_in_and_redirect(resource_name, resource)
  end

  def callback_2
    Devise.facebook_callback_url = send("fb_#{resource_name}_callback_url".to_sym)
    resource = warden.authenticate!(:scope => resource_name)
    set_flash_message :notice, :signed_in
    sign_in_and_redirect(resource_name, resource)
  end

end