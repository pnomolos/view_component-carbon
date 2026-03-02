# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Radio Tile (selectable tile with radio behavior).
  #
  # @example Basic usage
  #   render Carbon::RadioTileComponent.new(value: "opt1", name: "options") { "Option 1" }
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class RadioTileComponent < Carbon::BaseComponent
    COLOR_SCHEMES = %i[regular light].freeze
    DEFAULT_COLOR_SCHEME = :regular

    # @return [String] input value
    attr_reader :value
    # @return [Boolean] whether checked
    attr_reader :checked
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [String] unique input ID
    attr_reader :input_id
    # @return [String, nil] input name attribute
    attr_reader :name
    # @return [Symbol] color scheme
    attr_reader :color_scheme
    # @return [String] checkmark label for accessibility
    attr_reader :checkmark_label
    # @return [Boolean] whether to use rounded corners
    attr_reader :has_rounded_corners

    # @param value [String] input value
    # @param checked [Boolean] initial checked state
    # @param disabled [Boolean] disables the tile
    # @param id [String, nil] unique input ID
    # @param name [String, nil] input name attribute
    # @param color_scheme [Symbol] color scheme (:regular, :light)
    # @param checkmark_label [String] accessible label for checkmark
    # @param has_rounded_corners [Boolean] adds rounded corners
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(value:, checked: false, disabled: false, id: nil, name: nil, color_scheme: DEFAULT_COLOR_SCHEME,
                   checkmark_label: 'Tile checkmark', has_rounded_corners: false, **system_arguments)
      @value = value
      @checked = checked
      @disabled = disabled
      @input_id = id || "radio-tile-#{SecureRandom.hex(4)}"
      @name = name
      @color_scheme = color_scheme.to_sym if color_scheme.is_a?(String)
      @color_scheme = color_scheme unless color_scheme.is_a?(String)
      @checkmark_label = checkmark_label
      @has_rounded_corners = has_rounded_corners

      unless COLOR_SCHEMES.include?(@color_scheme)
        valid_schemes = COLOR_SCHEMES.map(&:inspect).join(', ')
        raise ArgumentError, "Invalid color_scheme: #{@color_scheme.inspect}. Must be one of: #{valid_schemes}"
      end

      @system_arguments = system_arguments
    end

    private

    def label_css_classes
      classes = %w[cds--tile cds--tile--selectable cds--tile--radio]
      classes << 'cds--tile--is-selected' if @checked
      classes << 'cds--tile--disabled' if @disabled
      classes << 'cds--tile--light' if @color_scheme == :light
      classes << 'cds--tile--slug-rounded' if @has_rounded_corners
      class_names(classes)
    end

    def checkmark_svg
      '<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">' \
        "<title>#{@checkmark_label}</title>" \
        '<path d="M8 1C4.1 1 1 4.1 1 8s3.1 7 7 7 7-3.1 7-7-3.1-7-7-7zm3.7 5.3l-4.2 4.2c-.2.2-.5.2-.7 ' \
        '0L4.3 8c-.2-.2-.2-.5 0-.7.2-.2.5-.2.7 0L7.1 9.4l3.8-3.8c.2-.2.5-.2.7 0 .2.2.2.5 0 .7z" ' \
        'fill="currentColor"/></svg>'
    end
  end
end
