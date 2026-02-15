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

    renders_many :items, 'ItemComponent'

    # @param label [String] accessible label for the list
    # @param kind [Symbol] list kind (:on_page, :disclosed)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(label:, kind: :on_page, **system_arguments)
      @label = label
      @kind = validate_argument('kind', kind, KINDS, :on_page)
      @system_arguments = system_arguments
    end

    # A single item within a ContainedList.
    class ItemComponent < BaseComponent
      renders_one :action

      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      attr_reader :system_arguments

      def css_classes
        classes = [carbon_class('contained-list-item')]
        classes << system_arguments[:class] if system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = system_arguments.dup
        attrs.delete(:class)
        attrs[:role] = 'listitem'
        attrs
      end
    end

    private

    attr_reader :label, :kind, :system_arguments

    def css_classes
      classes = [carbon_class('contained-list')]
      classes << carbon_class('contained-list', nil, kind_modifier) if kind_modifier
      classes << system_arguments[:class] if system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = system_arguments.dup
      attrs.delete(:class)
      attrs[:'aria-label'] = label
      attrs
    end

    def kind_modifier
      kind.to_s.tr('_', '-') unless kind == :on_page
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
