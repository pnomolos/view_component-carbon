# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System ordered or unordered List.
  #
  # @example Basic usage
  #   render Carbon::ListComponent.new(ordered: false) do |list|
  #     list.with_item { "Item 1" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/list/usage/
  class ListComponent < Carbon::BaseComponent
    renders_many :items, 'Carbon::ListComponent::ItemComponent'

    # @param ordered [Boolean] renders as an ordered list
    # @param nested [Boolean] applies nested list styling
    # @param is_expressive [Boolean] applies expressive styling
    # @param native [Boolean] renders ordered lists with native numbering
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(ordered: false, nested: false, is_expressive: false, native: false, **system_arguments)
      @ordered = ordered
      @nested = nested
      @is_expressive = is_expressive
      @native = native
      @system_arguments = system_arguments
    end

    private

    def tag_name
      @ordered ? :ol : :ul
    end

    def css_classes
      classes = []
      classes << (@ordered ? 'cds--list--ordered' : 'cds--list--unordered')
      classes << 'cds--list--nested' if @nested
      classes << 'cds--list--expressive' if @is_expressive
      classes << 'cds--list--ordered--native' if @native && @ordered
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    # A single list item.
    class ItemComponent < Carbon::BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--list__item']
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
end
