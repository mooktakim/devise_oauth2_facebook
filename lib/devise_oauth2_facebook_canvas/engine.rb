require "devise_oauth2_facebook_canvas/routes"

module DeviseOauth2FacebookCanvas
  class Engine < ::Rails::Engine
    config.devise_oauth2_facebook_canvas = DeviseOauth2FacebookCanvas
    
    config.autoload_paths << File.expand_path(File.join(File.dirname(__FILE__), "..")) if config.respond_to? :autoload_paths
    
  end
end
