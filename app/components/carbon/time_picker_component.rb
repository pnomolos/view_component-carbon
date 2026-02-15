# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Time Picker.
  #
  # @example Basic usage
  #   render Carbon::TimePickerComponent.new(label_text: "Time", id: "time")
  #
  # @see https://carbondesignsystem.com/components/time-picker/usage/
  class TimePickerComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :selects, lambda { |id:, label_text: 'open list of options', disabled: false, **system_arguments|
      TimePickerSelectComponent.new(
        id: id, label_text: label_text, disabled: disabled || @disabled, **system_arguments
      )
    }

    # @return [String, nil] label text
    attr_reader :label_text
    # @return [Symbol] input size
    attr_reader :size
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [String] placeholder text
    attr_reader :placeholder
    # @return [String, nil] current value
    attr_reader :value
    # @return [String] unique element ID
    attr_reader :id
    # @return [String, nil] input name attribute
    attr_reader :name

    # @param label_text [String, nil] label text
    # @param size [Symbol] input size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the picker
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param placeholder [String] placeholder text
    # @param value [String, nil] initial time value
    # @param id [String, nil] unique element ID
    # @param name [String, nil] input name attribute
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      label_text: nil,
      size: DEFAULT_SIZE,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      placeholder: 'hh:mm',
      value: nil,
      id: nil,
      name: nil,
      **system_arguments
    )
      @label_text = label_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @placeholder = placeholder
      @value = value
      @id = id || "time-picker-#{SecureRandom.hex(4)}"
      @name = name
      @system_arguments = system_arguments

      initialize_form_field(
        invalid: invalid,
        invalid_text: invalid_text,
        warn: warn,
        warn_text: warn_text
      )
    end

    # @return [String] CSS class string for the wrapper
    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [String] CSS class string for the time picker
    def time_picker_classes
      classes = ['cds--time-picker', "cds--time-picker--#{@size}"]
      classes << 'cds--time-picker--invalid' if @invalid
      classes << 'cds--time-picker--warning' if @warn
      class_names(*classes)
    end

    # @return [String] CSS class string for the input
    def input_classes
      classes = ['cds--time-picker__input-field', 'cds--text-input', "cds--text-input--#{@size}"]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the time input
    def input_attributes
      attrs = {
        type: 'text',
        class: input_classes,
        id: @id,
        name: @name,
        placeholder: @placeholder,
        value: @value,
        maxlength: 5,
        pattern: '(1[012]|[1-9]):[0-5][0-9](\\s)?'
      }
      attrs[:disabled] = '' if @disabled
      attrs[:'data-invalid'] = '' if @invalid
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # Select dropdown within a TimePicker (e.g., AM/PM or timezone).
    class TimePickerSelectComponent < Carbon::BaseComponent
      # @return [String] select element ID
      attr_reader :select_id
      # @return [String] label text
      attr_reader :label_text
      # @return [Boolean] whether disabled
      attr_reader :disabled

      # @param id [String] select element ID
      # @param label_text [String] accessible label
      # @param disabled [Boolean] disables the select
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(id:, label_text: 'open list of options', disabled: false, **system_arguments)
        @select_id = id
        @label_text = label_text
        @disabled = disabled
        @system_arguments = system_arguments
      end

      # @return [Hash] HTML attributes for the select element
      def select_attributes
        attrs = {
          class: 'cds--select-input',
          id: @select_id,
          'aria-label': @label_text
        }
        attrs[:disabled] = '' if @disabled
        attrs.merge!(@system_arguments)
        attrs.compact
      end

      # @return [String] SVG markup for the chevron icon
      def chevron_down_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
          'fill="currentColor" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true">' \
          '<path d="M8 11L3 6 3.7 5.3 8 9.6 12.3 5.3 13 6z"></path>' \
          '</svg>'
      end
    end
  end
end
