Rails.application.routes.draw do
  # Namespacing v1 is to future proof our API.
  # For example v2 could live on a different server and runs on Elixir instead of Ruby.
  namespace :v1 do
    # Public endpoints
    # These endpoints are meant for the public. No sensitive information is ever
    # made available here. Initially these endpoints will be consumed by our
    # public facing websites, but we anticipate and allow also third parties,
    # such as scrapers and bots, to read from them.
    #
    # Used by:
    # https://interflux.com
    # https://interflux.de
    # https://interflux.fr
    # https://interflux.es
    # https://interflux.group
    # https://lmpa-q.com
    #
    namespace :public do
      resources :article_categories, path: '/article-categories'
      resources :articles
      resources :client_side_renders, path: '/client-side-renders'
      resources :companies
      resources :company_markets, path: '/company-markets'
      resources :countries
      resources :document_categories, path: '/document-categories'
      resources :documents
      resources :events
      resources :event_attendees, path: '/event-attendees'
      resources :features
      resources :images
      resources :languages
      resources :leads
      resources :page_views, path: '/page-views'
      resources :permalinks
      resources :product_families, path: '/product-families'
      resources :product_qualities, path: '/product-qualities'
      resources :product_uses, path: '/product-uses'
      resources :products
      resources :qualities
      resources :server_side_renders, path: '/server-side-renders'
      resources :sessions
      resources :simulation_requests, path: '/simulation-requests'
      resources :translations
      resources :uses
      resources :webinar_attendees, path: '/webinar-attendees'
      resources :webinars

      # Non-CRUD requests
      post '/simulation-requests/image-upload-url', to: 'simulation_requests#create_upload_url'
    end

    # Admin endpoints
    # These endpoints are meant for internal use by authenticated users such as
    # Interflux employees. These endpoints commonly allow read, create, update
    # and destroy.
    #
    # Used by:
    # https://admin.interflux.com
    #
    namespace :admin do
      resources :article_categories, path: '/article-categories'
      resources :articles
      resources :cdn_files, path: '/cdn-files'
      resources :client_side_renders, path: '/client-side-renders'
      resources :companies
      resources :company_markets, path: '/company-markets'
      resources :company_members, path: '/company-members'
      resources :countries
      resources :document_categories, path: '/document-categories'
      resources :documents
      resources :events
      resources :event_attendees, path: '/event-attendees'
      resources :features
      resources :images
      resources :languages
      resources :leads
      resources :page_views, path: '/page-views'
      resources :people
      resources :permalinks
      resources :person_images, path: '/person-images'
      resources :product_documents, path: '/product-documents'
      resources :product_families, path: '/product-families'
      resources :product_features, path: '/product-features'
      resources :product_images, path: '/product-images'
      resources :product_qualities, path: '/product-qualities'
      resources :product_uses, path: '/product-uses'
      resources :product_videos, path: '/product-videos'
      resources :products, path: '/products'
      resources :qualities
      resources :server_side_renders, path: '/server-side-renders'
      resources :sessions
      resources :translations
      resources :use_images, path: '/use-images'
      resources :users
      resources :uses
      resources :videos
      resources :visits
      resources :webinar_attendees, path: '/webinar-attendees'
      resources :webinar_images, path: '/webinar-images'
      resources :webinar_invitees, path: '/webinar-invitees'
      resources :webinar_videos, path: '/webinar-videos'
      resources :webinars

      # Non-CRUD requests
      post '/auth-token', to: 'authentication#token'
      post '/create-upload-url', to: 'cdn_files#create_upload_url'
      post '/translate', to: 'translations#translate'
    end

    # For authentication across Interflux
    namespace :auth do
      post '/token', to: 'token#create'
      get '/user', to: 'user#show'
    end
  end

  # Return app meta info for health check.
  get 'sanity-check', to: 'sanity#check'

  # Return a 404 for all other routes.
  match '*catch', to: 'application#render_404', via: :all
end
