StripeSaas::Engine.routes.draw do
  resources :subscriptions, only: [:new]
  resources StripeSaas.owner_resource, as: :owner do
    resources :subscriptions do
      member do
        post :cancel
      end
    end
  end
end
