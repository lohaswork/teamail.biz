LohasWorkCom::Application.routes.draw do
  root :to => 'early_adopters#index'

  controller :users do
    get '/signup-success'                        => :signup_success,              :as => :signup_success
    get '/active/:active_code'                   => :active,                      :as => :active
    get '/forgot'                                => :forgot,                      :as => :forgot
    post '/forgot'                               => :do_forgot,                   :as => :forgot
    get '/forgot_success/:token'                 => :forgot_success,              :as => :forgot_success
    get  '/reset/:reset_token'                   => :reset,                       :as => :reset
    post '/reset/:reset_token'                   => :do_reset,                    :as => :reset
    get '/reset_success'                         => :reset_success,               :as => :reset_success
    get '/topics'                                => :topics,                      :as => :topics
    get '/non_organ'                             => :non_organ,                   :as => :non_organ
  end
  get "signup" => "users#new", :as => "signup"
  resources :users, :only =>[:new, :create]

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  resources :sessions, :only => [:new, :create, :destroy]

  resources :organization, :only => [] do
    resources :topics, :only => [:index]
    resources :tags, :only => [:create]
  end

  controller :organization do
    get "show_member" => "organizations#show_member"
    post "downsize" => "organizations#downsize"
    post "add_member" => "organizations#add_member"
  end

  resources :tags, :only => [] do
    collection do
      post 'add'
    end
  end

  resources :topics, :only => [:create, :show] do
    collection do
      post 'remove_tag'
      post 'add_tag'
    end
  end

  resources :topic, :only => [] do
    resources :discussions, :only => [:create]
  end

  resources :early_adopters, :only => [:index, :create]
  match "/*other" => redirect('/')
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
