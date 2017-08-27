Nitesite::Application.routes.draw do

  get 'cabs/list'


  get 'food/list'
  resources :food

  post 'groups/admin_add'
  post 'groups/admin_remove'
  get 'groups/list'
  resources :groups

  get "home/index"

  get 'me/test'

  match "navigator/", :to => "navigator#index"
  get "navigator/index"

  get 'notifications/list'
  post 'notifications/check'
  resources :notifications

  post 'parties/attend'
  get 'parties/change_attendance'
  get 'parties/list'
  get 'parties/overview'
  resources :parties

  post 'places/attend'
  get 'place/change_attendance'
  get 'places/list'
  get 'places/overview'
  resources :places

  get 'requests/list'
  post 'requests/accept'
  resources :requests

  match "signup/", :to => "users#new"

  resources :schools

  get 'search/list'
  get 'search/search_groups'
  get 'search/search_places'
  get 'search/search_services'
  get 'search/search_users'
  resources :search

  get "settings/index"

  get 'services/list'
  resources :services

  post 'shouts/create'
  get 'shouts/list'
  get 'shouts/show'
  post 'shouts/destroy'
  post 'shouts/like'
  post 'shouts/unlike'
  resources :shouts

  get 'users/activate'
  get 'users/feed'
  post 'users/follow'
  get 'users/followed_users'
  get 'users/followers'
  post 'users/unfollow'
  resources :users


  match "signin/", :to => "signin#index"
  get "signin/index"
  post "signin/index"
  
  match "signout/", :to => "signout#index"
  get "signout/index"
  
  match "signup/", :to => "signup#index"
  get "signup/index"
  
  get 'welcome/index'

  match ':controller(/:id(/:action(.:format)))'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
