# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Toggletip (interactive tooltip).
  #
  # @example Basic usage
  #   render Carbon::ToggletipComponent.new do |t|
  #     t.with_body { "Toggletip content" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/toggletip/usage/
  class ToggletipComponent < BaseComponent
    include Carbon::Concerns::Popoverable

    renders_one :body

    # @return [Symbol] toggletip alignment
    attr_reader :align

    # @param align [Symbol] toggletip alignment direction
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(align: DEFAULT_POPOVER_ALIGN, **system_arguments)
      @align = validate_popover_align(align)
      @system_arguments = system_arguments
    end

    # @return [String] unique toggletip ID
    def toggletip_id
      @toggletip_id ||= "toggletip-#{SecureRandom.hex(8)}"
    end

    # @return [String] CSS class string
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

    # @return [Hash] HTML attributes for the toggletip element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--toggletip'
      attrs
    end
  end
end
