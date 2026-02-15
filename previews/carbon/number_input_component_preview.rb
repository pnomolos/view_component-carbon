# frozen_string_literal: true

module Carbon
  class NumberInputComponentPreview < ViewComponent::Preview
    # @param label_text text
    # @param value number
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    def default(label_text: 'Quantity', value: 0, size: :md, disabled: false)
      render Carbon::NumberInputComponent.new(
        label_text: label_text,
        value: value,
        size: size.to_sym,
        disabled: disabled,
        name: 'quantity',
        min: 0,
        max: 100
      )
    end

    def with_helper_text
      render Carbon::NumberInputComponent.new(
        label_text: 'Age',
        name: 'age',
        value: 25,
        min: 0,
        max: 120,
        helper_text: 'Enter your age in years'
      )
    end

    def with_min_max
      render Carbon::NumberInputComponent.new(
        label_text: 'Temperature (°C)',
        name: 'temperature',
        value: 20,
        min: -50,
        max: 50,
        step: 1,
        helper_text: 'Range: -50 to 50'
      )
    end

    def with_step
      render Carbon::NumberInputComponent.new(
        label_text: 'Price',
        name: 'price',
        value: 10.50,
        min: 0,
        step: 0.25,
        helper_text: 'Price in increments of $0.25'
      )
    end

    def invalid
      render Carbon::NumberInputComponent.new(
        label_text: 'Items',
        name: 'items',
        value: 150,
        min: 1,
        max: 100,
        invalid: true,
        invalid_text: 'Maximum quantity is 100'
      )
    end

    def small_size
      render Carbon::NumberInputComponent.new(
        label_text: 'Small number input',
        size: :sm,
        value: 5
      )
    end

    def large_size
      render Carbon::NumberInputComponent.new(
        label_text: 'Large number input',
        size: :lg,
        value: 5
      )
    end

    def disabled
      render Carbon::NumberInputComponent.new(
        label_text: 'Disabled number input',
        disabled: true,
        value: 42
      )
    end
  end
end
