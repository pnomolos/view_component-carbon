# frozen_string_literal: true

module Carbon
  class RadioButtonGroupComponentPreview < ViewComponent::Preview
    # @param orientation select { choices: [vertical, horizontal] }
    # @param legend_text text
    def default(orientation: :vertical, legend_text: 'Choose a size')
      render Carbon::RadioButtonGroupComponent.new(
        name: 'size',
        orientation: orientation.to_sym,
        legend_text: legend_text
      ) do |c|
        c.with_radio(value: 'small', label_text: 'Small')
        c.with_radio(value: 'medium', label_text: 'Medium', checked: true)
        c.with_radio(value: 'large', label_text: 'Large')
      end
    end

    def vertical
      render Carbon::RadioButtonGroupComponent.new(
        name: 'plan',
        legend_text: 'Select a plan',
        orientation: :vertical
      ) do |c|
        c.with_radio(value: 'free', label_text: 'Free')
        c.with_radio(value: 'pro', label_text: 'Pro', checked: true)
        c.with_radio(value: 'enterprise', label_text: 'Enterprise')
      end
    end

    def horizontal
      render Carbon::RadioButtonGroupComponent.new(
        name: 'alignment',
        legend_text: 'Text alignment',
        orientation: :horizontal
      ) do |c|
        c.with_radio(value: 'left', label_text: 'Left', checked: true)
        c.with_radio(value: 'center', label_text: 'Center')
        c.with_radio(value: 'right', label_text: 'Right')
      end
    end

    def with_disabled_option
      render Carbon::RadioButtonGroupComponent.new(
        name: 'subscription',
        legend_text: 'Subscription status'
      ) do |c|
        c.with_radio(value: 'active', label_text: 'Active', checked: true)
        c.with_radio(value: 'paused', label_text: 'Paused')
        c.with_radio(value: 'cancelled', label_text: 'Cancelled (Unavailable)', disabled: true)
      end
    end

    def no_legend
      render Carbon::RadioButtonGroupComponent.new(name: 'color') do |c|
        c.with_radio(value: 'red', label_text: 'Red')
        c.with_radio(value: 'blue', label_text: 'Blue')
        c.with_radio(value: 'green', label_text: 'Green')
      end
    end
  end
end
