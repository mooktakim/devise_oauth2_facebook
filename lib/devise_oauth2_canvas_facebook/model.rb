module Devise
  module Models

    module DeviseOauth2CanvasFacebook
      extend ActiveSupport::Concern

      def do_update_facebook_user(fb_user, token, client, options)
        self.send("#{self.class.facebook_uid_field}=".to_sym, fb_user.id)
        self.send("#{self.class.facebook_token_field}=".to_sym, token)
        self.email = fb_user.email.to_s.downcase if fb_user.email.present?
        update_facebook_user(fb_user, client, options)
        self.save(:validate => false)
      end
      
      def update_facebook_user(fb_user, client)
        # override me
      end

      def active?
        true
      end

      protected

      module ClassMethods
        Devise::Models.config(self, :facebook_uid_field, :facebook_token_field)

        def find_with_facebook_user(fb_user, token,client, options)
          user = where(facebook_uid_field.to_sym => fb_user.id).first
          if user
            user.do_update_facebook_user(fb_user, token, client,options)
          end
          user
        end
        
        def create_with_facebook_user(fb_user, token,client,  options)
          user = new(facebook_uid_field.to_sym => fb_user.id, :password => "fakepass", :password_confirmation => "fakepass")
          user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
          user.do_update_facebook_user(fb_user, token, client, options)
          user
        end
      end
      
    end
  end
end