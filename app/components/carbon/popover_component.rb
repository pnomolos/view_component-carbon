# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Popover.
  #
  # @example Basic usage
  #   render Carbon::PopoverComponent.new(open: true) do |p|
  #     p.with_body { "Popover content" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/popover/usage/
  class PopoverComponent < BaseComponent
    include Carbon::Concerns::Popoverable

    renders_one :body

    # @return [Symbol] popover alignment
    attr_reader :align
    # @return [Boolean] whether the popover is open
    attr_reader :open
    # @return [Boolean] whether to show a caret
    attr_reader :caret
    # @return [Boolean] whether to show a drop shadow
    attr_reader :drop_shadow
    # @return [Boolean] whether to use high-contrast styling
    attr_reader :high_contrast

    # @param align [Symbol] popover alignment direction
    # @param open [Boolean] initial open state
    # @param caret [Boolean] shows a caret arrow
    # @param drop_shadow [Boolean] shows a drop shadow
    # @param high_contrast [Boolean] uses high-contrast styling
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(align: DEFAULT_POPOVER_ALIGN, open: false, caret: true, drop_shadow: true,
                   high_contrast: false, **system_arguments)
      @align = validate_popover_align(align)
      @open = open
      @caret = caret
      @drop_shadow = drop_shadow
      @high_contrast = high_contrast
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string
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

    # @return [Hash] HTML attributes for the popover element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--popover'
      attrs
    end
  end
end
