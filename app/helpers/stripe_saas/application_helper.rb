module StripeSaas
  module ApplicationHelper
    include MoneyRails::ActionViewExtension

    def plan_price(plan)
      "#{humanized_money_with_symbol(plan.price, :no_cents => false)}/#{plan_interval(plan)}"
    end

    def plan_interval(plan)
      case plan.interval
      when "month"
        "month"
      when "year"
        "year"
      when "week"
        "week"
      when "6-month"
        "half-year"
      when "3-month"
        "quarter"
      else
        "month"
      end
    end
  end
end
