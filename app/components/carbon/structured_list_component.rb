# frozen_string_literal: true

module Carbon
  class StructuredListComponent < Carbon::BaseComponent
    renders_one :header, 'Carbon::StructuredListComponent::HeaderComponent'
    renders_many :rows, 'Carbon::StructuredListComponent::RowComponent'

    def initialize(selection: false, **system_arguments)
      @selection = selection
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--structured-list']
      classes << 'cds--structured-list--selection' if @selection
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'table'
      attrs
    end

    class HeaderComponent < Carbon::BaseComponent
      renders_many :cells, 'Carbon::StructuredListComponent::HeaderCellComponent'

      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--structured-list-thead']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'rowgroup'
        attrs
      end
    end

    class RowComponent < Carbon::BaseComponent
      renders_many :cells, 'Carbon::StructuredListComponent::CellComponent'

      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--structured-list-row']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'row'
        attrs
      end
    end

    class CellComponent < Carbon::BaseComponent
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--structured-list-td']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'cell'
        attrs
      end
    end

    class HeaderCellComponent < Carbon::BaseComponent
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--structured-list-th']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'columnheader'
        attrs
      end
    end
  end
end
