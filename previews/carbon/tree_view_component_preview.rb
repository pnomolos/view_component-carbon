# frozen_string_literal: true

module Carbon
  class TreeViewComponentPreview < ViewComponent::Preview
    # @param size select { choices: [xs, sm] }
    # @param multiselect toggle
    def default(size: :sm, multiselect: false)
      render Carbon::TreeViewComponent.new(
        label: 'Tree View',
        size: size.to_sym,
        multiselect: multiselect
      ) do |c|
        c.with_node(label: 'Item 1')
        c.with_node(label: 'Item 2')
        c.with_node(label: 'Item 3')
      end
    end

    def with_nested_nodes
      render Carbon::TreeViewComponent.new(label: 'File browser') do |c|
        c.with_node(label: 'src', expanded: true) do |n|
          n.with_node(label: 'components') do |n2|
            n2.with_node(label: 'Button.jsx')
            n2.with_node(label: 'Input.jsx')
          end
          n.with_node(label: 'utils') do |n2|
            n2.with_node(label: 'helpers.js')
          end
          n.with_node(label: 'index.js')
        end
        c.with_node(label: 'package.json')
        c.with_node(label: 'README.md')
      end
    end

    def with_selected_nodes
      render Carbon::TreeViewComponent.new(label: 'Selection example') do |c|
        c.with_node(label: 'Item 1', selected: true)
        c.with_node(label: 'Item 2')
        c.with_node(label: 'Item 3')
      end
    end

    def with_disabled_nodes
      render Carbon::TreeViewComponent.new(label: 'Disabled example') do |c|
        c.with_node(label: 'Enabled item')
        c.with_node(label: 'Disabled item', disabled: true)
        c.with_node(label: 'Another enabled item')
      end
    end

    def extra_small_size
      render Carbon::TreeViewComponent.new(label: 'Extra small tree', size: :xs) do |c|
        c.with_node(label: 'Node 1')
        c.with_node(label: 'Node 2') do |n|
          n.with_node(label: 'Child 1')
          n.with_node(label: 'Child 2')
        end
        c.with_node(label: 'Node 3')
      end
    end

    def multiselect
      render Carbon::TreeViewComponent.new(label: 'Multiselect tree', multiselect: true) do |c|
        c.with_node(label: 'Item 1', selected: true)
        c.with_node(label: 'Item 2', selected: true)
        c.with_node(label: 'Item 3')
        c.with_node(label: 'Item 4')
      end
    end
  end
end
