# frozen_string_literal: true

module Carbon
  class PopoverComponent < BaseComponent
    ALIGNMENTS = %i[top bottom left right].freeze
    DEFAULT_ALIGNMENT = :bottom

    renders_one :body

    attr_reader :align, :open, :caret, :drop_shadow, :high_contrast

    def initialize(align: DEFAULT_ALIGNMENT, open: false, caret: true, drop_shadow: true,
                   high_contrast: false, **system_arguments)
      @align = validate_argument(:align, align, ALIGNMENTS, DEFAULT_ALIGNMENT)
      @open = open
      @caret = caret
      @drop_shadow = drop_shadow
      @high_contrast = high_contrast
      @system_arguments = system_arguments
    end

    def popover_id
      @popover_id ||= "popover-#{SecureRandom.hex(8)}"
    end

    def css_classes
      classes = ['cds--popover-container', "cds--popover--#{@align}"]
      classes << 'cds--popover--drop-shadow' if @drop_shadow
      classes << 'cds--popover--high-contrast' if @high_contrast
      classes << 'cds--popover--open' if @open
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--popover'
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
