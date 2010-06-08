class FacebookOauth2Controller < ApplicationController
  include Devise::Controllers::InternalHelpers
  
  def authorise
    redirect_to client.authorization.authorize_url(:redirect_uri => facebook_oauth2_callback_url , :scope => 'email,user_photos,friends_photos')
  end

  # POST /resource/confirmation
  def create
    access_token = client.authorization.process_callback(params[:code], :redirect_uri => facebook_oauth2_callback_url)
    # access_tken.token

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to new_session_path(resource_name)
    else
      render_with_scope :new
    end
  end
  
  private
  
  def client(token = nil)
    if token.present?
      client = FBGraph::Client.new(:client_id => 'client_id', :secret_id => 'secret_id')
    else
      client = FBGraph::Client.new(:client_id => 'client_id', :secret_id => 'secret_id', :token => token)
    else
  end

end