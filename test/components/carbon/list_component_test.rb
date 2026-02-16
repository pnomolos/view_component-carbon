# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ListComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders unordered list by default' do
      render_inline(Carbon::ListComponent.new) do |c|
        c.with_item { 'Item 1' }
        c.with_item { 'Item 2' }
      end

      assert_selector 'ul.cds--list--unordered'
      assert_selector 'li.cds--list__item', count: 2
    end

    test 'renders ordered list when ordered is true' do
      render_inline(Carbon::ListComponent.new(ordered: true)) do |c|
        c.with_item { 'First' }
        c.with_item { 'Second' }
      end

      assert_selector 'ol.cds--list--ordered'
      assert_selector 'li.cds--list__item', count: 2
    end

    test 'renders list items with content' do
      render_inline(Carbon::ListComponent.new) do |c|
        c.with_item { 'Item 1' }
        c.with_item { 'Item 2' }
        c.with_item { 'Item 3' }
      end

      assert_selector 'li.cds--list__item', text: 'Item 1'
      assert_selector 'li.cds--list__item', text: 'Item 2'
      assert_selector 'li.cds--list__item', text: 'Item 3'
    end

    # -- Nested lists --

    test 'renders with nested modifier' do
      render_inline(Carbon::ListComponent.new(nested: true)) do |c|
        c.with_item { 'Nested item' }
      end

      assert_selector 'ul.cds--list--unordered.cds--list--nested'
    end

    test 'renders nested ordered list with both modifiers' do
      render_inline(Carbon::ListComponent.new(ordered: true, nested: true)) do |c|
        c.with_item { 'Nested ordered item' }
      end

      assert_selector 'ol.cds--list--ordered.cds--list--nested'
    end

    # -- System arguments --

    test 'passes through system arguments on list' do
      render_inline(Carbon::ListComponent.new(id: 'my-list', data: { testid: 'list-1' })) do |c|
        c.with_item { 'Item' }
      end

      assert_selector 'ul#my-list[data-testid="list-1"]'
    end

    test 'merges custom class with component classes on list' do
      render_inline(Carbon::ListComponent.new(class: 'my-custom-class')) do |c|
        c.with_item { 'Item' }
      end

      assert_selector 'ul.cds--list--unordered.my-custom-class'
    end

    test 'passes through system arguments on items' do
      render_inline(Carbon::ListComponent.new) do |c|
        c.with_item(id: 'item-1', data: { testid: 'list-item-1' }) { 'Item' }
      end

      assert_selector 'li#item-1[data-testid="list-item-1"]'
    end

    test 'merges custom class with component classes on items' do
      render_inline(Carbon::ListComponent.new) do |c|
        c.with_item(class: 'custom-item-class') { 'Item' }
      end

      assert_selector 'li.cds--list__item.custom-item-class'
    end
  end
end
