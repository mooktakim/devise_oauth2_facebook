# encoding: utf-8

ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

  def devise_oauth2_facebook(routes, mapping)    
    routes.with_options(:controller => 'facebook_oauth2', :name_prefix => nil) do |session|
      session.send(:"facebook_oauth2", 'facebook_oauth2', :action => 'authorise', :conditions => { :method => :get })
      session.send(:"facebook_oauth2_callback", 'facebook_oauth2/callback', :action => 'callback', :conditions => { :method => :get })
    end
  end
  
end