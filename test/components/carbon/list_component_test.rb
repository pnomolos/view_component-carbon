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

    # -- Expressive variant --

    test 'renders with is_expressive modifier' do
      render_inline(Carbon::ListComponent.new(is_expressive: true)) do |c|
        c.with_item { 'Expressive item' }
      end

      assert_selector 'ul.cds--list--unordered.cds--list--expressive'
    end

    test 'renders expressive ordered list' do
      render_inline(Carbon::ListComponent.new(ordered: true, is_expressive: true)) do |c|
        c.with_item { 'Expressive ordered item' }
      end

      assert_selector 'ol.cds--list--ordered.cds--list--expressive'
    end

    # -- Native variant --

    test 'renders with native modifier on ordered list' do
      render_inline(Carbon::ListComponent.new(ordered: true, native: true)) do |c|
        c.with_item { 'Native item' }
      end

      assert_selector 'ol.cds--list--ordered.cds--list--ordered--native'
    end

    test 'does not render native modifier on unordered list' do
      render_inline(Carbon::ListComponent.new(ordered: false, native: true)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector 'ul.cds--list--unordered'
      assert_no_selector 'ul.cds--list--ordered--native'
    end

    test 'renders with both is_expressive and native modifiers' do
      render_inline(Carbon::ListComponent.new(ordered: true, is_expressive: true, native: true)) do |c|
        c.with_item { 'Complex item' }
      end

      assert_selector 'ol.cds--list--ordered.cds--list--expressive.cds--list--ordered--native'
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

    # -- Accessibility --

    test 'list items have role=listitem' do
      render_inline(Carbon::ListComponent.new) do |c|
        c.with_item { 'Item 1' }
        c.with_item { 'Item 2' }
      end

      assert_selector 'li.cds--list__item[role="listitem"]', count: 2
    end
  end
end
