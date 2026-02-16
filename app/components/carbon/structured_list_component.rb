# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Structured List.
  #
  # @example Basic usage
  #   render Carbon::StructuredListComponent.new do |list|
  #     list.with_header { |h| h.with_cell { "Column" } }
  #     list.with_row { |r| r.with_cell { "Value" } }
  #   end
  #
  # @see https://carbondesignsystem.com/components/structured-list/usage/
  class StructuredListComponent < Carbon::BaseComponent
    renders_one :header, 'Carbon::StructuredListComponent::HeaderComponent'
    renders_many :rows, 'Carbon::StructuredListComponent::RowComponent'

    # @param selection [Boolean] enables row selection mode
    # @param system_arguments [Hash] additional HTML attributes
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

    # Structured list header row.
    class HeaderComponent < Carbon::BaseComponent
      renders_many :cells, 'Carbon::StructuredListComponent::HeaderCellComponent'

      # @param system_arguments [Hash] additional HTML attributes
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

    # Structured list body row.
    class RowComponent < Carbon::BaseComponent
      renders_many :cells, 'Carbon::StructuredListComponent::CellComponent'

      # @param system_arguments [Hash] additional HTML attributes
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

    # Structured list body cell.
    class CellComponent < Carbon::BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
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

    # Structured list header cell.
    class HeaderCellComponent < Carbon::BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
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
