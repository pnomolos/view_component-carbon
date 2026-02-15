# frozen_string_literal: true

module Carbon
  class ToggletipComponent < BaseComponent
    ALIGNMENTS = %i[top bottom left right].freeze
    DEFAULT_ALIGNMENT = :bottom

    renders_one :body

    attr_reader :align

    def initialize(align: DEFAULT_ALIGNMENT, **system_arguments)
      @align = validate_argument(:align, align, ALIGNMENTS, DEFAULT_ALIGNMENT)
      @system_arguments = system_arguments
    end

    def toggletip_id
      @toggletip_id ||= "toggletip-#{SecureRandom.hex(8)}"
    end

    def css_classes
      classes = ['cds--toggletip', "cds--popover--#{@align}"]
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--toggletip'
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
