# encoding: utf-8

ActionDispatch::Routing::Mapper.class_eval do

    protected

    def devise_facebook_consumer(mapping, controllers)
      scope mapping.full_path do
        get mapping.path_names[:fb_auth], :to => "#{controllers[:facebook_consumer]}#auth", :as => :"fb_#{mapping.name}_auth"
        get mapping.path_names[:fb_callback], :to => "#{controllers[:facebook_consumer]}#callback", :as => :"fb_#{mapping.name}_callback"
      end
    end
end