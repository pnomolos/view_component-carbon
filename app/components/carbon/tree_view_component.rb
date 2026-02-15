# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Tree View with expandable nodes.
  #
  # @example Basic usage
  #   render Carbon::TreeViewComponent.new(label: "Files") do |tree|
  #     tree.with_node(label: "Documents")
  #   end
  #
  # @see https://carbondesignsystem.com/components/tree-view/usage/
  class TreeViewComponent < Carbon::BaseComponent
    SIZES = %i[xs sm].freeze
    DEFAULT_SIZE = :sm

    renders_many :nodes, 'Carbon::TreeViewComponent::NodeComponent'

    # @return [String] tree accessible label
    attr_reader :label
    # @return [Boolean] whether multi-selection is enabled
    attr_reader :multiselect
    # @return [Symbol] tree size
    attr_reader :size

    # @param label [String] accessible tree label
    # @param multiselect [Boolean] enables multi-selection
    # @param size [Symbol] tree size (:xs, :sm)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(label: 'Tree', multiselect: false, size: DEFAULT_SIZE, **system_arguments)
      @label = label
      @multiselect = multiselect
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--tree']
      classes << "cds--tree--#{@size}"
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'tree'
      attrs['aria-label'] = @label
      attrs['aria-multiselectable'] = 'true' if @multiselect
      attrs['data-controller'] = 'carbon--tree-view'
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # A single node within a TreeView, optionally with child nodes.
    class NodeComponent < Carbon::BaseComponent
      renders_many :nodes, 'Carbon::TreeViewComponent::NodeComponent'

      # @return [String] node label
      attr_reader :label
      # @return [String, nil] node value
      attr_reader :value
      # @return [Boolean] whether expanded
      attr_reader :expanded
      # @return [Boolean] whether disabled
      attr_reader :disabled
      # @return [Boolean] whether selected
      attr_reader :selected
      # @return [String] unique node ID
      attr_reader :node_id

      # @param label [String] node label
      # @param value [String, nil] node value
      # @param expanded [Boolean] initial expanded state
      # @param disabled [Boolean] disables the node
      # @param selected [Boolean] initial selected state
      # @param icon [String, nil] optional icon content
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(label:, value: nil, expanded: false, disabled: false, selected: false,
                     icon: nil, **system_arguments)
        @label = label
        @value = value
        @expanded = expanded
        @disabled = disabled
        @selected = selected
        @icon = icon
        @system_arguments = system_arguments
        @node_id = "tree-node-#{SecureRandom.hex(8)}"
      end

      # @return [Boolean] whether this node has children
      def parent_node?
        nodes.any?
      end

      private

      def css_classes
        classes = ['cds--tree-node']
        classes << 'cds--tree-node--selected' if @selected
        classes << 'cds--tree-node--disabled' if @disabled
        classes << 'cds--tree-node--with-icon' if @icon
        classes << (parent_node? ? 'cds--tree-parent-node' : 'cds--tree-leaf-node')
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:role] = 'treeitem'
        attrs[:id] = @node_id
        attrs[:tabindex] = @disabled ? nil : '-1'
        attrs['data-action'] = 'click->carbon--tree-view#selectNode'
        merge_aria_attributes(attrs)
      end

      def merge_aria_attributes(attrs)
        attrs['aria-expanded'] = @expanded.to_s if parent_node?
        attrs['aria-selected'] = @selected.to_s
        attrs['aria-disabled'] = 'true' if @disabled
        attrs['data-value'] = @value if @value
        attrs
      end

      def children_css_classes
        classes = ['cds--tree-node__children']
        classes << 'cds--tree-node--hidden' unless @expanded
        class_names(classes)
      end
    end
  end
end
