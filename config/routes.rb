LohasWorkCom::Application.routes.draw do
  root :to => 'welcome#index'

  controller :users do
    get '/signup-success'                        => :signup_success,              :as => :signup_success
    get '/active/:active_code'                   => :active,                      :as => :active
    get '/forgot'                                => :forgot,                      :as => :forgot
    post '/forgot'                               => :do_forgot,                   :as => :forgot
    get '/forgot_success/:token'                 => :forgot_success,              :as => :forgot_success
    get  '/reset/:reset_token'                   => :reset,                       :as => :reset
    post '/reset/:reset_token'                   => :do_reset,                    :as => :reset
    get '/reset_success'                         => :reset_success,               :as => :reset_success
    get '/personal_topics'                       => :topics,                      :as => :personal_topics
    get '/no_organizations'                      => :no_organizations,            :as => :no_organizations
  end
  get "signup" => "users#new", :as => "signup"
  resources :users, :only =>[:new, :create]

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  resources :sessions, :only => [:new, :create, :destroy]

  resources :tags, :only => [:create]

  controller :organization do
    get "show_member" => "organizations#show_member"
    post "delete_member" => "organizations#delete_member"
    post "add_member" => "organizations#add_member"
  end

  get '/organization_topics' => 'topics#index', :as => :organization_topics
  get '/personal_topics_inbox' => 'topics#unarchived', :as => :personal_topics_inbox

  resources :topics, :only => [:create, :show] do
    collection do
      post 'remove_tag'
      post 'add_tag'
      post 'tag_filter'
      post 'archive'
    end
  end

  resources :topic, :only => [] do
    resources :discussions, :only => [:create]
  end

  resources :welcome, :only => [] do
    collection do
      post 'add_early_adotpers' => :add_early_adotpers
      get 'index'
    end
  end

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
