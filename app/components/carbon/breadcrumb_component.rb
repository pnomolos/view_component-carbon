# frozen_string_literal: true

module Carbon
  class BreadcrumbComponent < Carbon::BaseComponent
    renders_many :items, 'Carbon::BreadcrumbComponent::ItemComponent'

    def initialize(no_trailing_slash: false, **system_arguments)
      @no_trailing_slash = no_trailing_slash
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--breadcrumb']
      classes << 'cds--breadcrumb--no-trailing-slash' if @no_trailing_slash
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    class ItemComponent < Carbon::BaseComponent
      attr_reader :href, :current

      def initialize(href: nil, current: false, **system_arguments)
        @href = href
        @current = current
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--breadcrumb-item']
        classes << 'cds--breadcrumb-item--current' if @current
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def link_css_classes
        'cds--link'
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:'aria-current'] = 'page' if @current
        attrs
      end
    end
  end
end
