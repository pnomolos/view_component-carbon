# frozen_string_literal: true

module Carbon
  class NumberInputComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    attr_reader :name, :value, :label_text, :helper_text, :min, :max, :step, :disabled, :invalid, :invalid_text,
                :warn, :warn_text, :size, :id

    def initialize(
      label_text: nil,
      name: nil,
      value: nil,
      helper_text: nil,
      min: nil,
      max: nil,
      step: 1,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      size: DEFAULT_SIZE,
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

    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def number_classes
      classes = ['cds--number', "cds--number--#{@size}"]
      classes << 'cds--number--invalid' if @invalid
      classes << 'cds--number--warning' if @warn
      class_names(*classes)
    end

    def input_wrapper_classes
      classes = ['cds--number__input-wrapper']
      classes << 'cds--number__input-wrapper--warning' if @warn
      class_names(*classes)
    end

    def input_attributes
      attrs = {
        type: 'number',
        class: 'cds--number__input',
        id: @id,
        name: @name,
        value: @value,
        min: @min,
        max: @max,
        step: @step
      }
      attrs[:disabled] = '' if @disabled
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def button_attributes(type)
      attrs = {
        class: "cds--number__control-btn #{type}-icon",
        type: 'button',
        tabindex: '-1',
        title: type == 'down' ? 'Decrement' : 'Increment'
      }
      attrs[:disabled] = '' if @disabled
      attrs
    end

    def subtract_icon_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true">' \
        '<path d="M8 15H24V17H8z"></path>' \
        '</svg>'
    end

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
