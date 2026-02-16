# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Tabs component.
  #
  # @example Basic usage
  #   render Carbon::TabsComponent.new do |tabs|
  #     tabs.with_tab(label: "Tab 1", selected: true) { "Content 1" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/tabs/usage/
  class TabsComponent < Carbon::BaseComponent
    TYPES = %i[default contained].freeze
    DEFAULT_TYPE = :default

    renders_many :tabs, lambda { |label:, selected: false, disabled: false, **system_arguments, &content_block|
      TabData.new(
        label: label,
        selected: selected,
        disabled: disabled,
        system_arguments: system_arguments,
        content_block: content_block
      )
    }

    # @return [Symbol] tabs type
    attr_reader :type

    # @param type [Symbol] tabs type (:default, :contained)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(type: DEFAULT_TYPE, **system_arguments)
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--tabs']
      classes << 'cds--tabs--contained' if @type == :contained
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def wrapper_attributes
      attrs = @system_arguments.except(:class).dup
      attrs['data-controller'] = 'carbon--tabs'
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    def button_css_classes(tab_data)
      classes = %w[cds--tabs__nav-item cds--tabs__nav-link]
      classes << 'cds--tabs__nav-item--selected' if tab_data.selected
      classes << 'cds--tabs__nav-item--disabled' if tab_data.disabled
      classes
    end

    def panel_css_classes(tab_data)
      classes = ['cds--tab-content']
      classes << tab_data.system_arguments[:class] if tab_data.system_arguments[:class]
      class_names(classes)
    end

    # Data holder for tab slot content.
    class TabData < ViewComponent::Base
      # @return [String] tab label
      attr_reader :label
      # @return [Boolean] whether selected
      attr_reader :selected
      # @return [Boolean] whether disabled
      attr_reader :disabled
      # @return [Hash] additional HTML attributes
      attr_reader :system_arguments
      # @return [Proc, nil] block that produces tab panel content
      attr_reader :content_block
      # @return [String] unique tab ID
      attr_reader :tab_id
      # @return [String] unique panel ID
      attr_reader :panel_id

      # @param label [String] tab label
      # @param selected [Boolean] whether selected
      # @param disabled [Boolean] whether disabled
      # @param system_arguments [Hash] additional HTML attributes
      # @param content_block [Proc, nil] block for panel content
      def initialize(label:, selected:, disabled:, system_arguments:, content_block:)
        @label = label
        @selected = selected
        @disabled = disabled
        @system_arguments = system_arguments
        @content_block = content_block
        @tab_id = "tab-#{SecureRandom.hex(8)}"
        @panel_id = "panel-#{SecureRandom.hex(8)}"
        super()
      end

      # @return [String, nil] rendered panel content
      def content
        @content_block&.call
      end

      def call
        # This component doesn't render itself, it's just a data holder
        nil
      end
    end
  end
end
