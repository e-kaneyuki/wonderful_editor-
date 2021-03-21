Rails.application.routes.draw do
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
        sessions: "api/v1/auth/sessions"
      }
      resources :articles
    end
  end
end
