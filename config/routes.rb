Rails.application.routes.draw do
  resources :line_items
  resources :carts
  root "store#index", as: "store_index"
  get "store/index"  # Add this line

  resources :products

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
