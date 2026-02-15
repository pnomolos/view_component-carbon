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
      classes = ['cds--form-item']
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def toggle_css_classes
      classes = ['cds--toggle']
      classes << "cds--toggle--#{@size}" if @size != DEFAULT_SIZE
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

    def input_css_classes
      'cds--toggle__input'
    end

    def switch_css_classes
      'cds--toggle__switch'
    end

    def wrapper_html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = wrapper_css_classes
      attrs['data-controller'] = 'carbon--toggle'
      attrs
    end

    def input_html_attributes
      attrs = {}
      attrs[:class] = input_css_classes
      attrs[:type] = 'checkbox'
      attrs[:role] = 'switch'
      attrs[:id] = @input_id
      attrs[:checked] = '' if @toggled
      attrs[:disabled] = '' if @disabled
      attrs['aria-checked'] = @toggled
      attrs['data-action'] = 'change->carbon--toggle#change'
      attrs['data-carbon--toggle-target'] = 'input'
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
