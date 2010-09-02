require "devise_oauth2_canvas_facebook/routes"

module DeviseOauth2CanvasFacebook
  class Engine < ::Rails::Engine
    config.devise_oauth2_canvas_facebook = DeviseOauth2CanvasFacebook
    
    config.autoload_paths << File.expand_path(File.join(File.dirname(__FILE__), "..")) if config.respond_to? :autoload_paths
    
  end
end
