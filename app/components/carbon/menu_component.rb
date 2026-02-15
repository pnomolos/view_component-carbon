# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Menu with items, dividers, and groups.
  #
  # @example Basic usage
  #   render Carbon::MenuComponent.new(open: true) do |menu|
  #     menu.with_item(label: "Edit")
  #   end
  #
  # @see https://carbondesignsystem.com/components/menu/usage/
  class MenuComponent < Carbon::BaseComponent
    SIZES = %i[xs sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :items, types: {
      item: {
        renders: lambda { |label:, disabled: false, danger: false, shortcut: nil, **system_arguments|
          Carbon::MenuComponent::ItemComponent.new(
            label: label,
            disabled: disabled,
            danger: danger,
            shortcut: shortcut,
            **system_arguments
          )
        },
        as: :item
      },
      divider: {
        renders: lambda { |**system_arguments|
          Carbon::MenuComponent::DividerComponent.new(**system_arguments)
        },
        as: :divider
      },
      group: {
        renders: lambda { |label:, **system_arguments|
          Carbon::MenuComponent::GroupComponent.new(label: label, **system_arguments)
        },
        as: :group
      }
    }

    # @return [Symbol] menu size
    attr_reader :size
    # @return [Boolean] whether the menu is open
    attr_reader :open

    # @param size [Symbol] menu size (:xs, :sm, :md, :lg)
    # @param open [Boolean] whether the menu is open
    # @param label [String, nil] accessible label
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(size: DEFAULT_SIZE, open: false, label: nil, **system_arguments)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @open = open
      @label = label
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--menu']
      classes << "cds--menu--#{@size}"
      classes << 'cds--menu--open' if @open
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'menu'
      attrs[:tabindex] = '-1'
      attrs['data-controller'] = 'carbon--menu'
      attrs['aria-label'] = @label if @label
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # A single menu item.
    class ItemComponent < Carbon::BaseComponent
      # @return [String] item label
      attr_reader :label
      # @return [Boolean] whether disabled
      attr_reader :disabled
      # @return [Boolean] whether this is a danger item
      attr_reader :danger
      # @return [String, nil] keyboard shortcut text
      attr_reader :shortcut

      # @param label [String] item label
      # @param disabled [Boolean] disables the item
      # @param danger [Boolean] applies danger styling
      # @param shortcut [String, nil] keyboard shortcut text
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(label:, disabled: false, danger: false, shortcut: nil, **system_arguments)
        @label = label
        @disabled = disabled
        @danger = danger
        @shortcut = shortcut
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--menu-item']
        classes << 'cds--menu-item--danger' if @danger
        classes << 'cds--menu-item--disabled' if @disabled
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'menuitem'
        attrs[:tabindex] = '-1'
        attrs['aria-disabled'] = 'true' if @disabled
        attrs
      end
    end

    # A visual divider between menu items.
    class DividerComponent < Carbon::BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--menu-item-divider']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'separator'
        attrs
      end
    end

    # A labeled group of menu items.
    class GroupComponent < Carbon::BaseComponent
      renders_many :items, lambda { |label:, disabled: false, danger: false, shortcut: nil, **system_arguments|
        Carbon::MenuComponent::ItemComponent.new(
          label: label,
          disabled: disabled,
          danger: danger,
          shortcut: shortcut,
          **system_arguments
        )
      }

      # @return [String] group label
      attr_reader :label

      # @param label [String] group label
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(label:, **system_arguments)
        @label = label
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--menu-item-group']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'group'
        attrs['aria-label'] = @label
        attrs
      end
    end
  end
end
