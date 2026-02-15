# frozen_string_literal: true

module Carbon
  class NumberInputComponent < BaseComponent
    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    attr_reader :name, :value, :label_text, :helper_text, :min, :max, :step, :disabled, :invalid, :invalid_text, :size,
                :id

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
      size: DEFAULT_SIZE,
      id: nil,
      **system_arguments
    )
      @label_text = label_text
      @name = name
      @value = value
      @helper_text = helper_text
      @min = min
      @max = max
      @step = step
      @disabled = disabled
      @invalid = invalid
      @invalid_text = invalid_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @id = id || "number-input-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def number_classes
      classes = ['cds--number', "cds--number--#{@size}"]
      classes << 'cds--number--invalid' if @invalid
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
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def button_attributes(type)
      attrs = {
        class: "cds--number__control-btn #{type}-icon",
        type: 'button'
      }
      attrs[:disabled] = '' if @disabled
      attrs
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
