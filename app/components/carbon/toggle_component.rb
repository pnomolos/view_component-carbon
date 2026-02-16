# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Toggle switch.
  #
  # @example Basic usage
  #   render Carbon::ToggleComponent.new(label_text: "Dark mode", toggled: false)
  #
  # @see https://carbondesignsystem.com/components/toggle/usage/
  class ToggleComponent < Carbon::BaseComponent
    SIZES = %i[sm md].freeze
    DEFAULT_SIZE = :md

    # @return [Symbol] toggle size
    attr_reader :size
    # @return [Boolean] whether toggled on
    attr_reader :toggled
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [String] text shown when off
    attr_reader :label_a
    # @return [String] text shown when on
    attr_reader :label_b
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [Boolean] whether the label is hidden
    attr_reader :hide_label
    # @return [String] unique input ID
    attr_reader :input_id

    # @param size [Symbol] toggle size (:sm, :md)
    # @param toggled [Boolean] initial toggled state
    # @param disabled [Boolean] disables the toggle
    # @param label_a [String] text shown when off
    # @param label_b [String] text shown when on
    # @param label_text [String, nil] label text
    # @param hide_label [Boolean] visually hides the label
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      size: DEFAULT_SIZE,
      toggled: false,
      disabled: false,
      label_a: 'Off',
      label_b: 'On',
      label_text: nil,
      hide_label: false,
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @toggled = toggled
      @disabled = disabled
      @label_a = label_a
      @label_b = label_b
      @label_text = label_text
      @hide_label = hide_label
      @system_arguments = system_arguments
      @input_id = "toggle-#{SecureRandom.hex(8)}"
    end

    private

    def wrapper_css_classes
      classes = ['cds--toggle']
      classes << 'cds--toggle--disabled' if @disabled
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def label_css_classes
      ['cds--toggle__label']
    end

    def label_text_css_classes
      classes = ['cds--toggle__label-text']
      classes << 'cds--visually-hidden' if @hide_label
      class_names(classes)
    end

    def button_css_classes
      'cds--toggle__button'
    end

    def appearance_css_classes
      classes = ['cds--toggle__appearance']
      classes << 'cds--toggle__appearance--sm' if @size == :sm
      class_names(classes)
    end

    def switch_css_classes
      classes = ['cds--toggle__switch']
      classes << 'cds--toggle__switch--checked' if @toggled
      class_names(classes)
    end

    def current_text
      @toggled ? @label_b : @label_a
    end

    def wrapper_html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = wrapper_css_classes
      attrs['data-controller'] = 'carbon--toggle'
      attrs
    end

    def button_html_attributes
      attrs = {}
      attrs[:id] = @input_id
      attrs[:class] = button_css_classes
      attrs[:role] = 'switch'
      attrs[:type] = 'button'
      attrs['aria-checked'] = @toggled.to_s
      attrs['aria-labelledby'] = "#{@input_id}_label"
      attrs[:disabled] = '' if @disabled
      attrs['data-action'] = 'click->carbon--toggle#toggle'
      attrs['data-carbon--toggle-target'] = 'button'
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
