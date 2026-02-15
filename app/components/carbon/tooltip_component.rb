# frozen_string_literal: true

module Carbon
  class TooltipComponent < BaseComponent
    ALIGNMENTS = %i[top bottom left right].freeze
    DEFAULT_ALIGNMENT = :bottom

    attr_reader :label, :align, :description

    def initialize(label:, align: DEFAULT_ALIGNMENT, description: nil, **system_arguments)
      @label = label
      @align = validate_argument(:align, align, ALIGNMENTS, DEFAULT_ALIGNMENT)
      @description = description
      @system_arguments = system_arguments
    end

    def tooltip_id
      @tooltip_id ||= "tooltip-#{SecureRandom.hex(8)}"
    end

    def css_classes
      classes = ['cds--tooltip', "cds--popover--#{@align}"]
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--tooltip'
      attrs
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
