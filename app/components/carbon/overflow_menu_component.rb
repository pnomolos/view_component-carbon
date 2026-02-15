# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Overflow Menu (three-dot menu).
  #
  # @example Basic usage
  #   render Carbon::OverflowMenuComponent.new do |menu|
  #     menu.with_item(text: "Edit")
  #   end
  #
  # @see https://carbondesignsystem.com/components/overflow-menu/usage/
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

    # @return [Symbol] menu size
    attr_reader :size
    # @return [Symbol] menu alignment
    attr_reader :align
    # @return [Boolean] whether the menu is flipped
    attr_reader :flipped
    # @return [String] accessible label for the trigger icon
    attr_reader :icon_description

    # @param size [Symbol] menu size (:xs, :sm, :md, :lg)
    # @param align [Symbol] menu alignment (:top, :bottom, :left, :right)
    # @param flipped [Boolean] flips the menu direction
    # @param icon_description [String] accessible label for the trigger
    # @param system_arguments [Hash] additional HTML attributes
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

    # A single overflow menu item.
    class ItemComponent < Carbon::BaseComponent
      # @return [String] item text
      attr_reader :text
      # @return [String, nil] link URL
      attr_reader :href
      # @return [Boolean] whether disabled
      attr_reader :disabled
      # @return [Boolean] whether this is a danger item
      attr_reader :danger

      # @param text [String] item text
      # @param href [String, nil] link URL
      # @param disabled [Boolean] disables the item
      # @param danger [Boolean] applies danger styling
      # @param system_arguments [Hash] additional HTML attributes
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
