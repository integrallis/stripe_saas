require 'rails/generators'

module StripeSaas
  class ViewsGenerator < Rails::Generators::Base
    # # Not sure what this does.
    # source_root "#{StripeSaas::Engine.root}/app/views/StripeSaas/subscriptions"

    include Rails::Generators::Migration

    desc "StripeSaas installation generator"

    def install
      files_to_copy = Dir.entries("#{StripeSaas::Engine.root}/app/views/stripe_saas/subscriptions") - %w[. ..]
      files_to_copy.each do |file|
        copy_file file, "app/views/stripe_saas/subscriptions/#{file}"
      end
    end

  end
end
