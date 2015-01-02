namespace :stripe_saas do
  desc "Install StripeSaas"
  task :install do
    system 'rails g stripe_saas:install'
  end

  desc "Install StripeSaas views"
  task :views do
    system 'rails g stripe_saas:views'
  end
end
