require "devise_oauth2_facebook/routes"

module DeviseOauth2Facebook
  class Engine < ::Rails::Engine
    config.devise_oauth2_facebook = DeviseOauth2Facebook
  end
end
