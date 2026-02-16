# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Tooltip.
  #
  # @example Basic usage
  #   render Carbon::TooltipComponent.new(label: "More info", description: "Details here")
  #
  # @see https://carbondesignsystem.com/components/tooltip/usage/
  class TooltipComponent < BaseComponent
    include Carbon::Concerns::Popoverable

    # @return [String] tooltip trigger label
    attr_reader :label
    # @return [Symbol] tooltip alignment
    attr_reader :align
    # @return [String, nil] tooltip description text
    attr_reader :description

    # @param label [String] trigger label text
    # @param align [Symbol] tooltip alignment direction
    # @param description [String, nil] tooltip description text
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(label:, align: DEFAULT_POPOVER_ALIGN, description: nil, **system_arguments)
      @label = label
      @align = validate_popover_align(align)
      @description = description
      @system_arguments = system_arguments
    end

    # @return [String] unique tooltip ID
    def tooltip_id
      @tooltip_id ||= "tooltip-#{SecureRandom.hex(8)}"
    end

    # @return [String] CSS class string
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

    # @return [Hash] HTML attributes for the tooltip element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--tooltip'
      attrs
    end
  end
end
