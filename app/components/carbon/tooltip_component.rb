# frozen_string_literal: true

module Carbon
  class TooltipComponent < BaseComponent
    include Carbon::Concerns::Popoverable

    attr_reader :label, :align, :description

    def initialize(label:, align: DEFAULT_POPOVER_ALIGN, description: nil, **system_arguments)
      @label = label
      @align = validate_popover_align(align)
      @description = description
      @system_arguments = system_arguments
    end

    def tooltip_id
      @tooltip_id ||= "tooltip-#{SecureRandom.hex(8)}"
    end

    def css_classes
      extra = []
      extra << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*popover_container_classes(
        base_class: 'cds--tooltip',
        align: @align,
        caret: true,
        drop_shadow: true,
        extra_classes: extra
      ))
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--tooltip'
      attrs
    end
  end
end
