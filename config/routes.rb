ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
    map.namespace :admin do |admin|
       # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
      admin.resources :users, :collection => {:cancel => :get}
      admin.resources :base
      admin.resources :posts, :collection => {:cancel => :get, :change_text_field => :post }, :member => {:version => :get} do |post|
       post.resources :comments, :member => {:accept => :post}
      end
      admin.resources :uploads
      admin.resources :categories, :collection => {:delete => :post, :cancel_new_form => :post}, :member => {:cancel_edit_form => :post}
      admin.post 'posts/:slug', :controller => 'post', :action => 'show'
    end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  
  map.resources :posts do |post|
    post.resources :comments, :collection => {:preview => :post}
  end

  map.resources :users, :collection => { :forgot_password => :get, :send_email => :post, :update_password => :put, :edit_password => :get}
  map.resources :tags
  map.resource :session
  
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy', :method => :delete
  map.admin 'admin', :controller => 'admin/base', :action => 'index'
  map.dashboard 'admin/dashboard', :controller => 'admin/base', :action => 'index'
  map.recent_comments 'recent_comments', :controller => 'admin/comments', :action => 'recent_comments'
  map.connect '', :controller => '/posts', :action => 'index'
  map.connect ':controller/:id/:action/'
  map.connect ':controller/:id/:action.:format'

  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  map.connect '/spellcheck', :controller => 'admin/users', :action => 'spellcheck'
  map.connect '/sitealizer/:action', :controller => 'sitealizer'
  map.post 'posts/:slug', :controller => 'post', :action => 'show'
  map.connect '/feed', :controller => 'posts', :action => 'feed'
end
