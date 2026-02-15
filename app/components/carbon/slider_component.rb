# frozen_string_literal: true

module Carbon
  class SliderComponent < BaseComponent
    attr_reader :name, :value, :min, :max, :step, :label_text, :disabled, :id

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

    def css_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    def thumb_percent
      return 0 if @max == @min

      ((@value.to_f - @min) / (@max - @min) * 100).round(4)
    end

    def filled_fraction
      return 0 if @max == @min

      ((@value.to_f - @min) / (@max - @min)).round(6)
    end

    private

    attr_reader :label_id
  end
end
