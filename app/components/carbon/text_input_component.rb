# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Text Input.
  #
  # @example Basic usage
  #   render Carbon::TextInputComponent.new(label_text: "Name", name: "name")
  #
  # @see https://carbondesignsystem.com/components/text-input/usage/
  class TextInputComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    TYPES = %i[text password email url].freeze
    DEFAULT_SIZE = :md
    DEFAULT_TYPE = :text

    # @return [String, nil] input name
    attr_reader :name
    # @return [String, nil] current value
    attr_reader :value
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [String, nil] helper text
    attr_reader :helper_text
    # @return [String, nil] placeholder text
    attr_reader :placeholder
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
    # @return [Symbol] HTML input type
    attr_reader :type
    # @return [String] unique element ID
    attr_reader :id
    # @return [Integer, nil] maximum character count
    attr_reader :max_count

    # @param name [String, nil] input name attribute
    # @param value [String, nil] initial value
    # @param label_text [String, nil] label text
    # @param helper_text [String, nil] helper text
    # @param placeholder [String, nil] placeholder text
    # @param disabled [Boolean] disables the input
    # @param readonly [Boolean] makes the input readonly
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param size [Symbol] input size (:sm, :md, :lg)
    # @param type [Symbol] HTML input type (:text, :password, :email, :url)
    # @param id [String, nil] unique element ID
    # @param max_count [Integer, nil] maximum character count
    # @param system_arguments [Hash] additional HTML attributes
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
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @id = id || "text-input-#{SecureRandom.hex(4)}"
      @max_count = max_count
      @system_arguments = system_arguments

      initialize_form_field(
        invalid: invalid,
        invalid_text: invalid_text,
        warn: warn,
        warn_text: warn_text,
        helper_text: helper_text
      )
    end

    # @return [String] CSS class string for the outer wrapper
    def wrapper_classes
      classes = ['cds--form-item', 'cds--text-input-wrapper']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [String] CSS class string for the field wrapper
    def field_wrapper_classes
      class_names(*form_field_wrapper_classes('cds--text-input__field-wrapper'))
    end

    # @return [String] CSS class string for the input
    def input_classes
      classes = ['cds--text-input', "cds--text-input--#{@size}"]
      classes << 'cds--text-input--invalid' if @invalid
      classes << 'cds--text-input--warning' if @warn
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the input element
    def input_attributes
      attrs = base_input_attributes
      add_state_attributes(attrs)
      attrs[:'aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    # @return [Hash] base HTML attributes for the input
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

    # @param attrs [Hash] attributes hash to modify
    # @return [void]
    def add_state_attributes(attrs)
      attrs[:disabled] = '' if @disabled
      attrs[:readonly] = '' if @readonly
      attrs[:'data-invalid'] = '' if @invalid
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'data-warn'] = 'true' if @warn
      attrs[:maxlength] = @max_count if @max_count
    end

    # @return [Boolean] whether a Stimulus controller is needed
    def stimulus_controller?
      @max_count.present?
    end

    # @return [Hash] Stimulus data attributes for the wrapper
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
