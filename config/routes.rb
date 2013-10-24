LohasWorkCom::Application.routes.draw do
  root 'welcome#index'

  controller :users do
    get 'signup_success' => :signup_success
    get 'active/:active_code' => :active, as: :active
    get 'forgot' => :forgot
    post 'forgot' => :do_forgot, as: :do_forgot
    get 'forgot_success/:token' => :forgot_success, as: :forgot_success
    get  'reset/:reset_token' => :reset, as: :reset
    post 'reset/:reset_token' => :do_reset, as: :do_reset
    get 'reset_success' => :reset_success
    get 'personal_topics' => :topics
    get 'no_organizations' => :no_organizations
  end
  get 'signup' => 'users#new', as: 'signup'
  resources :users, only:[:new, :create]

  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'login' => 'sessions#new', as: 'login'
  resources :sessions, only: [:new, :create, :destroy]

  resources :tags, only: [:create]

  controller :organizations do
    get 'show_member' => :show_member
    post 'delete_member' => :delete_member
    post 'add_member' => :add_member
  end

  get '/organization_topics' => 'topics#index', as: :organization_topics
  get '/personal_topics_inbox' => 'topics#unarchived', as: :personal_topics_inbox

  controller :topics do
    post 'remove_tag' => :remove_tag, as: :topic_remove_tag
    post 'add_tag' => :add_tags, as: :topics_add_tags
    post 'filter_with_tag' => :filter_with_tag, as: :topics_filter_with_tag
    post 'archive' => :archive, as: :archive_topics
  end

  resources :topics, only: [:create, :show]

  resources :topic, only: [] do
    resources :discussions, only: [:create]
  end

  post "emails/recieve" => "email_recivers#email"
  resources :welcome, only: [] do
    collection do
      post 'add_early_adotpers' => :add_early_adotpers
      get 'index'
    end
  end

  match '/*other' => redirect('/'), via: [:get, :post, :patch, :delete]

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
