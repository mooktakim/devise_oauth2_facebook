require 'devise/strategies/base'

module Devise
  module Strategies
    class DeviseOauth2Facebook < Authenticatable
      include ::DeviseOauth2Facebook::FacebookConsumerHelper
      
      def authenticate!
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

      # TokenAuthenticatable request is valid for any controller and any verb.
      def valid_request?
        true
      end

      # Do not use remember_me behavir with token.
      def remember_me?
        true
      end

      # Try both scoped and non scoped keys.
      def params_auth_hash
        params[scope] || params
      end

      # Overwrite authentication keys to use token_authentication_key.
      def authentication_keys
        @authentication_keys ||= [mapping.to.token_authentication_key]
      end
    end
  end
end

Warden::Strategies.add(:devise_oauth2_facebook, Devise::Strategies::DeviseOauth2Facebook)