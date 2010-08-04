require "devise_oauth2_facebook/routes"

module DeviseOauth2Facebook
  class Engine < ::Rails::Engine
    config.devise_oauth2_facebook = DeviseOauth2Facebook
    
    config.autoload_paths << File.expand_path(File.join(File.dirname(__FILE__), ".."))
    
  end
end
