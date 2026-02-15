# frozen_string_literal: true

module Carbon
  class ToggleComponent < Carbon::BaseComponent
    SIZES = %i[sm md].freeze
    DEFAULT_SIZE = :md

    attr_reader :size, :toggled, :disabled, :label_a, :label_b, :label_text, :hide_label, :input_id

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
