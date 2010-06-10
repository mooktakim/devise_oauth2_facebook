class Devise::FacebookConsumerController < ApplicationController
  include Devise::Controllers::InternalHelpers
  
  def auth
    url = send("fb_#{resource_name}_callback_url".to_sym)
    redirect_to Devise.fb_client.authorization.authorize_url(:redirect_uri => url , :scope => Devise.facebook_permissions)
  end

  def callback
    Rails.logger.debug "FART"
    url = send("fb_#{resource_name}_callback_url".to_sym)
    client = Devise.fb_client
    client.authorization.process_callback(params[:code], :redirect_uri => url)
    # access_tken.token
    Rails.logger.info "ACCESS TOKEN: #{client.access_token}"
    Rails.logger.info "HOME INSPECT:"
    Rails.logger.info client.selection.me.home.info!.inspect

    # if resource.errors.empty?
    #   set_flash_message :notice, :send_instructions
    #   redirect_to new_session_path(resource_name)
    # else
    #   render_with_scope :new
    # end
  end

end