# frozen_string_literal: true

module Carbon
  class RadioButtonComponentPreview < ViewComponent::Preview
    # @param label_text text
    # @param checked toggle
    # @param disabled toggle
    def default(label_text: 'Radio option', checked: false, disabled: false)
      render Carbon::RadioButtonComponent.new(
        name: 'example',
        value: 'option1',
        label_text: label_text,
        checked: checked,
        disabled: disabled
      )
    end

    def checked
      render Carbon::RadioButtonComponent.new(
        name: 'status',
        value: 'active',
        label_text: 'Active',
        checked: true
      )
    end

    def disabled
      render Carbon::RadioButtonComponent.new(
        name: 'status',
        value: 'inactive',
        label_text: 'Inactive',
        disabled: true
      )
    end
  end
end
