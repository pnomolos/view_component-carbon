# frozen_string_literal: true

module Carbon
  class TextInputComponent < BaseComponent
    SIZES = %i[sm md lg].freeze
    TYPES = %i[text password email url].freeze
    DEFAULT_SIZE = :md
    DEFAULT_TYPE = :text

    attr_reader :name, :value, :label_text, :helper_text, :placeholder, :disabled, :readonly, :invalid, :invalid_text,
                :warn, :warn_text, :size, :type, :id, :max_count

    def initialize(
      name: nil,
      value: nil,
      label_text: nil,
      helper_text: nil,
      placeholder: nil,
      disabled: false,
      readonly: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      size: DEFAULT_SIZE,
      type: DEFAULT_TYPE,
      id: nil,
      max_count: nil,
      **system_arguments
    )
      @name = name
      @value = value
      @label_text = label_text
      @helper_text = helper_text
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @invalid = invalid
      @invalid_text = invalid_text
      @warn = warn
      @warn_text = warn_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @id = id || "text-input-#{SecureRandom.hex(4)}"
      @max_count = max_count
      @system_arguments = system_arguments
    end

    def wrapper_classes
      classes = ['cds--form-item', 'cds--text-input-wrapper']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def field_wrapper_classes
      classes = ['cds--text-input__field-wrapper']
      classes << 'cds--text-input__field-wrapper--warning' if @warn && !@invalid
      class_names(*classes)
    end

    def input_classes
      classes = ['cds--text-input', "cds--text-input--#{@size}"]
      classes << 'cds--text-input--invalid' if @invalid
      classes << 'cds--text-input--warning' if @warn && !@invalid
      class_names(*classes)
    end

    def input_attributes
      attrs = base_input_attributes
      add_state_attributes(attrs)
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def base_input_attributes
      {
        type: @type.to_s,
        class: input_classes,
        id: @id,
        name: @name,
        placeholder: @placeholder,
        value: @value
      }
    end

    def add_state_attributes(attrs) # rubocop:disable Metrics/CyclomaticComplexity
      attrs[:disabled] = '' if @disabled
      attrs[:readonly] = '' if @readonly
      attrs[:'data-invalid'] = 'true' if @invalid
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'data-warn'] = 'true' if @warn && !@invalid
      attrs[:maxlength] = @max_count if @max_count
    end

    def stimulus_controller?
      @max_count.present?
    end

    def wrapper_data_attributes
      return {} unless stimulus_controller?

      {
        data: {
          controller: 'carbon--text-input',
          'carbon--text-input-max-count-value': @max_count
        }
      }
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
