# frozen_string_literal: true

module Carbon
  class TileGroupComponent < Carbon::BaseComponent
    renders_many :tiles, lambda { |**args|
      Carbon::RadioTileComponent.new(
        name: @name,
        disabled: @disabled || args.delete(:disabled) || false,
        checked: args[:value].to_s == @default_selected.to_s,
        **args
      )
    }

    attr_reader :name, :legend, :disabled, :default_selected

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
