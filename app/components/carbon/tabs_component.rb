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
    ACTIVATION_MODES = %i[automatic manual].freeze
    DEFAULT_ACTIVATION = :automatic

    renders_many :tabs, lambda { |label:,
                                   selected: false,
                                   disabled: false,
                                   dismissable: false,
                                   **system_arguments,
                                   &content_block|
      TabData.new(
        label: label,
        selected: selected,
        disabled: disabled,
        dismissable: dismissable,
        system_arguments: system_arguments,
        content_block: content_block
      )
    }

    # @return [Symbol] tabs type
    attr_reader :type
    # @return [Symbol] keyboard activation mode
    attr_reader :activation
    # @return [Boolean] whether tabs are dismissable
    attr_reader :dismissable
    # @return [String] aria-label for tablist
    attr_reader :aria_label
    # @return [Boolean] whether to auto-scroll to selected tab
    attr_reader :scroll_into_view
    # @return [String] assistive text for selecting items
    attr_reader :selecting_items_text
    # @return [String] assistive text for selected item
    attr_reader :selected_item_text

    # @param type [Symbol] tabs type (:default, :contained)
    # @param activation [Symbol] keyboard activation mode (:automatic, :manual)
    # @param dismissable [Boolean] whether tabs can be closed
    # @param aria_label [String] accessible label for tab list
    # @param scroll_into_view [Boolean] whether to scroll to selected tab
    # @param selecting_items_text [String] assistive text when navigating
    # @param selected_item_text [String] assistive text when item selected
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      type: DEFAULT_TYPE,
      activation: DEFAULT_ACTIVATION,
      dismissable: false,
      contained: false,
      aria_label: 'Tab navigation',
      scroll_into_view: true,
      selecting_items_text: 'Selecting items. Use left and right arrow keys to navigate.',
      selected_item_text: 'Selected an item.',
      **system_arguments
    )
      type = :contained if contained
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @activation = validate_argument(:activation, activation, ACTIVATION_MODES, DEFAULT_ACTIVATION)
      @dismissable = dismissable
      @aria_label = aria_label
      @scroll_into_view = scroll_into_view
      @selecting_items_text = selecting_items_text
      @selected_item_text = selected_item_text
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--tabs']
      classes << 'cds--tabs--contained' if @type == :contained
      classes << 'cds--tabs--dismissable' if @dismissable
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def wrapper_attributes
      attrs = @system_arguments.except(:class).dup
      attrs['data-controller'] = 'carbon--tabs'
      attrs['data-carbon--tabs-activation-value'] = @activation.to_s
      attrs['data-carbon--tabs-scroll-into-view-value'] = @scroll_into_view.to_s
      attrs['data-selecting-items-text'] = @selecting_items_text
      attrs['data-selected-item-text'] = @selected_item_text
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
      # @return [Boolean] whether dismissable
      attr_reader :dismissable
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
      # @param dismissable [Boolean] whether dismissable
      # @param system_arguments [Hash] additional HTML attributes
      # @param content_block [Proc, nil] block for panel content
      def initialize(label:, selected:, disabled:, dismissable:, system_arguments:, content_block:)
        @label = label
        @selected = selected
        @disabled = disabled
        @dismissable = dismissable
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
