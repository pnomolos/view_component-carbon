# frozen_string_literal: true

module Carbon
  class AccordionComponent < Carbon::BaseComponent
    ALIGNS = %i[start end].freeze
    SIZES = %i[sm md lg].freeze

    DEFAULT_ALIGN = :end
    DEFAULT_SIZE = :md

    renders_many :items, 'Carbon::AccordionComponent::ItemComponent'

    attr_reader :align, :size

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

    class ItemComponent < Carbon::BaseComponent
      attr_reader :title, :open, :panel_id

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
