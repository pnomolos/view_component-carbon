# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Tile Group (radio tile group).
  #
  # @example Basic usage
  #   render Carbon::TileGroupComponent.new(name: "opt") do |g|
  #     g.with_tile(value: "a") { "Option A" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/tile/usage/
  class TileGroupComponent < Carbon::BaseComponent
    renders_many :tiles, lambda { |**args|
      Carbon::RadioTileComponent.new(
        name: @name,
        disabled: @disabled || args.delete(:disabled) || false,
        checked: args[:value].to_s == @default_selected.to_s,
        **args
      )
    }

    # @return [String] input name shared by all tiles
    attr_reader :name
    # @return [String, nil] fieldset legend text
    attr_reader :legend
    # @return [Boolean] whether the group is disabled
    attr_reader :disabled
    # @return [String, nil] default selected tile value
    attr_reader :default_selected

    # @param name [String] input name shared by all tiles
    # @param legend [String, nil] fieldset legend text
    # @param disabled [Boolean] disables all tiles
    # @param default_selected [String, nil] value of the initially selected tile
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(name:, legend: nil, disabled: false, default_selected: nil, **system_arguments)
      @name = name
      @legend = legend
      @disabled = disabled
      @default_selected = default_selected
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--tile-group']
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs['data-controller'] = 'carbon--tile-group'
      attrs
    end
  end
end
