# frozen_string_literal: true

module Carbon
  class PopoverComponent < BaseComponent
    include Carbon::Concerns::Popoverable

    renders_one :body

    attr_reader :align, :open, :caret, :drop_shadow, :high_contrast

    def initialize(align: DEFAULT_POPOVER_ALIGN, open: false, caret: true, drop_shadow: true,
                   high_contrast: false, **system_arguments)
      @align = validate_popover_align(align)
      @open = open
      @caret = caret
      @drop_shadow = drop_shadow
      @high_contrast = high_contrast
      @system_arguments = system_arguments
    end

    def css_classes
      extra = []
      extra << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*popover_container_classes(
        base_class: nil,
        align: @align,
        caret: @caret,
        drop_shadow: @drop_shadow,
        high_contrast: @high_contrast,
        open: @open,
        extra_classes: extra
      ))
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--popover'
      attrs
    end
  end
end
