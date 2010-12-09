module DeviseOauth2Facebook::FacebookConsumerHelper
  
  def facebook_client(token = nil)
    if token.present?
      FBGraph::Client.new(:client_id => Devise.facebook_api_key, :secret_id => Devise.facebook_api_secret, :token => token)
    else  
      FBGraph::Client.new(:client_id => Devise.facebook_api_key, :secret_id => Devise.facebook_api_secret)
    end
  end
  
end