# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Slider input.
  #
  # @example Basic usage
  #   render Carbon::SliderComponent.new(name: "vol", value: 50, min: 0, max: 100)
  #
  # @see https://carbondesignsystem.com/components/slider/usage/
  class SliderComponent < BaseComponent
    # @return [String] input name attribute
    attr_reader :name
    # @return [Numeric] current value
    attr_reader :value
    # @return [Numeric] minimum value
    attr_reader :min
    # @return [Numeric] maximum value
    attr_reader :max
    # @return [Numeric] step increment
    attr_reader :step
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether readonly
    attr_reader :readonly
    # @return [Boolean] whether required
    attr_reader :required
    # @return [Boolean] whether invalid
    attr_reader :invalid
    # @return [Boolean] whether in warning state
    attr_reader :warn
    # @return [String, nil] invalid text
    attr_reader :invalid_text
    # @return [String, nil] warning text
    attr_reader :warn_text
    # @return [String, nil] minimum label text
    attr_reader :min_label
    # @return [String, nil] maximum label text
    attr_reader :max_label
    # @return [Boolean] whether to hide label
    attr_reader :hide_label
    # @return [Boolean] whether to hide text input
    attr_reader :hide_text_input
    # @return [String, nil] custom aria-valuetext for screen readers
    attr_reader :aria_value_text
    # @return [Numeric] step multiplier for keyboard navigation
    attr_reader :step_multiplier
    # @return [String] unique element ID
    attr_reader :id

    # @param name [String] input name attribute
    # @param value [Numeric] initial value
    # @param min [Numeric] minimum value
    # @param max [Numeric] maximum value
    # @param step [Numeric] step increment
    # @param label_text [String, nil] label text
    # @param disabled [Boolean] disables the slider
    # @param readonly [Boolean] makes the slider readonly
    # @param required [Boolean] marks the slider as required
    # @param invalid [Boolean] marks the slider as invalid
    # @param warn [Boolean] shows warning state
    # @param invalid_text [String, nil] invalid message text
    # @param warn_text [String, nil] warning message text
    # @param min_label [String, nil] minimum label text
    # @param max_label [String, nil] maximum label text
    # @param hide_label [Boolean] hides the label visually
    # @param hide_text_input [Boolean] hides the text input
    # @param aria_value_text [String, nil] custom aria-valuetext for screen readers
    # @param step_multiplier [Numeric] keyboard step multiplier (default: 4)
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(name:, value:, min: 0, max: 100, step: 1, label_text: nil, disabled: false,
                   readonly: false, required: false, invalid: false, warn: false,
                   invalid_text: nil, warn_text: nil, min_label: nil, max_label: nil,
                   hide_label: false, hide_text_input: false, aria_value_text: nil,
                   step_multiplier: 4, id: nil, **system_arguments)
      @name = name
      @value = value
      @min = min
      @max = max
      @step = step
      @label_text = label_text
      @disabled = disabled
      @readonly = readonly
      @required = required
      @invalid = invalid
      @warn = warn
      @invalid_text = invalid_text
      @warn_text = warn_text
      @min_label = min_label
      @max_label = max_label
      @hide_label = hide_label
      @hide_text_input = hide_text_input
      @aria_value_text = aria_value_text
      @step_multiplier = step_multiplier
      @id = id || "slider-#{SecureRandom.hex(8)}"
      @label_id = "#{@id}-label"
      @system_arguments = system_arguments
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the slider element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    # @return [Float] thumb position as a percentage
    def thumb_percent
      return 0 if @max == @min

      ((@value.to_f - @min) / (@max - @min) * 100).round(4)
    end

    # @return [Float] filled track fraction (0.0 to 1.0)
    def filled_fraction
      return 0 if @max == @min

      ((@value.to_f - @min) / (@max - @min)).round(6)
    end

    # @return [String] CSS classes for the slider element
    def slider_classes
      classes = ['cds--slider']
      classes << 'cds--slider--disabled' if @disabled
      classes << 'cds--slider--readonly' if @readonly
      class_names(*classes)
    end

    # @return [String] CSS classes for the label element
    def label_classes
      classes = ['cds--label']
      classes << 'cds--visually-hidden' if @hide_label
      classes << 'cds--label--disabled' if @disabled
      class_names(*classes)
    end

    # @return [String] formatted value text for aria-valuetext
    def format_value_text
      @aria_value_text || @value.to_s
    end

    # @return [String] formatted minimum text
    def format_min_text
      @min_label || @min.to_s
    end

    # @return [String] formatted maximum text
    def format_max_text
      @max_label || @max.to_s
    end

    # @return [Boolean] whether validation message should be shown
    def show_validation_message?
      (@invalid && @invalid_text) || (@warn && @warn_text)
    end

    # @return [String, nil] validation message CSS class
    def validation_message_class
      return nil unless show_validation_message?

      classes = ['cds--form-requirement', 'cds--slider__validation-msg']
      classes << 'cds--slider__validation-msg--invalid' if @invalid
      class_names(*classes)
    end

    # @return [String, nil] validation message text
    def validation_message_text
      return @invalid_text if @invalid && @invalid_text
      return @warn_text if @warn && @warn_text

      nil
    end

    private

    attr_reader :label_id
  end
end
