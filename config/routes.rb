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
       admin.resources :users, :collection => { :forgot_password => :get, :send_email => :post, :update_password => :put, :edit_password => :get}
        admin.resources :base
        admin.resources :posts, :collection => {:cancel => :get}
        admin.resources :categories
     end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  
  map.resources :posts do |post|
    post.resources :comments, :member => {:accept => :post}
  end
  map.resources :users
  map.resources :tags
  map.resource :session
  map.connect '', :controller => 'posts', :action => 'index'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy', :method => :delete
  map.admin 'admin', :controller => 'admin/base', :action => 'index'
  map.dashboard 'admin/dashboard', :controller => 'admin/base', :action => 'index'
  map.connect ':controller/:id/:action/'
  map.connect ':controller/:id/:action.:format'
end
