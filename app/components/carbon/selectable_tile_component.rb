# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Selectable Tile (checkbox tile).
  #
  # @example Basic usage
  #   render Carbon::SelectableTileComponent.new(name: "opt", value: "1") { "Option 1" }
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class SelectableTileComponent < Carbon::BaseComponent
    TILE_COLOR_SCHEMES = %i[regular light].freeze
    DEFAULT_COLOR_SCHEME = :regular

    renders_one :decorator
    renders_one :ai_label

    # @return [Boolean] whether selected
    attr_reader :selected
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [String, nil] input name attribute
    attr_reader :name
    # @return [String, nil] input value
    attr_reader :value
    # @return [Symbol] color scheme
    attr_reader :color_scheme
    # @return [String, nil] aria-label for checkmark icon
    attr_reader :checkmark_label
    # @return [Boolean] whether to use rounded corners with AI label
    attr_reader :has_rounded_corners

    # @param selected [Boolean] initial selected state
    # @param disabled [Boolean] disables the tile
    # @param name [String, nil] input name attribute
    # @param value [String, nil] input value
    # @param color_scheme [Symbol] color scheme (:regular, :light)
    # @param checkmark_label [String, nil] aria-label for checkmark icon
    # @param has_rounded_corners [Boolean] whether to use rounded corners with AI label
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      selected: false,
      disabled: false,
      name: nil,
      value: nil,
      color_scheme: DEFAULT_COLOR_SCHEME,
      checkmark_label: nil,
      has_rounded_corners: false,
      **system_arguments
    )
      @selected = selected
      @disabled = disabled
      @name = name
      @value = value
      @color_scheme = validate_color_scheme(color_scheme)
      @checkmark_label = checkmark_label
      @has_rounded_corners = has_rounded_corners
      @system_arguments = system_arguments
    end

    private

    def tile_css_classes
      classes = %w[cds--tile cds--tile--selectable]
      classes << 'cds--tile--is-selected' if @selected
      classes << 'cds--tile--disabled' if @disabled
      classes << "cds--tile--#{@color_scheme}" if @color_scheme != DEFAULT_COLOR_SCHEME
      classes << 'cds--tile--slug-rounded' if ai_label? && @has_rounded_corners
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def tile_html_attributes
      attrs = {
        role: 'checkbox',
        'aria-checked': @selected.to_s,
        'data-controller': 'carbon--selectable-tile',
        'data-action': 'click->carbon--selectable-tile#toggle keydown->carbon--selectable-tile#handleKeydown',
        'data-carbon--selectable-tile-selected-value': @selected,
        'data-carbon--selectable-tile-name-value': @name,
        'data-carbon--selectable-tile-value-value': @value
      }
      attrs[:tabindex] = 0 unless @disabled
      if @disabled
        attrs[:disabled] = ''
        attrs['aria-disabled'] = 'true'
      end
      attrs[:name] = @name if @name
      attrs[:value] = @value if @value
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def checkmark_icon
      # Use checkmark--filled icon (Carbon's checkbox indicator)
      # When selected, the icon is filled; when unselected, it's empty (handled via CSS)
      icon_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">' \
                 '<path d="M8,1C4.1,1,1,4.1,1,8c0,3.9,3.1,7,7,7s7-3.1,7-7C15,4.1,11.9,1,8,1z ' \
                 'M7,11L4.3,8.3l0.9-0.8L7,9.3l4-3.9l0.9,0.8L7,11z"/>' \
                 '<path d="M7,11L4.3,8.3l0.9-0.8L7,9.3l4-3.9l0.9,0.8L7,11z" ' \
                 'data-icon-path="inner-path" opacity="0"/></svg>'

      if @checkmark_label
        # rubocop:disable Rails/OutputSafety
        %(<span aria-label="#{@checkmark_label}">#{icon_svg}</span>).html_safe
        # rubocop:enable Rails/OutputSafety
      else
        # rubocop:disable Rails/OutputSafety
        icon_svg.html_safe
        # rubocop:enable Rails/OutputSafety
      end
    end

    def validate_color_scheme(scheme)
      return DEFAULT_COLOR_SCHEME if scheme.nil?

      scheme_sym = scheme.to_sym
      unless TILE_COLOR_SCHEMES.include?(scheme_sym)
        raise ArgumentError, "Invalid color_scheme: #{scheme}. Must be one of #{TILE_COLOR_SCHEMES.join(', ')}"
      end

      scheme_sym
    end
  end
end
