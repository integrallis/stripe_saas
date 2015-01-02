Rails.application.routes.draw do
  # Added by StripeSaas.
  mount StripeSaas::Engine, at: 'stripe_saas'
  scope module: 'stripe_saas' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end

  devise_for :users
  root 'home#index'
end
