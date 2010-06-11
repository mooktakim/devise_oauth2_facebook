module Devise
  module Models

    module DeviseOauth2Facebook
      extend ActiveSupport::Concern

      def do_update_facebook_user(fb_user, token)
        # Rails.logger.info "id: #{fb_user.id.inspect}"
        # Rails.logger.info "email: #{fb_user.email.inspect}"
        # Rails.logger.info "name: #{fb_user.name.inspect}"
        self.send("#{self.class.facebook_uid_field}=".to_sym, fb_user.id)
        self.send("#{self.class.facebook_token_field}=".to_sym, token)
        self.email = fb_user.email.downcase
        update_facebook_user(fb_user)
        self.save_without_validation
      end
      
      def update_facebook_user(fb_user)
        # override me
      end

      def active?
        true
      end

      protected

      module ClassMethods
        Devise::Models.config(self, :facebook_uid_field, :facebook_token_field)

        def find_with_facebook_user(fb_user, token)
          # Rails.logger.info "TEST1: facebook_uid_field => fb_user.id, #{facebook_uid_field.inspect} => #{fb_user.id}"
          user = where(facebook_uid_field.to_sym => fb_user.id).first || where(:email => fb_user.email.downcase).first
          if user
            user.do_update_facebook_user(fb_user, token)
          end
          user
        end
        
        def create_with_facebook_user(fb_user, token)
          # Rails.logger.info "TEST2: facebook_uid_field => fb_user.id, #{facebook_uid_field.inspect} => #{fb_user.id}"
          user = new(facebook_uid_field.to_sym => fb_user.id)
          user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
          user.do_update_facebook_user(fb_user, token)
          user
        end
      end
      
    end
  end
end