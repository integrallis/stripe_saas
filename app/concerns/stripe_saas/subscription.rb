module StripeSaas::Subscription
  extend ActiveSupport::Concern

  included do
    monetize :current_price_cents, allow_nil: true

    # We don't store these one-time use tokens, but this is what Stripe provides
    # client-side after storing the credit card information.
    attr_accessor :credit_card_token

    belongs_to :plan

    # update details.
    before_save :processing!

    def processing!
      # if their package level has changed ..
      if changing_plans?
        # and a customer exists in stripe ..
        if stripe_id.present?
          # fetch the customer.
          customer = Stripe::Customer.retrieve(stripe_id)

          if customer.default_card.nil? && !credit_card_token.nil?
            customer.card = credit_card_token
            customer.save
          end

          # if a new plan has been selected
          if self.plan.present?

            # Record the new plan pricing.
            self.current_price = self.plan.price

            # update the package level with stripe.
            customer.update_subscription(:plan => self.plan.stripe_id)

            # if no plan has been selected.
          else

            # Remove the current pricing.
            self.current_price = nil

            # delete the subscription.
            customer.cancel_subscription

          end

          # otherwise
        else
          # if a new plan has been selected
          if self.plan.present?
            # Record the new plan pricing.
            self.current_price = self.plan.price

            begin
              customer_attributes = if self.plan.free?
                {
                  description: subscription_owner_description,
                  email: subscription_owner_email,
                }
              else
                {
                  description: subscription_owner_description,
                  email: subscription_owner_email,
                  card: credit_card_token
                }
              end

              # create a customer at that package level.
              customer = Stripe::Customer.create(customer_attributes)
              customer.update_subscription(:plan => plan.stripe_id)
            rescue Stripe::CardError => card_error
              errors[:base] << card_error.message
              card_was_declined
              return false
            end

            # store the customer id.
            self.stripe_id = customer.id
            unless self.plan.free?
              self.last_four = customer.cards.retrieve(customer.default_card).last4
            end
          else

            # This should never happen.

            self.plan_id = nil

            # Remove any plan pricing.
            self.current_price = nil

          end

        end

        # if they're updating their credit card details.
      elsif self.credit_card_token.present?
        # fetch the customer.
        customer = Stripe::Customer.retrieve(self.stripe_id)
        customer.card = self.credit_card_token
        customer.save

        # update the last four based on this new card.
        self.last_four = customer.cards.retrieve(customer.default_card).last4
      end
    end
  end

  # Set a Stripe coupon code that will be used when a new Stripe customer (a.k.a. StripeSaas subscription)
  # is created
  def coupon_code=(new_code)
    @coupon_code = new_code
  end

  # Pretty sure this wouldn't conflict with anything someone would put in their model
  def subscription_owner
    StripeSaas::Subscription.find_customer(self)
  end

  def self.find_customer(subscription_or_owner)
    if subscription_or_owner.class.to_s.downcase.to_sym == StripeSaas.subscriptions_owned_by
      owner = subscription_or_owner
    else
      owner = subscription_or_owner.send StripeSaas.subscriptions_owned_by
    end
    # Return whatever we belong to.
    # If this object doesn't respond to 'name', please update owner_description.
    if StripeSaas.customer_accessor
      if StripeSaas.customer_accessor.kind_of?(Array)
        StripeSaas.customer_accessor.inject(subscription_or_owner) {|o, a| o.send(a); o }
      else
        owner.send StripeSaas.customer_accessor
      end
    else
      owner
    end
  end

  def subscription_owner=(owner)
    # e.g. @subscription.user = @owner
    send StripeSaas.owner_assignment_sym, owner
  end

  def subscription_owner_description
    # assuming owner responds to name.
    # we should check for whether it responds to this or not.
    "#{subscription_owner.try(:name) || subscription_owner.try(:id)}"
  end

  def subscription_owner_email
    "#{subscription_owner.try(:email)}"
  end

  def changing_plans?
    plan_id_changed?
  end

  def downgrading?
    plan.present? and plan_id_was.present? and plan_id_was > self.plan_id
  end

  def upgrading?
    (plan_id_was.present? and plan_id_was < plan_id) or plan_id_was.nil?
  end

  # TODO: this does not belong in here - need a presenter
  def describe_difference(plan_to_describe)
    if plan.nil?
      if persisted?
        "Upgrade"
      end
    else
      if plan_to_describe.is_upgrade_from?(plan)
        "Upgrade"
      else
        "Downgrade"
      end
    end
  end

end
