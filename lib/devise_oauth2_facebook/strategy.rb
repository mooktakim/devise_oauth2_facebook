# encoding: utf-8
require 'devise/strategies/base'

module Devise #:nodoc:
  module DeviseOauth2Facebook #:nodoc:
    module Strategies #:nodoc:

      # Default strategy for signing in a user using Facebook OAuth2.
      # Redirects to sign_in page if it's not authenticated
      #
      class DeviseOauth2Facebook < ::Devise::Strategies::Base

        def valid?
          mapping.to.respond_to?('authenticate_devise_oauth2_facebook')
        end

        # Authenticate user with Facebook Connect.
        #
        def authenticate!
          begin
            if resource = mapping.to.authenticate(params[scope])
              success!(resource)
            else
              fail(:invalid)
            end
          # NOTE: Facebooker::Session::SessionExpired errors handled in the controller.
          rescue => e
            fail!(e.message)
          end
        end

      end
    end
  end
end

Warden::Strategies.add(:devise_oauth2_facebook, Devise::DeviseOauth2Facebook::Strategies::DeviseOauth2Facebook)
