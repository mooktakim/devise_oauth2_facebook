require 'fbgraph'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class DeviseOauth2Facebook < Authenticatable
      
      def authenticate!
        raise "FART"
        resource_class = mapping.to
        
        client = facebook_client
        client.authorization.process_callback(authentication_hash[:code], :redirect_uri => Devise.facebook_callback_url)

        token = client.access_token
        fb_user = client.selection.me.info!

        Rails.logger.info "FB USER:"
        Rails.logger.info fb_user.inspect

        resource = resource_class.find_with_facebook_user(fb_user, token)
        unless resource
          resource = resource_class.create_with_facebook_user(fb_user, token)
        end
        
        success!(resource)
      end

    private
    
      def facebook_client(token = nil)
        if token.present?
          FBGraph::Client.new(:client_id => Devise.facebook_api_key, :secret_id => Devise.facebook_api_secret)
        else
          FBGraph::Client.new(:client_id => Devise.facebook_api_key, :secret_id => Devise.facebook_api_secret, :token => token)
        end
      end
      
    end
  end
end

Warden::Strategies.add(:devise_oauth2_facebook, Devise::Strategies::DeviseOauth2Facebook)