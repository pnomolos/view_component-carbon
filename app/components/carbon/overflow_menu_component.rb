# frozen_string_literal: true

module Carbon
  class OverflowMenuComponent < Carbon::BaseComponent
    SIZES = %i[xs sm md lg].freeze
    ALIGNS = %i[top bottom left right].freeze
    DEFAULT_SIZE = :md
    DEFAULT_ALIGN = :bottom

    renders_many :items, lambda { |text:, href: nil, disabled: false, danger: false, **system_arguments|
      Carbon::OverflowMenuComponent::ItemComponent.new(
        text: text,
        href: href,
        disabled: disabled,
        danger: danger,
        **system_arguments
      )
    }

    attr_reader :size, :align, :flipped, :icon_description

    def initialize(size: DEFAULT_SIZE, align: DEFAULT_ALIGN, flipped: false,
                   icon_description: 'Options', **system_arguments)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @align = validate_argument(:align, align, ALIGNS, DEFAULT_ALIGN)
      @flipped = flipped
      @icon_description = icon_description
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--overflow-menu']
      classes << "cds--overflow-menu--#{@size}" if @size != DEFAULT_SIZE
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def menu_css_classes
      classes = ['cds--overflow-menu-options']
      classes << "cds--overflow-menu-options--#{@align}" if @align != DEFAULT_ALIGN
      classes << 'cds--overflow-menu--flip' if @flipped
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs['data-controller'] = 'carbon--overflow-menu'
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    class ItemComponent < Carbon::BaseComponent
      attr_reader :text, :href, :disabled, :danger

      def initialize(text:, href: nil, disabled: false, danger: false, **system_arguments)
        @text = text
        @href = href
        @disabled = disabled
        @danger = danger
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--overflow-menu-options__option']
        classes << 'cds--overflow-menu-options__option--danger' if @danger
        classes << 'cds--overflow-menu-options__option--disabled' if @disabled
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
