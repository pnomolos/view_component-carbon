# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Contained List.
  #
  # @example Basic usage
  #   render Carbon::ContainedListComponent.new(label: "Items") do |list|
  #     list.with_item { "Item 1" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/contained-list/usage/
  class ContainedListComponent < BaseComponent
    KINDS = %i[on_page disclosed].freeze
    SIZES = %i[sm md lg xl].freeze

    renders_many :items, 'ItemComponent'
    renders_one :label

    # @param label [String] accessible label for the list (string or use label slot)
    # @param kind [Symbol] list kind (:on_page, :disclosed)
    # @param size [Symbol] list size (:sm, :md, :lg, :xl) - optional
    # @param is_inset [Boolean] whether to use inset rulers styling
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(label: nil, kind: :on_page, size: nil, is_inset: false, **system_arguments)
      @label_text = label
      @kind = validate_argument('kind', kind, KINDS, :on_page)
      @size = validate_argument('size', size, SIZES, nil) if size
      @is_inset = is_inset
      @system_arguments = system_arguments
    end

    # A single item within a ContainedList.
    class ItemComponent < BaseComponent
      renders_one :action
      renders_one :icon

      # @param clickable [Boolean] whether the item is clickable (renders as button)
      # @param disabled [Boolean] whether the item is disabled (only applies when clickable)
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(clickable: false, disabled: false, **system_arguments)
        @clickable = clickable
        @disabled = disabled
        @system_arguments = system_arguments
      end

      private

      attr_reader :clickable, :disabled, :system_arguments

      def css_classes
        classes = [carbon_class('contained-list-item')]
        classes << carbon_class('contained-list-item', nil, 'clickable') if clickable
        classes << carbon_class('contained-list-item', nil, 'with-icon') if icon?
        classes << carbon_class('contained-list-item', nil, 'with-action') if action?
        classes << system_arguments[:class] if system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = system_arguments.dup
        attrs.delete(:class)
        attrs[:role] = 'listitem'
        attrs
      end

      def content_tag_name
        clickable ? :button : :div
      end

      def content_attributes
        attrs = { class: carbon_class('contained-list-item', 'content') }
        if clickable
          attrs[:type] = 'button'
          attrs[:disabled] = true if disabled
        end
        attrs
      end
    end

    private

    attr_reader :label_text, :kind, :size, :is_inset, :system_arguments

    def css_classes
      classes = [
        carbon_class('contained-list'),
        kind_class,
        inset_class,
        size_class,
        system_arguments[:class]
      ].compact
      class_names(classes)
    end

    def kind_class
      carbon_class('contained-list', nil, kind_modifier) if kind_modifier
    end

    def inset_class
      carbon_class('contained-list', nil, 'inset-rulers') if is_inset
    end

    def size_class
      "cds--layout--size-#{size}" if size
    end

    def html_attributes
      attrs = system_arguments.dup
      attrs.delete(:class)
      attrs
    end

    def list_attributes
      attrs = { role: 'list' }
      # Use aria-labelledby when label is present
      attrs[:'aria-labelledby'] = label_id if label_present?
      attrs
    end

    def label_id
      @label_id ||= "contained-list-label-#{object_id}"
    end

    def label_present?
      label? || label_text.present?
    end

    def render_label_content
      label? ? label : label_text
    end

    def kind_modifier
      kind.to_s.tr('_', '-') unless kind == :on_page
    end

    def validate_argument(name, value, allowed, default)
      return default if value.nil?

      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
