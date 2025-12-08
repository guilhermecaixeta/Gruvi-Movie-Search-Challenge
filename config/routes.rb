Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  namespace :api do
    namespace :v1 do
        resource :movie do
          get "search" => "movie#search"
        end
      end
    end
    get "up" => "rails/health#show", as: :rails_health_check
end
