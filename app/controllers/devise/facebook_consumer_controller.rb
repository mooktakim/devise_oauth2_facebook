class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2Facebook::FacebookConsumerHelper
  
  def auth
    url = send("#{resource_name}_fb_callback_url".to_sym)
    uri = facebook_client.authorization.authorize_url(:redirect_uri => url , :scope => Devise.facebook_permissions)
    if Devise.facebook_canvas_app
      render :layout => false, :inline => "<script type='text/javascript' charset='utf-8'>top.location.href='#{uri}';</script>"
    else
      redirect_to uri
    end
  end
  
  def callback
    url = send("#{resource_name}_fb_callback_url".to_sym)

    client = facebook_client
    client.authorization.process_callback(params[:code], :redirect_uri => url)

    token = client.access_token
    fb_user = client.selection.me.info!

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
    
    if Devise.facebook_canvas_app
      sign_in(resource_name, resource)
      redirect_to Devise.facebook_canvas_url
    else
      sign_in_and_redirect(resource_name, resource)
    end
  end

end