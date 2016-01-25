require_relative 'configuration'

module StripeSaas
  class Engine < ::Rails::Engine
    isolate_namespace StripeSaas

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'stripe_saas.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper StripeSaas::ApplicationHelper
      end
    end

    initializer 'stripe_saas.create_plans' do |app|
      if StripeSaas.create_plans_in_stripe?
        begin
          ::Plan.all.each do |plan|
            unless StripeSaas.non_stripe_plans.include?(plan.stripe_id)
              begin
                stripe_plan = Stripe::Plan.retrieve(plan.stripe_id)
              rescue Stripe::InvalidRequestError => ire
                if ire.message == "No such plan: #{plan.stripe_id}"
                  Stripe::Plan.create(
                    id: plan.stripe_id,
                    name: plan.name,
                    amount: plan.price_cents,
                    interval: plan.interval,
                    interval_count: plan.interval_count,
                    trial_period_days: plan.trial_period_days,
                    statement_descriptor: plan.statement_descriptor,
                    currency: 'usd',
                    metadata: plan.metadata_as_json
                  )
                end
              end
            end
          end
        rescue NameError, ActiveRecord::StatementInvalid
          # ignore: Plan model is not defined yet (migration might not have run)
        end
      end
    end
  end
end
