class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include DeviseOauth2CanvasFacebook::FacebookConsumerHelper
  
  def auth
    if !!params[:permission]
      scope =  Devise.facebook_permissions + ",#{params[:permission]}"
    else
      scope = Devise.facebook_permissions
    end
    url = send("#{resource_name}_fb_callback_url".to_sym)
    if params[:permission] && params[:go_back]
      url = url + "?permission=#{params[:permission]}&go_back=#{params[:go_back]}&abs_url=#{params[:abs_url]}"
    elsif params[:permission]
       url = url + "?permission=#{params[:permission]}"
    elsif params[:go_back]
       url = url + "?go_back=#{params[:go_back]}"
    end
    
    if params[:go_back] && params[:abs_url]
      url = url + "&abs_url=#{params[:abs_url]}"
    end
    
    uri = facebook_client.authorization.authorize_url(:redirect_uri => url, :scope => scope)
    if Devise.facebook_canvas_app
      render :layout => false, :inline => "<script type='text/javascript' charset='utf-8'>top.location.href='#{uri}';</script>"
    else
      redirect_to uri
    end
  end
  
  def callback
    url = send("#{resource_name}_fb_callback_url".to_sym)
    if params[:permission] && params[:go_back]
      url = url + "?permission=#{params[:permission]}&go_back=#{CGI::escape(params[:go_back])}"
    elsif params[:permission]
      url = url + "?permission=#{params[:permission]}"
    elsif params[:go_back]
      url = url + "?go_back=#{CGI::escape(params[:go_back])}"
    end
    
    if params[:go_back] && params[:abs_url]
      url = url + "&abs_url=#{params[:abs_url]}"
    end
      
    client = facebook_client
    client.authorization.process_callback(params[:code], :redirect_uri => url)
    
    token = client.access_token
    
    fb_user = client.selection.me.info!
    
    if !!params[:permission]
      permissions = Devise.facebook_permissions + ",#{params[:permission]}"
    else
      permissions = Devise.facebook_permissions
    end
      
    options = {:permissions => permissions}
    
    resource = resource_class.find_with_facebook_user(fb_user, token, client, options)
    unless resource
      resource = resource_class.create_with_facebook_user(fb_user, token, client, options)
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
      if params[:go_back] && !!params[:abs_url] && params[:abs_url] != "0"
        if params[:abs_url] == "1"
          redirect_to params[:go_back]
        elsif !!params[:go_back].match(/\?/)
          redirect_to params[:go_back] + "&abs_url=#{params[:abs_url]}"
        else
          redirect_to params[:go_back] + "?abs_url=#{params[:abs_url]}"
        end
      elsif params[:go_back]
        redirect_to Devise.facebook_canvas_url + params[:go_back]
      else
        redirect_to Devise.facebook_canvas_url
      end
    else
      sign_in_and_redirect(resource_name, resource)
    end
  end

end