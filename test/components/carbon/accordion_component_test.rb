# frozen_string_literal: true

require 'test_helper'

module Carbon
  class AccordionComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default accordion' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
      end

      assert_selector 'ul.cds--accordion'
    end

    test 'renders accordion items' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
        c.with_item(title: 'Item 2') { 'Content 2' }
      end

      assert_selector 'li.cds--accordion__item', count: 2
    end

    # -- Align --

    test 'renders start align' do
      render_inline(Carbon::AccordionComponent.new(align: :start)) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'ul.cds--accordion--start'
    end

    test 'renders end align (default)' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_no_selector 'ul.cds--accordion--end'
    end

    # -- Size --

    test 'renders sm size' do
      render_inline(Carbon::AccordionComponent.new(size: :sm)) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'ul.cds--accordion--sm'
    end

    test 'renders md size (default)' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_no_selector 'ul.cds--accordion--md'
    end

    test 'renders lg size' do
      render_inline(Carbon::AccordionComponent.new(size: :lg)) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'ul.cds--accordion--lg'
    end

    # -- Item Component --

    test 'renders item with title' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'My Title') { 'Content' }
      end

      assert_selector '.cds--accordion__title', text: 'My Title'
    end

    test 'renders item with content' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Title') { 'My Content' }
      end

      assert_selector '.cds--accordion__content', text: 'My Content'
    end

    test 'renders item with open state' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Open Item', open: true) { 'Content' }
      end

      assert_selector 'li.cds--accordion__item--active'
      assert_selector 'button[aria-expanded="true"]'
    end

    test 'renders item with closed state (default)' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Closed Item') { 'Content' }
      end

      assert_no_selector 'li.cds--accordion__item--active'
      assert_selector 'button[aria-expanded="false"]'
    end

    test 'renders item with aria-controls matching panel id' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      button = page.find('button.cds--accordion__heading')
      panel_id = button['aria-controls']

      assert_selector "##{panel_id}.cds--accordion__content"
    end

    test 'renders item with stimulus controller' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'li[data-controller="carbon--accordion-item"]'
    end

    test 'renders button with toggle action' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'button[data-action="click->carbon--accordion-item#toggle"]'
    end

    test 'renders chevron icon' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'svg.cds--accordion__arrow'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid align' do
      assert_raises(ArgumentError) do
        Carbon::AccordionComponent.new(align: :invalid)
      end
    end

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::AccordionComponent.new(size: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::AccordionComponent.new(id: 'my-accordion')) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'ul#my-accordion'
    end

    test 'merges custom class' do
      render_inline(Carbon::AccordionComponent.new(class: 'custom-class')) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'ul.cds--accordion.custom-class'
    end

    # -- Button type attribute --

    test 'renders accordion button with type=button' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item') { 'Content' }
      end

      assert_selector 'button.cds--accordion__heading[type="button"]'
    end

    # -- Flush variant --

    test 'renders flush variant' do
      render_inline(Carbon::AccordionComponent.new(is_flush: true)) do |a|
        a.with_item(title: 'Test') { 'Content' }
      end

      assert_selector '.cds--accordion--flush'
    end

    test 'flush variant not applied when align is start' do
      render_inline(Carbon::AccordionComponent.new(is_flush: true, align: :start)) do |a|
        a.with_item(title: 'Test') { 'Content' }
      end

      assert_no_selector '.cds--accordion--flush'
    end

    # -- Disabled item --

    test 'renders disabled item' do
      render_inline(Carbon::AccordionComponent.new) do |a|
        a.with_item(title: 'Test', disabled: true) { 'Content' }
      end

      assert_selector '.cds--accordion__item--disabled'
    end

    # -- Ordered list --

    test 'renders as ul by default' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
      end

      assert_selector 'ul.cds--accordion'
      assert_no_selector 'ol.cds--accordion'
    end

    test 'renders as ol when ordered is true' do
      render_inline(Carbon::AccordionComponent.new(ordered: true)) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
      end

      assert_selector 'ol.cds--accordion'
      assert_no_selector 'ul.cds--accordion'
    end

    test 'list_tag method returns ul by default' do
      component = Carbon::AccordionComponent.new

      assert_equal :ul, component.list_tag
    end

    test 'list_tag method returns ol when ordered' do
      component = Carbon::AccordionComponent.new(ordered: true)

      assert_equal :ol, component.list_tag
    end
  end
end
