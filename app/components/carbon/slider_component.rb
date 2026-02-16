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
    # @return [String] unique element ID
    attr_reader :id

    # @param name [String] input name attribute
    # @param value [Numeric] initial value
    # @param min [Numeric] minimum value
    # @param max [Numeric] maximum value
    # @param step [Numeric] step increment
    # @param label_text [String, nil] label text
    # @param disabled [Boolean] disables the slider
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(name:, value:, min: 0, max: 100, step: 1, label_text: nil, disabled: false,
                   id: nil, **system_arguments)
      @name = name
      @value = value
      @min = min
      @max = max
      @step = step
      @label_text = label_text
      @disabled = disabled
      @id = id || "slider-#{SecureRandom.hex(8)}"
      @label_id = "#{@id}-label"
      @system_arguments = system_arguments
    end

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

    private

    attr_reader :label_id
  end
end
