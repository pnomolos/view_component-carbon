# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Tile (static container).
  #
  # @example Basic usage
  #   render Carbon::TileComponent.new { "Tile content" }
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class TileComponent < Carbon::BaseComponent
    # @return [Boolean] whether to use light variant
    attr_reader :light

    # @param light [Boolean] uses the light color variant
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(light: false, **system_arguments)
      @light = light
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--tile']
      classes << 'cds--tile--light' if @light
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end
  end
end
