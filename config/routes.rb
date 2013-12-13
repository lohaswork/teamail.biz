LohasWorkCom::Application.routes.draw do
  root 'home#index'

  controller :home do
    get 'home' => :index, as: :home
    get 'about-us' => :about_us, as: :about_us
    get 'faq' => :faq
    get 'agreement' => :agreement
    get 'help' => :help
  end

  controller :users do
    get 'signup-success' => :signup_success, as: :signup_success
    get 'active/:active_code' => :active, as: :active
    get 'forgot' => :forgot, as: :forgot
    post 'forgot' => :do_forgot, as: :do_forgot
    get 'forgot-success/:token' => :forgot_success, as: :forgot_success
    get  'reset/:reset_token' => :reset, as: :reset
    post 'reset/:reset_token' => :do_reset, as: :do_reset
    get 'reset-success' => :reset_success, as: :reset_success
    get 'personal-topics' => :topics, as: :personal_topics
    get 'personal-topics/page/:page' => :topics
    get 'no-organizations' => :no_organizations, as: :no_organizations
    post 'set-user-name' => :set_user_name, as: :set_user_name
  end
  get 'signup' => 'users#new', as: :signup
  resources :users, only:[:new, :create]

  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'login' => 'sessions#new', as: 'login'
  resources :sessions, only: [:new, :create, :destroy]

  resources :tags, only: [:create] do
    member do
      post 'hide' => :hide, as: :hide
    end
  end

  get 'file-download/:id' => "upload_files#download", as: :download
  delete 'files/delete' => "upload_files#delete"
  resources :upload_files, only: [:create, :destroy]

  controller :organizations do
    get 'show-member' => :show_member, as: :show_member
    post 'delete-member' => :delete_member, as: :delete_member
    post 'add-member' => :add_member, as: :add_member
  end

  get '/organization-topics' => 'topics#index', as: :organization_topics
  get '/organization-topics/page/:page' => 'topics#index'
  get '/personal-topics-inbox' => 'topics#unarchived', as: :personal_topics_inbox
  get '/personal-topics-inbox/page/:page' => 'topics#unarchived'

  controller :topics do
    post 'remove-tag' => :remove_tag, as: :topic_remove_tag
    post 'add-tag' => :add_tags, as: :topics_add_tags
    post 'filter-with-tags' => :filter_with_tags, as: :topics_filter_with_tags
    post 'filter-with-tags/page/:page' => :filter_with_tags
    post 'archive' => :archive, as: :archive_topics
    post 'archive/page/:page' => :archive
    get 'get-unread-number' => :get_unread_number_of_unarchived_topics, as: :get_unread_number
  end

  resources :topics, only: [:create, :show]

  resources :topic, only: [] do
    resources :discussions, only: [:create]
  end

  post "emails/receive" => "email_receivers#email"
  resources :welcome, only: [] do
    collection do
      post 'add-early-adotpers' => :add_early_adotpers, as: :add_early_adotpers
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
