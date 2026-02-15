# frozen_string_literal: true

module Carbon
  class ToggletipComponent < BaseComponent
    include Carbon::Concerns::Popoverable

    renders_one :body

    attr_reader :align

    def initialize(align: DEFAULT_POPOVER_ALIGN, **system_arguments)
      @align = validate_popover_align(align)
      @system_arguments = system_arguments
    end

    def toggletip_id
      @toggletip_id ||= "toggletip-#{SecureRandom.hex(8)}"
    end

    def css_classes
      extra = []
      extra << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*popover_container_classes(
        base_class: 'cds--toggletip',
        align: @align,
        caret: true,
        drop_shadow: false,
        high_contrast: true,
        extra_classes: extra
      ))
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--toggletip'
      attrs
    end
  end
end
