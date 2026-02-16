# frozen_string_literal: true

module Carbon
  class CheckboxComponentPreview < ViewComponent::Preview
    # @param label_text text
    # @param checked toggle
    # @param disabled toggle
    # @param indeterminate toggle
    def default(label_text: 'Accept terms and conditions', checked: false, disabled: false,
                indeterminate: false)
      render Carbon::CheckboxComponent.new(
        label_text: label_text,
        checked: checked,
        disabled: disabled,
        indeterminate: indeterminate,
        name: 'terms',
        value: 'accepted'
      )
    end

    def checked
      render Carbon::CheckboxComponent.new(
        label_text: 'I agree to the terms',
        name: 'agreement',
        checked: true
      )
    end

    def disabled
      render Carbon::CheckboxComponent.new(
        label_text: 'Disabled option',
        disabled: true
      )
    end

    def indeterminate
      render Carbon::CheckboxComponent.new(
        label_text: 'Select all',
        indeterminate: true,
        name: 'select_all'
      )
    end

    def with_name_and_value
      render Carbon::CheckboxComponent.new(
        label_text: 'Subscribe to newsletter',
        name: 'newsletter',
        value: 'yes'
      )
    end

    def hidden_label
      render Carbon::CheckboxComponent.new(
        label_text: 'Hidden label',
        hide_label: true
      )
    end
  end
end
