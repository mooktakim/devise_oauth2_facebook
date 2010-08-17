class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2Facebook::FacebookConsumerHelper
  
  def auth
    url = send("#{resource_name}_fb_callback_url".to_sym)
    redirect_to facebook_client.authorization.authorize_url(:redirect_uri => url , :scope => Devise.facebook_permissions)
  end
  
  def callback
    # if resource_class.respond_to?(:serialize_into_cookie)
    #   User.first.remember_me!
    #   cookies.signed["remember_#{resource_name}_token"] = {
    #     :value => User.first.class.serialize_into_cookie(User.first),
    #     :expires => User.first.remember_expires_at,
    #     :path => "/"
    #   }
    # end
    # sign_in_and_redirect(resource_name, User.first)
    # set_flash_message :notice, :signed_in
    # return
    url = send("#{resource_name}_fb_callback_url".to_sym)
    
    client = facebook_client
    client.authorization.process_callback(params[:code], :redirect_uri => url)

    token = client.access_token
    fb_user = client.selection.me.info!

    # Rails.logger.info "FB USER:"
    # Rails.logger.info fb_user.inspect

    resource = resource_class.find_with_facebook_user(fb_user, token)
    unless resource
      resource = resource_class.create_with_facebook_user(fb_user, token)
    end
    if resource_class.respond_to?(:serialize_into_cookie)
      resource.remember_me!
      cookies.signed["remember_#{resource_name}_token"] = {
        :value => resource.class.serialize_into_cookie(resource),
        :expires => resource.remember_expires_at,
        :path => "/"
      }
    end
    set_flash_message :notice, :signed_in
    sign_in_and_redirect(resource_name, resource)
  end

end