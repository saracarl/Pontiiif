Rails.application.routes.draw do
  resources :collections

  get   '/' => 'manifests#search'
  get   '/search' => 'manifests#search'
  get   '/searchresults' => 'manifests#searchresults'
  get   'advancedsearch' => 'manifests#advancedsearch'
  get   '/manifests/addcollection' => 'manifests#addcollection'
  get   '/collection/new'
  resources :manifests
  get   '/advanced_search' => 'manifests#advanced_search', :as => "advanced_search"
  get   '/list_logs' => 'log_files#list_logs', :as => "list_logs"
  get   '/log_files/:logfile', to: 'log_files#show', :as => "logfile"
  get   'addedcollection' => 'manifests#addedcollection'
  
  get   'api/v0.0/search/:query' => 'manifests#api_search', :as => "api_search"
 # get #'/patients/:id', to: 'patients#show', as: 'patient'

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
