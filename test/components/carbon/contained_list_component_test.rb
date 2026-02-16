# frozen_string_literal: true

require 'test_helper'

module Carbon
  # rubocop:disable Metrics/ClassLength
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

    test 'renders list with aria-labelledby pointing to label' do
      render_inline(Carbon::ContainedListComponent.new(label: 'Test Label')) do |c|
        c.with_item { 'Item' }
      end

      # Find the label element and get its ID
      label_element = page.find('.cds--contained-list__label')
      label_id = label_element[:id]

      # Check that the ul has aria-labelledby pointing to that ID
      assert_selector "ul[aria-labelledby='#{label_id}']"
      assert_selector "##{label_id}", text: 'Test Label'
    end

    test 'renders items in ul list container' do
      render_inline(Carbon::ContainedListComponent.new(label: 'Items')) do |c|
        c.with_item { 'First' }
        c.with_item { 'Second' }
        c.with_item { 'Third' }
      end

      assert_selector 'ul[role="list"]'
      assert_selector 'li.cds--contained-list-item', count: 3
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

      assert_selector 'li.cds--contained-list-item[role="listitem"]'
      assert_selector '.cds--contained-list-item__content', text: 'Item content'
    end

    test 'renders multiple items' do
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

    # -- Size --

    test 'renders with size modifier class' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', size: :sm)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.cds--layout--size-sm'
    end

    test 'renders with medium size' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', size: :md)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.cds--layout--size-md'
    end

    test 'renders with large size' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', size: :lg)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.cds--layout--size-lg'
    end

    test 'renders with extra large size' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', size: :xl)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.cds--layout--size-xl'
    end

    test 'renders without size class when size not provided' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'Item' }
      end

      assert_no_selector '.cds--layout--size-sm'
      assert_no_selector '.cds--layout--size-md'
      assert_no_selector '.cds--layout--size-lg'
      assert_no_selector '.cds--layout--size-xl'
    end

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::ContainedListComponent.new(label: 'Test', size: :invalid)
      end
    end

    # -- Inset --

    test 'renders with inset rulers modifier' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', is_inset: true)) do |c|
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list.cds--contained-list--inset-rulers'
    end

    test 'does not render inset class by default' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'Item' }
      end

      assert_no_selector '.cds--contained-list--inset-rulers'
    end

    # -- Label slot --

    test 'renders with label slot instead of string' do
      render_inline(Carbon::ContainedListComponent.new) do |c|
        c.with_label { '<strong>Custom Label</strong>'.html_safe }
        c.with_item { 'Item' }
      end

      assert_selector '.cds--contained-list__label strong', text: 'Custom Label'
    end

    test 'does not render header when no label provided' do
      render_inline(Carbon::ContainedListComponent.new) do |c|
        c.with_item { 'Item' }
      end

      assert_no_selector '.cds--contained-list__header'
      assert_no_selector '.cds--contained-list__label'
    end

    test 'does not add aria-labelledby when no label' do
      render_inline(Carbon::ContainedListComponent.new) do |c|
        c.with_item { 'Item' }
      end

      assert_selector 'ul[role="list"]'
      assert_no_selector 'ul[aria-labelledby]'
    end

    # -- Item clickable --

    test 'renders clickable item with button wrapper' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item(clickable: true) { 'Clickable item' }
      end

      assert_selector 'li.cds--contained-list-item--clickable'
      assert_selector 'button.cds--contained-list-item__content[type="button"]', text: 'Clickable item'
    end

    test 'renders non-clickable item with div wrapper' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'Regular item' }
      end

      assert_no_selector '.cds--contained-list-item--clickable'
      assert_selector 'div.cds--contained-list-item__content', text: 'Regular item'
      assert_no_selector 'button.cds--contained-list-item__content'
    end

    test 'renders disabled clickable item' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item(clickable: true, disabled: true) { 'Disabled item' }
      end

      assert_selector 'button.cds--contained-list-item__content[disabled]'
    end

    test 'disabled has no effect on non-clickable items' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item(disabled: true) { 'Not clickable' }
      end

      assert_no_selector 'button'
      assert_selector 'div.cds--contained-list-item__content'
    end

    # -- Item icon --

    test 'renders item with icon slot' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item do |item|
          item.with_icon { '<svg>Icon</svg>'.html_safe }
          'Item with icon'
        end
      end

      assert_selector 'li.cds--contained-list-item--with-icon'
      assert_selector '.cds--contained-list-item__icon svg', text: 'Icon'
    end

    test 'does not render icon wrapper when no icon' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'No icon' }
      end

      assert_no_selector '.cds--contained-list-item--with-icon'
      assert_no_selector '.cds--contained-list-item__icon'
    end

    # -- Item action --

    test 'renders item with action modifier class' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item do |item|
          item.with_action { '<button>Action</button>'.html_safe }
          'Item'
        end
      end

      assert_selector 'li.cds--contained-list-item--with-action'
    end

    test 'does not add action modifier when no action' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List')) do |c|
        c.with_item { 'No action' }
      end

      assert_no_selector '.cds--contained-list-item--with-action'
    end

    # -- Combined features --

    test 'renders item with all features combined' do
      render_inline(Carbon::ContainedListComponent.new(label: 'List', size: :lg, is_inset: true)) do |c|
        c.with_item(clickable: true) do |item|
          item.with_icon { '<svg>Icon</svg>'.html_safe }
          item.with_action { '<button>Delete</button>'.html_safe }
          'Complex item'
        end
      end

      assert_selector '.cds--contained-list.cds--layout--size-lg.cds--contained-list--inset-rulers'
      assert_selector 'li.cds--contained-list-item--clickable' \
                      '.cds--contained-list-item--with-icon.cds--contained-list-item--with-action'
      assert_selector '.cds--contained-list-item__icon svg'
      assert_selector 'button.cds--contained-list-item__content', text: 'Complex item'
      assert_selector 'button', text: 'Delete'
    end
  end
  # rubocop:enable Metrics/ClassLength
end
