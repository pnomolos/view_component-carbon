# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Checkbox input.
  #
  # @example Basic usage
  #   render Carbon::CheckboxComponent.new(label_text: "Accept terms")
  #
  # @see https://carbondesignsystem.com/components/checkbox/usage/
  class CheckboxComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    # @return [String, nil] input name attribute
    attr_reader :name
    # @return [String, nil] input value
    attr_reader :value
    # @return [Boolean] whether checked
    attr_reader :checked
    # @return [Boolean] whether in indeterminate state
    attr_reader :indeterminate
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether readonly
    attr_reader :readonly
    # @return [String] visible label text
    attr_reader :label_text
    # @return [Boolean] whether to visually hide the label
    attr_reader :hide_label
    # @return [Boolean] whether in invalid state
    attr_reader :invalid
    # @return [String, nil] validation error message
    attr_reader :invalid_text
    # @return [Boolean] whether in warning state
    attr_reader :warn
    # @return [String, nil] warning message
    attr_reader :warn_text
    # @return [String, nil] helper text
    attr_reader :helper_text
    # @return [String] unique element ID
    attr_reader :id

    # @param label_text [String] visible label text
    # @param name [String, nil] input name attribute
    # @param value [String, nil] input value
    # @param checked [Boolean] initial checked state
    # @param indeterminate [Boolean] indeterminate state
    # @param disabled [Boolean] disables the checkbox
    # @param readonly [Boolean] makes the checkbox readonly
    # @param hide_label [Boolean] visually hides the label
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param helper_text [String, nil] helper text below the input
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      label_text:,
      name: nil,
      value: nil,
      checked: false,
      indeterminate: false,
      disabled: false,
      readonly: false,
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
      @readonly = readonly
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

    # @return [String] CSS class string for the wrapper
    def wrapper_classes
      classes = form_field_wrapper_classes('cds--checkbox-wrapper')
      classes.unshift('cds--form-item')
      classes << 'cds--checkbox-wrapper--readonly' if @readonly
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the checkbox input
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
      attrs[:readonly] = '' if @readonly
      attrs[:'aria-checked'] = @indeterminate ? 'mixed' : @checked.to_s
      attrs[:'data-invalid'] = '' if @invalid
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    # @return [String] CSS class string for the label
    def label_classes
      classes = ['cds--checkbox-label']
      classes << 'cds--visually-hidden' if @hide_label
      class_names(*classes)
    end

    # @return [Boolean] whether a Stimulus controller is needed
    def stimulus_controller?
      @indeterminate
    end

    # @return [Hash] Stimulus data attributes for the wrapper
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
