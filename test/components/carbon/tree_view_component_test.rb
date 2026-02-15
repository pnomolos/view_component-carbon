# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TreeViewComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default tree view' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_selector 'ul.cds--tree[role="tree"]'
    end

    test 'renders tree with stimulus controller' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_selector 'ul[data-controller="carbon--tree-view"]'
    end

    test 'renders tree with aria-label' do
      render_inline(Carbon::TreeViewComponent.new(label: 'File browser')) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_selector 'ul[aria-label="File browser"]'
    end

    # -- Size --

    test 'renders default size sm' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_selector 'ul.cds--tree--sm'
    end

    test 'renders xs size' do
      render_inline(Carbon::TreeViewComponent.new(size: :xs)) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_selector 'ul.cds--tree--xs'
    end

    # -- Multiselect --

    test 'renders multiselect tree' do
      render_inline(Carbon::TreeViewComponent.new(multiselect: true)) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_selector 'ul[aria-multiselectable="true"]'
    end

    test 'does not render multiselect by default' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Node 1')
      end

      assert_no_selector 'ul[aria-multiselectable]'
    end

    # -- Nodes --

    test 'renders leaf nodes' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'File 1')
        c.with_node(label: 'File 2')
      end

      assert_selector 'li.cds--tree-node.cds--tree-leaf-node[role="treeitem"]', count: 2
    end

    test 'renders node with label text' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'My File')
      end

      assert_selector '.cds--tree-node__label__text', text: 'My File'
    end

    test 'renders parent node with children' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Folder') do |node|
          node.with_node(label: 'Child 1')
          node.with_node(label: 'Child 2')
        end
      end

      assert_selector 'li.cds--tree-parent-node[aria-expanded="false"]'
      assert_selector 'ul.cds--tree-node__children[role="group"]'
      assert_selector 'ul.cds--tree-node__children li.cds--tree-leaf-node', count: 2
    end

    test 'renders expanded parent node' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Folder', expanded: true) do |node|
          node.with_node(label: 'Child')
        end
      end

      assert_selector 'li[aria-expanded="true"]'
      assert_no_selector 'ul.cds--tree-node--hidden'
    end

    test 'renders collapsed parent node with hidden children' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Folder') do |node|
          node.with_node(label: 'Child')
        end
      end

      assert_selector 'li[aria-expanded="false"]'
      assert_selector 'ul.cds--tree-node--hidden'
    end

    test 'renders toggle icon for parent nodes' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Folder') do |node|
          node.with_node(label: 'Child')
        end
      end

      assert_selector '.cds--tree-parent-node__toggle svg.cds--tree-parent-node__toggle-icon'
    end

    test 'does not render toggle icon for leaf nodes' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'File')
      end

      assert_no_selector '.cds--tree-parent-node__toggle'
    end

    # -- Selected --

    test 'renders selected node' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Selected', selected: true)
      end

      assert_selector 'li.cds--tree-node--selected[aria-selected="true"]'
    end

    test 'renders unselected node by default' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Node')
      end

      assert_selector 'li[aria-selected="false"]'
      assert_no_selector 'li.cds--tree-node--selected'
    end

    # -- Disabled --

    test 'renders disabled node' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Disabled', disabled: true)
      end

      assert_selector 'li.cds--tree-node--disabled[aria-disabled="true"]'
    end

    # -- Value --

    test 'renders node with data-value' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Node', value: 'node-1')
      end

      assert_selector 'li[data-value="node-1"]'
    end

    # -- Nested tree --

    test 'renders deeply nested tree' do
      render_inline(Carbon::TreeViewComponent.new) do |c|
        c.with_node(label: 'Level 1', expanded: true) do |n1|
          n1.with_node(label: 'Level 2', expanded: true) do |n2|
            n2.with_node(label: 'Level 3')
          end
        end
      end

      assert_selector 'li.cds--tree-parent-node', count: 2
      assert_selector 'li.cds--tree-leaf-node', count: 1
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::TreeViewComponent.new(size: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::TreeViewComponent.new(id: 'my-tree')) do |c|
        c.with_node(label: 'Node')
      end

      assert_selector 'ul#my-tree'
    end

    test 'merges custom class' do
      render_inline(Carbon::TreeViewComponent.new(class: 'custom-class')) do |c|
        c.with_node(label: 'Node')
      end

      assert_selector 'ul.cds--tree.custom-class'
    end
  end
end
