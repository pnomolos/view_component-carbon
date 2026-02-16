# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Tile (static container).
  #
  # @example Basic usage
  #   render Carbon::TileComponent.new { "Tile content" }
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class TileComponent < Carbon::BaseComponent
    COLOR_SCHEMES = %i[regular light].freeze
    DEFAULT_COLOR_SCHEME = :regular

    # @return [Symbol] color scheme
    attr_reader :color_scheme

    # @param color_scheme [Symbol] color scheme (:regular, :light)
    # @param light [Boolean] (deprecated) uses the light color variant, use color_scheme instead
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(color_scheme: DEFAULT_COLOR_SCHEME, light: false, **system_arguments)
      # Support legacy light parameter as alias
      @color_scheme = light ? :light : color_scheme
      @color_scheme = @color_scheme.to_sym if @color_scheme.is_a?(String)

      unless COLOR_SCHEMES.include?(@color_scheme)
        valid_schemes = COLOR_SCHEMES.map(&:inspect).join(', ')
        raise ArgumentError, "Invalid color_scheme: #{@color_scheme.inspect}. Must be one of: #{valid_schemes}"
      end

      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--tile']
      classes << 'cds--tile--light' if @color_scheme == :light
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
