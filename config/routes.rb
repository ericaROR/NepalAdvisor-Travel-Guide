Rails.application.routes.draw do
  resources :advertisements

  resources :likes

  #devise_for :admin_users, ActiveAdmin::Devise.config
 ActiveAdmin.routes(self)
 devise_for :users 
  
  resources :reviews

  resources :contacts

  resources :things_to_dos

  resources :restaurants

  resources :destinations
  # get 'password_resets/new'
  # get 'sessions/new'
  resources :password_resets
 
  #resources :sessions

   resources :users

  resources :categories

  resources :items

  resources :descriptions

  resources :images

    get "sign_up" => "users#new", :as => "sign_up"
    post "sessions_create" => "sessions#create"
   
     # match "log_in" => "sessions#new", :as => "log_in" , :via => [:get, :post]
     # match "logout" => "sessions#destroy", :as => "logout" , :via => [:get, :post]
    get "trekking" => "categories#trekking"
    get "tourism" => "categories#tourisum"
    get "culture" => "categories#culture"
    get "business" => "categories#business"
    get "legal" => "categories#legal"
    get "visa" => "categories#visa"
    get "profile" => "users#profile", :as => "profile"
    get 'cms/:slug', :controller => "contacts", :action => "cms", :as => 'cms'
   
    # get "help_center" => "contacts#help_center", :as => "help_center", :via => [:get, :post]
    # get "terms_of_use" => "contacts#terms_of_use", :as => "terms_of_use", :via => [:get, :post]
    ## Search Route
  post '/search' => 'items#search'
  get '/seed' => 'items#seed'
 
  get 'details/:slug', :controller => "categories", :action => "list_items", :as =>'list_items_show'
  
  root :to => 'home#index'

  resource :user, only: [:edit] do
  collection do
    patch 'update_password'

  end
end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
