# frozen_string_literal: true

module Carbon
  class DatePickerComponentPreview < ViewComponent::Preview
    # @param type select { choices: [simple, single, range] }
    # @param disabled toggle
    def default(type: :simple, disabled: false)
      render Carbon::DatePickerComponent.new(
        type: type.to_sym,
        label_text: 'Date Picker label',
        disabled: disabled
      )
    end

    def simple
      render Carbon::DatePickerComponent.new(
        type: :simple,
        label_text: 'Simple date picker',
        placeholder: 'mm/dd/yyyy'
      )
    end

    def single
      render Carbon::DatePickerComponent.new(
        type: :single,
        label_text: 'Single date picker',
        placeholder: 'mm/dd/yyyy'
      )
    end

    def range
      render Carbon::DatePickerComponent.new(
        type: :range,
        label_text: 'Start date'
      ) do |c|
        c.with_range_input(label_text: 'End date')
      end
    end

    def with_helper_text
      render Carbon::DatePickerComponent.new(
        type: :single,
        label_text: 'Date Picker label',
        helper_text: 'Select a date in mm/dd/yyyy format'
      )
    end

    def disabled
      render Carbon::DatePickerComponent.new(
        type: :single,
        label_text: 'Disabled date picker',
        disabled: true
      )
    end

    def invalid
      render Carbon::DatePickerComponent.new(
        type: :single,
        label_text: 'Date Picker label',
        invalid: true,
        invalid_text: 'A valid date is required'
      )
    end

    def with_date_constraints
      render Carbon::DatePickerComponent.new(
        type: :single,
        label_text: 'Constrained date picker',
        helper_text: 'Select a date in 2025',
        min_date: '2025-01-01',
        max_date: '2025-12-31'
      )
    end
  end
end
