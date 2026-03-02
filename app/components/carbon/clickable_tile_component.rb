# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Clickable Tile.
  #
  # @example Basic usage
  #   render Carbon::ClickableTileComponent.new(href: "/page") { "Tile content" }
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class ClickableTileComponent < Carbon::BaseComponent
    COLOR_SCHEMES = %i[regular light].freeze
    DEFAULT_COLOR_SCHEME = :regular

    # @return [String, nil] link URL
    attr_reader :href
    # @return [Boolean] whether the tile is disabled
    attr_reader :disabled
    # @return [String, nil] link target attribute
    attr_reader :target
    # @return [String, nil] link rel attribute
    attr_reader :rel
    # @return [Symbol] color scheme
    attr_reader :color_scheme
    # @return [Boolean] whether to use rounded corners
    attr_reader :has_rounded_corners

    # @param href [String, nil] link URL
    # @param disabled [Boolean] disables the tile
    # @param target [String, nil] link target attribute
    # @param rel [String, nil] link rel attribute
    # @param color_scheme [Symbol] color scheme (:regular, :light)
    # @param has_rounded_corners [Boolean] adds rounded corners
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(href: nil, disabled: false, target: nil, rel: nil, color_scheme: DEFAULT_COLOR_SCHEME,
                   has_rounded_corners: false, **system_arguments)
      @href = href
      @disabled = disabled
      @target = target
      @rel = rel
      @color_scheme = color_scheme.to_sym if color_scheme.is_a?(String)
      @color_scheme = color_scheme unless color_scheme.is_a?(String)
      @has_rounded_corners = has_rounded_corners

      unless COLOR_SCHEMES.include?(@color_scheme)
        valid_schemes = COLOR_SCHEMES.map(&:inspect).join(', ')
        raise ArgumentError, "Invalid color_scheme: #{@color_scheme.inspect}. Must be one of: #{valid_schemes}"
      end

      @system_arguments = system_arguments
    end

    # @return [Boolean] whether the tile renders as a link
    def link?
      @href.present?
    end

    private

    def css_classes
      classes = %w[cds--tile cds--tile--clickable]
      classes << 'cds--link' if link?
      classes << 'cds--tile--disabled' if @disabled
      classes << 'cds--tile--light' if @color_scheme == :light
      classes << 'cds--tile--slug-rounded' if @has_rounded_corners
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:tabindex] = @disabled ? '-1' : '0'
      attrs['aria-disabled'] = 'true' if @disabled

      if link?
        attrs[:href] = @href
        attrs[:target] = @target if @target
        attrs[:rel] = @rel if @rel
      else
        attrs[:role] = 'button'
      end

      attrs
    end

    def tag_name
      link? ? :a : :div
    end
  end
end
