# frozen_string_literal: true

module Carbon
  class CheckboxComponent < BaseComponent
    attr_reader :name, :value, :checked, :indeterminate, :disabled, :label_text, :hide_label, :id

    def initialize(
      label_text:,
      name: nil,
      value: nil,
      checked: false,
      indeterminate: false,
      disabled: false,
      hide_label: false,
      id: nil,
      **system_arguments
    )
      @label_text = label_text
      @name = name
      @value = value
      @checked = checked
      @indeterminate = indeterminate
      @disabled = disabled
      @hide_label = hide_label
      @id = id || "checkbox-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    def wrapper_classes
      classes = ['cds--form-item', 'cds--checkbox-wrapper']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def checkbox_attributes
      attrs = {
        type: 'checkbox',
        class: 'cds--checkbox',
        id: @id,
        name: @name,
        value: @value
      }
      attrs[:checked] = '' if @checked
      attrs[:disabled] = '' if @disabled
      attrs[:'aria-checked'] = @indeterminate ? 'mixed' : @checked.to_s
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def label_classes
      classes = ['cds--checkbox-label']
      classes << 'cds--visually-hidden' if @hide_label
      class_names(*classes)
    end

    def stimulus_controller?
      @indeterminate
    end

    def wrapper_data_attributes
      return {} unless stimulus_controller?

      {
        data: {
          controller: 'carbon--checkbox',
          'carbon--checkbox-indeterminate-value': 'true'
        }
      }
    end
  end
end
