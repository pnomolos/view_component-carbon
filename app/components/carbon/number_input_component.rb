# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Number Input with increment/decrement controls.
  #
  # @example Basic usage
  #   render Carbon::NumberInputComponent.new(label_text: "Quantity", value: 1)
  #
  # @see https://carbondesignsystem.com/components/number-input/usage/
  class NumberInputComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    # @return [String, nil] input name
    attr_reader :name
    # @return [Numeric, nil] current value
    attr_reader :value
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [String, nil] helper text
    attr_reader :helper_text
    # @return [Numeric, nil] minimum value
    attr_reader :min
    # @return [Numeric, nil] maximum value
    attr_reader :max
    # @return [Numeric] step increment
    attr_reader :step
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether readonly
    attr_reader :readonly
    # @return [Boolean] whether in invalid state
    attr_reader :invalid
    # @return [String, nil] validation error message
    attr_reader :invalid_text
    # @return [Boolean] whether in warning state
    attr_reader :warn
    # @return [String, nil] warning message
    attr_reader :warn_text
    # @return [Symbol] input size
    attr_reader :size
    # @return [Boolean] whether to hide steppers
    attr_reader :hide_steppers
    # @return [String] unique element ID
    attr_reader :id

    # @param label_text [String, nil] label text
    # @param name [String, nil] input name attribute
    # @param value [Numeric, nil] initial value
    # @param helper_text [String, nil] helper text
    # @param min [Numeric, nil] minimum allowed value
    # @param max [Numeric, nil] maximum allowed value
    # @param step [Numeric] step increment
    # @param disabled [Boolean] disables the input
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param size [Symbol] input size (:sm, :md, :lg)
    # @param hide_steppers [Boolean] hides increment/decrement controls
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      label_text: nil,
      name: nil,
      value: nil,
      helper_text: nil,
      min: nil,
      max: nil,
      step: 1,
      disabled: false,
      readonly: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      size: DEFAULT_SIZE,
      hide_steppers: false,
      id: nil,
      **system_arguments
    )
      @label_text = label_text
      @name = name
      @value = value
      @min = min
      @max = max
      @step = step
      @disabled = disabled
      @readonly = readonly
      @hide_steppers = hide_steppers
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @id = id || "number-input-#{SecureRandom.hex(4)}"
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
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [String] CSS class string for the number container
    def number_classes
      classes = ['cds--number', "cds--number--#{@size}", 'cds--number--helpertext']
      classes << 'cds--number--invalid' if @invalid
      classes << 'cds--number--warn' if @warn
      classes << 'cds--number--readonly' if @readonly
      classes << 'cds--number--nosteppers' if @hide_steppers
      class_names(*classes)
    end

    # @return [String] CSS class string for the input wrapper
    def input_wrapper_classes
      classes = ['cds--number__input-wrapper']
      classes << 'cds--number__input-wrapper--warning' if @warn
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the number input
    def input_attributes
      attrs = {
        type: 'number',
        class: 'cds--number__input',
        id: @id,
        name: @name,
        value: @value,
        min: @min,
        max: @max,
        step: @step,
        role: 'alert',
        'aria-atomic': 'true'
      }
      attrs[:disabled] = '' if @disabled
      attrs[:readonly] = '' if @readonly
      attrs[:'aria-readonly'] = @readonly.to_s if @readonly
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    # @param type [String] button direction ("up" or "down")
    # @return [Hash] HTML attributes for increment/decrement buttons
    def button_attributes(type)
      label = type == 'down' ? 'decrease number input' : 'increase number input'
      attrs = {
        class: "cds--number__control-btn #{type}-icon",
        type: 'button',
        tabindex: '-1',
        'aria-label': label,
        'aria-live': 'polite',
        'aria-atomic': 'true'
      }
      attrs[:disabled] = '' if @disabled || @readonly
      attrs
    end

    # @return [String] SVG markup for the subtract icon
    def subtract_icon_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true">' \
        '<path d="M8 15H24V17H8z"></path>' \
        '</svg>'
    end

    # @return [String] SVG markup for the add icon
    def add_icon_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true">' \
        '<path d="M17 15L17 8 15 8 15 15 8 15 8 17 15 17 15 24 17 24 17 17 24 17 24 15z"></path>' \
        '</svg>'
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
