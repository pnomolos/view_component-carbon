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
    # @return [Boolean] whether the accordion is flush
    attr_reader :is_flush
    # @return [Boolean] whether the accordion is disabled
    attr_reader :disabled
    # @return [Boolean] whether to render as ordered list
    attr_reader :ordered

    # @param align [Symbol] chevron alignment (:start, :end)
    # @param size [Symbol] accordion size (:sm, :md, :lg)
    # @param is_flush [Boolean] renders flush variant (no left padding)
    # @param disabled [Boolean] disables the accordion
    # @param ordered [Boolean] renders as ordered list (ol) instead of unordered (ul)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(align: DEFAULT_ALIGN, size: DEFAULT_SIZE, is_flush: false, disabled: false, ordered: false,
                   **system_arguments)
      @align = validate_argument(:align, align, ALIGNS, DEFAULT_ALIGN)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @is_flush = is_flush
      @disabled = disabled
      @ordered = ordered
      @system_arguments = system_arguments
    end

    # @return [Symbol] the HTML tag to use for the list container
    def list_tag
      @ordered ? :ol : :ul
    end

    private

    def css_classes
      classes = ['cds--accordion']
      classes << "cds--accordion--#{@align}" if @align != DEFAULT_ALIGN
      classes << "cds--accordion--#{@size}" if @size != DEFAULT_SIZE
      classes << 'cds--accordion--flush' if @is_flush && @align != :start
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
      # @return [Boolean] whether the item is disabled
      attr_reader :disabled
      # @return [String] unique panel ID for accessibility
      attr_reader :panel_id

      # @param title [String] the item heading text
      # @param open [Boolean] whether the item is initially expanded
      # @param disabled [Boolean] whether the item is disabled
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(title:, open: false, disabled: false, **system_arguments)
        @title = title
        @open = open
        @disabled = disabled
        @system_arguments = system_arguments
        @panel_id = "accordion-panel-#{SecureRandom.hex(8)}"
      end

      private

      def css_classes
        classes = ['cds--accordion__item']
        classes << 'cds--accordion__item--active' if @open
        classes << 'cds--accordion__item--disabled' if @disabled
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
