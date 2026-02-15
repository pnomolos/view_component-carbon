# frozen_string_literal: true

module Carbon
  class ListComponent < Carbon::BaseComponent
    renders_many :items, 'Carbon::ListComponent::ItemComponent'

    def initialize(ordered: false, nested: false, **system_arguments)
      @ordered = ordered
      @nested = nested
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
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    class ItemComponent < Carbon::BaseComponent
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
