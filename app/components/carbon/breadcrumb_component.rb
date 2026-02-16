# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Breadcrumb navigation trail.
  #
  # @example Basic usage
  #   render Carbon::BreadcrumbComponent.new do |bc|
  #     bc.with_item(href: "/") { "Home" }
  #     bc.with_item(current: true) { "Current" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/breadcrumb/usage/
  class BreadcrumbComponent < Carbon::BaseComponent
    SIZES = %i[sm md].freeze
    DEFAULT_SIZE = :md

    renders_many :items, 'Carbon::BreadcrumbComponent::ItemComponent'

    # @param no_trailing_slash [Boolean] hides the trailing slash
    # @param size [Symbol] size variant (:sm, :md)
    # @param aria_label [String] aria-label for the nav element
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(no_trailing_slash: false, size: DEFAULT_SIZE, aria_label: 'Breadcrumb', **system_arguments)
      @no_trailing_slash = no_trailing_slash
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @aria_label = aria_label
      @system_arguments = system_arguments
    end

    private

    attr_reader :aria_label

    def css_classes
      classes = ['cds--breadcrumb']
      classes << 'cds--breadcrumb--no-trailing-slash' if @no_trailing_slash
      classes << 'cds--breadcrumb--sm' if @size == :sm
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # A single breadcrumb item.
    class ItemComponent < Carbon::BaseComponent
      # @return [String, nil] link URL
      attr_reader :href
      # @return [Boolean] whether this is the current page
      attr_reader :current

      # @param href [String, nil] link URL
      # @param current [Boolean] marks item as the current page
      # @param system_arguments [Hash] additional HTML attributes
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
