# frozen_string_literal: true

module Carbon
  class TileComponent < Carbon::BaseComponent
    attr_reader :light

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
