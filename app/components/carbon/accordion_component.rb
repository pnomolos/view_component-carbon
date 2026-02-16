# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Accordion with expandable items.
  #
  # @example Basic usage
  #   render Carbon::AccordionComponent.new do |accordion|
  #     accordion.with_item(title: "Section 1") { "Content" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/accordion/usage/
  class AccordionComponent < Carbon::BaseComponent
    ALIGNS = %i[start end].freeze
    SIZES = %i[sm md lg].freeze

    DEFAULT_ALIGN = :end
    DEFAULT_SIZE = :md

    renders_many :items, 'Carbon::AccordionComponent::ItemComponent'

    # @return [Symbol] chevron alignment
    attr_reader :align
    # @return [Symbol] accordion size
    attr_reader :size

    # @param align [Symbol] chevron alignment (:start, :end)
    # @param size [Symbol] accordion size (:sm, :md, :lg)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(align: DEFAULT_ALIGN, size: DEFAULT_SIZE, **system_arguments)
      @align = validate_argument(:align, align, ALIGNS, DEFAULT_ALIGN)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--accordion']
      classes << "cds--accordion--#{@align}" if @align != DEFAULT_ALIGN
      classes << "cds--accordion--#{@size}" if @size != DEFAULT_SIZE
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

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # A single expandable item within an Accordion.
    class ItemComponent < Carbon::BaseComponent
      # @return [String] the item title
      attr_reader :title
      # @return [Boolean] whether the item is expanded
      attr_reader :open
      # @return [String] unique panel ID for accessibility
      attr_reader :panel_id

      # @param title [String] the item heading text
      # @param open [Boolean] whether the item is initially expanded
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(title:, open: false, **system_arguments)
        @title = title
        @open = open
        @system_arguments = system_arguments
        @panel_id = "accordion-panel-#{SecureRandom.hex(8)}"
      end

      private

      def css_classes
        classes = ['cds--accordion__item']
        classes << 'cds--accordion__item--active' if @open
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs['data-controller'] = 'carbon--accordion-item'
        attrs
      end
    end
  end
end
