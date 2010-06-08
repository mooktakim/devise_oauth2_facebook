# encoding: utf-8

require 'devise_oauth2_facebook' if defined?(Rails)
require 'devise'
require 'fbgraph'

module Devise
  mattr_accessor :facebook_uid_field
  @@facebook_uid_field = :facebook_uid

  mattr_accessor :facebook_token_field
  @@facebook_session_key_field = :facebook_token

  mattr_accessor :facebook_api_key
  @@facebook_session_key_field = nil

  mattr_accessor :facebook_api_secret
  @@facebook_session_key_field = nil

  mattr_accessor :facebook_auto_create_account
  @@facebook_auto_create_account = true
end

# Load core I18n locales: en
#
# I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[devise_facebook_connectable locales en.yml])

# Add +:devise_oauth2_facebook+ strategies to defaults.
#
Devise.add_module(:devise_oauth2_facebook,
  :strategy => true,
  :controller => :sessions,
  :model => 'devise_oauth2_facebook/model')
