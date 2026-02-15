# frozen_string_literal: true

module Carbon
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

    attr_reader :type

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

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
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
      classes = ['cds--tabs__nav-link']
      classes << 'cds--tabs__nav-link--disabled' if tab_data.disabled
      classes
    end

    def panel_css_classes(tab_data)
      classes = ['cds--tab-content']
      classes << tab_data.system_arguments[:class] if tab_data.system_arguments[:class]
      class_names(classes)
    end

    # Simple component to hold tab data
    class TabData < ViewComponent::Base
      attr_reader :label, :selected, :disabled, :system_arguments, :content_block, :tab_id, :panel_id

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
