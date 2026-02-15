# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ContainedListComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders contained list with label' do
      render_inline(Carbon::ContainedListComponent.new(label: 'My List')) do |c|
        c.with_item { 'Item 1' }
        c.with_item { 'Item 2' }
      end

      assert_selector '.cds--contained-list'
      assert_selector '.cds--contained-list__header .cds--contained-list__label', text: 'My List'
    end

    test 'renders list with aria-label' do
      render_inline(Carbon::ContainedListComponent.new(label: 'Test Label')) do |c|
        c.with_item { 'Item' }
      end

      assert_selector ".cds--contained-list[aria-label='Test Label']"
    end

    test 'renders items in list container' do
      render_inline(Carbon::ContainedListComponent.new(label: 'Items')) do |c|
        c.with_item { 'First' }
        c.with_item { 'Second' }
        c.with_item { 'Third' }
      end

      assert_selector '.cds--contained-list__list[role="list"]'
      assert_selector '.cds--contained-list-item', count: 3
    end

    # -- Kinds --

    test 'renders on_page kind by default' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list'
      assert_no_selector '.cds--contained-list--on-page'
      assert_no_selector '.cds--contained-list--disclosed'
    end

    test 'renders disclosed kind' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', kind: :disclosed)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.cds--contained-list--disclosed'
    end

    # -- Items --

    test 'renders item with content' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'Item content' }
      end

      assert_selector '.cds--contained-list-item[role="listitem"]'
      assert_selector '.cds--contained-list-item__content', text: 'Item content'
    end

    test 'renders multiple items' do # rubocop:disable Minitest/MultipleAssertions
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'First item' }
        c.with_item { 'Second item' }
        c.with_item { 'Third item' }
      end

      assert_selector '.cds--contained-list-item', count: 3
      assert_selector '.cds--contained-list-item__content', text: 'First item'
      assert_selector '.cds--contained-list-item__content', text: 'Second item'
      assert_selector '.cds--contained-list-item__content', text: 'Third item'
    end

    test 'renders item with action slot' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item do |item|
          item.with_action { '<button>Delete</button>'.html_safe }
          'Item with action'
        end
      end

      assert_selector '.cds--contained-list-item button', text: 'Delete'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::ContainedListComponent.new(
                      label: 'Test',
                      id: 'my-list',
                      data: { testid: 'list-1' }
                    )) do |c|
        c.with_item { 'Item' }
      end

      assert_selector ".cds--contained-list#my-list[data-testid='list-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::ContainedListComponent.new(label: 'Test', class: 'my-custom-class')) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid kind' do
      assert_raises(ArgumentError) do
        Carbon::ContainedListComponent.new(label: 'Test', kind: :invalid)
      end
    end

    test 'accepts string values for kind' do
      render_inline(Carbon::ContainedListComponent.new(label: 'Test', kind: 'disclosed')) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list--disclosed'
    end
  end
end
