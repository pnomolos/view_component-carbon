# frozen_string_literal: true

module Carbon
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

    attr_reader :size, :open

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

    class ItemComponent < Carbon::BaseComponent
      attr_reader :label, :disabled, :danger, :shortcut

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

    class DividerComponent < Carbon::BaseComponent
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

      attr_reader :label

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
