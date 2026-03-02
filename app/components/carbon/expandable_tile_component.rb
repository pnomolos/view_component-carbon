# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Expandable Tile.
  #
  # @example Basic usage
  #   render Carbon::ExpandableTileComponent.new do |tile|
  #     tile.with_above_the_fold { "Visible content" }
  #     tile.with_below_the_fold { "Hidden content" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class ExpandableTileComponent < Carbon::BaseComponent
    COLOR_SCHEMES = %i[regular light].freeze
    DEFAULT_COLOR_SCHEME = :regular

    renders_one :above_the_fold
    renders_one :below_the_fold

    # @return [Boolean] whether the tile is expanded
    attr_reader :expanded
    # @return [String] accessible text when collapsed
    attr_reader :tile_collapsed_icon_text
    # @return [String] accessible text when expanded
    attr_reader :tile_expanded_icon_text
    # @return [String] unique tile ID
    attr_reader :tile_id
    # @return [Symbol] color scheme
    attr_reader :color_scheme
    # @return [Boolean] whether tile content has interactive elements
    attr_reader :with_interactive
    # @return [Boolean] whether to use rounded corners
    attr_reader :has_rounded_corners

    # @param expanded [Boolean] initial expanded state
    # @param tile_collapsed_icon_text [String] accessible text when collapsed
    # @param tile_expanded_icon_text [String] accessible text when expanded
    # @param id [String, nil] unique tile ID
    # @param color_scheme [Symbol] color scheme (:regular, :light)
    # @param with_interactive [Boolean] tile content has interactive elements
    # @param has_rounded_corners [Boolean] adds rounded corners
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      expanded: false,
      tile_collapsed_icon_text: 'Interact to expand tile',
      tile_expanded_icon_text: 'Interact to collapse tile',
      id: nil,
      color_scheme: DEFAULT_COLOR_SCHEME,
      with_interactive: false,
      has_rounded_corners: false,
      **system_arguments
    )
      @expanded = expanded
      @tile_collapsed_icon_text = tile_collapsed_icon_text
      @tile_expanded_icon_text = tile_expanded_icon_text
      @tile_id = id || "expandable-tile-#{SecureRandom.hex(4)}"
      @color_scheme = color_scheme.to_sym if color_scheme.is_a?(String)
      @color_scheme = color_scheme unless color_scheme.is_a?(String)
      @with_interactive = with_interactive
      @has_rounded_corners = has_rounded_corners

      unless COLOR_SCHEMES.include?(@color_scheme)
        valid_schemes = COLOR_SCHEMES.map(&:inspect).join(', ')
        raise ArgumentError, "Invalid color_scheme: #{@color_scheme.inspect}. Must be one of: #{valid_schemes}"
      end

      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = %w[cds--tile cds--tile--expandable]
      classes << 'cds--tile--is-expanded' if @expanded
      classes << 'cds--tile--light' if @color_scheme == :light
      classes << 'cds--tile--slug-rounded' if @has_rounded_corners
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def tile_content_classes
      classes = ['cds--tile-content']
      classes << 'cds--tile-content__has-interactive-content' if @with_interactive
      class_names(classes)
    end

    def chevron_classes
      classes = ['cds--tile__chevron']
      classes << 'cds--tile__chevron--interactive' if @with_interactive
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:id] = @tile_id
      attrs['data-controller'] = 'carbon--expandable-tile'
      attrs['data-carbon--expandable-tile-expanded-value'] = @expanded.to_s
      attrs['data-carbon--expandable-tile-collapsed-text-value'] = @tile_collapsed_icon_text
      attrs['data-carbon--expandable-tile-expanded-text-value'] = @tile_expanded_icon_text
      attrs
    end

    def below_fold_id
      "#{@tile_id}-below"
    end

    def current_aria_label
      @expanded ? @tile_expanded_icon_text : @tile_collapsed_icon_text
    end

    def chevron_svg
      '<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">' \
        '<path d="M8 11L3 6l.7-.7L8 9.6l4.3-4.3.7.7z" fill="currentColor"/></svg>'
    end
  end
end
