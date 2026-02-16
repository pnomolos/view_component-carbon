# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Select (native HTML select).
  #
  # @example Basic usage
  #   render Carbon::SelectComponent.new(label_text: "Country") do |s|
  #     s.with_option(value: "us", text: "United States")
  #   end
  #
  # @see https://carbondesignsystem.com/components/select/usage/
  class SelectComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :options, 'Carbon::SelectComponent::OptionComponent'
    renders_many :option_groups, lambda { |label:, **system_arguments, &block|
      group = OptionGroupComponent.new(label: label, **system_arguments)
      block&.call(group)
      group
    }

    # @return [String] label text
    attr_reader :label_text
    # @return [Symbol] select size
    attr_reader :size
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether to render inline
    attr_reader :inline
    # @return [Boolean] whether the label is hidden
    attr_reader :hide_label
    # @return [String, nil] select name attribute
    attr_reader :name
    # @return [Boolean] whether readonly
    attr_reader :readonly
    # @return [Boolean] whether required
    attr_reader :required
    # @return [String, nil] placeholder text
    attr_reader :placeholder
    # @return [String, nil] current selected value
    attr_reader :value
    # @return [Boolean] whether to autofocus
    attr_reader :autofocus
    # @return [String, nil] validation pattern
    attr_reader :pattern
    # @return [Boolean] whether fluid layout enabled
    attr_reader :is_fluid

    # @param label_text [String] label text
    # @param size [Symbol] select size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the select
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param helper_text [String, nil] helper text
    # @param inline [Boolean] renders inline layout
    # @param hide_label [Boolean] visually hides the label
    # @param name [String, nil] select name attribute
    # @param id [String, nil] unique element ID
    # @param readonly [Boolean] makes the select readonly (disables interaction but shows value)
    # @param required [Boolean] marks as required for form validation
    # @param placeholder [String, nil] placeholder text (shown as disabled first option)
    # @param value [String, nil] current selected value
    # @param autofocus [Boolean] auto-focus on load
    # @param pattern [String, nil] validation pattern
    # @param is_fluid [Boolean] enables fluid layout with divider
    # @param system_arguments [Hash] additional HTML attributes
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(
      label_text: 'Label',
      size: DEFAULT_SIZE,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      inline: false,
      hide_label: false,
      name: nil,
      id: nil,
      readonly: false,
      required: false,
      placeholder: nil,
      value: nil,
      autofocus: false,
      pattern: nil,
      is_fluid: false,
      **system_arguments
    )
      @label_text = label_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @inline = inline
      @hide_label = hide_label
      @name = name
      @id = id || "select-#{SecureRandom.hex(4)}"
      @readonly = readonly
      @required = required
      @placeholder = placeholder
      @value = value
      @autofocus = autofocus
      @pattern = pattern
      @is_fluid = is_fluid
      @system_arguments = system_arguments

      # Normalize validation states when readonly
      if @readonly
        @actual_disabled = false
        @actual_invalid = false
        @actual_warn = false
      else
        @actual_disabled = @disabled
        @actual_invalid = !@disabled && invalid
        @actual_warn = !@disabled && !invalid && warn
      end

      initialize_form_field(invalid: @actual_invalid, invalid_text: invalid_text, warn: @actual_warn,
                            warn_text: warn_text, helper_text: helper_text)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # @return [String] unique select element ID
    def select_id
      @id
    end

    private

    def wrapper_classes
      classes = ['cds--select']
      classes << 'cds--select--disabled' if @actual_disabled
      classes << 'cds--select--invalid' if @actual_invalid
      classes << 'cds--select--warning' if @actual_warn
      classes << 'cds--select--inline' if @inline
      classes << 'cds--select--readonly' if @readonly
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def label_classes
      classes = ['cds--label']
      classes << 'cds--visually-hidden' if @hide_label
      classes << 'cds--label--disabled' if @actual_disabled
      class_names(classes)
    end

    def select_classes
      classes = ['cds--select-input']
      classes << "cds--select-input--#{@size}" if @size != DEFAULT_SIZE
      class_names(classes)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def select_attributes
      attrs = @system_arguments.except(:class).dup
      attrs[:class] = select_classes
      attrs[:id] = @id
      attrs[:name] = @name if @name
      attrs[:disabled] = '' if @actual_disabled
      attrs[:required] = '' if @required
      attrs[:autofocus] = '' if @autofocus
      attrs[:pattern] = @pattern if @pattern.present?
      attrs[:title] = @value if @value.present?
      attrs['aria-invalid'] = 'true' if @actual_invalid
      attrs['aria-readonly'] = @readonly.to_s
      attrs['aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def chevron_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true" ' \
        'class="cds--select__arrow">' \
        '<path d="M8 11L3 6 3.7 5.3 8 9.6 12.3 5.3 13 6z"></path>' \
        '</svg>'
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # A single select option.
    class OptionComponent < BaseComponent
      # @return [String] option value
      attr_reader :value
      # @return [String] option display text
      attr_reader :text
      # @return [Boolean] whether selected
      attr_reader :selected
      # @return [Boolean] whether disabled
      attr_reader :disabled

      # @param value [String] option value
      # @param text [String] option display text
      # @param selected [Boolean] marks option as selected
      # @param disabled [Boolean] disables the option
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(value:, text:, selected: false, disabled: false, **system_arguments)
        @value = value
        @text = text
        @selected = selected
        @disabled = disabled
        @system_arguments = system_arguments
      end

      def call
        # Rendered by parent template
        nil
      end
    end

    # A group of select options with a label.
    class OptionGroupComponent < BaseComponent
      # @return [String] group label
      attr_reader :label

      renders_many :options, 'Carbon::SelectComponent::OptionComponent'

      # @param label [String] group label
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(label:, **system_arguments)
        @label = label
        @system_arguments = system_arguments
      end

      def call
        # Rendered by parent template
        nil
      end
    end
  end
end
