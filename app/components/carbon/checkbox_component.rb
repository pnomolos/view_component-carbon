# frozen_string_literal: true

module Carbon
  class CheckboxComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    attr_reader :name, :value, :checked, :indeterminate, :disabled, :label_text, :hide_label,
                :invalid, :invalid_text, :warn, :warn_text, :helper_text, :id

    def initialize(
      label_text:,
      name: nil,
      value: nil,
      checked: false,
      indeterminate: false,
      disabled: false,
      hide_label: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
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

      initialize_form_field(
        invalid: invalid,
        invalid_text: invalid_text,
        warn: warn,
        warn_text: warn_text,
        helper_text: helper_text
      )
    end

    def wrapper_classes
      classes = form_field_wrapper_classes('cds--checkbox-wrapper')
      classes.unshift('cds--form-item')
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
      attrs[:'data-invalid'] = '' if @invalid
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
