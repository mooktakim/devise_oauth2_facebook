class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  
  def auth
    url = send("fb_#{resource_name}_callback_url".to_sym)
    redirect_to client.authorization.authorize_url(:redirect_uri => url , :scope => Devise.facebook_permissions)
  end

  def callback
    Rails.logger.debug "FART"
    url = send("fb_#{resource_name}_callback_url".to_sym)
    access_token = client.authorization.process_callback(params[:code], :redirect_uri => url)
    # access_tken.token
    raise client(access_token).selection.me.home.info!.inspect

    # if resource.errors.empty?
    #   set_flash_message :notice, :send_instructions
    #   redirect_to new_session_path(resource_name)
    # else
    #   render_with_scope :new
    # end
  end
  
  private
  
  def client(token = nil)
    if token.present?
      client = FBGraph::Client.new(:client_id => Devise.facebook_api_key, :secret_id => Devise.facebook_api_secret)
    else
      client = FBGraph::Client.new(:client_id => Devise.facebook_api_key, :secret_id => Devise.facebook_api_secret, :token => token)
    end
  end

end