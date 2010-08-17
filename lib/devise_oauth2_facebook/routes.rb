ActionDispatch::Routing::Mapper.class_eval do

    protected

    def devise_facebook_consumer(mapping, controllers)
      scope mapping.fullpath do
        get mapping.path_names[:fb_auth], :to => "#{controllers[:facebook_consumer]}#auth", :as => :fb_auth
        get mapping.path_names[:fb_callback], :to => "#{controllers[:facebook_consumer]}#callback", :as => :fb_callback
      end
    end
end