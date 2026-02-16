# frozen_string_literal: true

require 'test_helper'

module Carbon
  class BreadcrumbComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders breadcrumb nav with list' do
      render_inline(Carbon::BreadcrumbComponent.new) do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(href: '/products') { 'Products' }
        c.with_item(current: true) { 'Current Page' }
      end

      assert_selector 'nav[aria-label="Breadcrumb"]'
      assert_selector 'ol.cds--breadcrumb'
    end

    test 'renders breadcrumb items with links' do
      render_inline(Carbon::BreadcrumbComponent.new) do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(href: '/products') { 'Products' }
      end

      assert_selector 'li.cds--breadcrumb-item', count: 2
      assert_selector 'li.cds--breadcrumb-item a.cds--link[href="/"]', text: 'Home'
      assert_selector 'li.cds--breadcrumb-item a.cds--link[href="/products"]', text: 'Products'
    end

    test 'renders current item without link' do
      render_inline(Carbon::BreadcrumbComponent.new) do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(current: true) { 'Current Page' }
      end

      assert_selector 'li.cds--breadcrumb-item--current[aria-current="page"]', text: 'Current Page'
      assert_no_selector 'li.cds--breadcrumb-item--current a'
    end

    test 'renders current item with CSS class' do
      render_inline(Carbon::BreadcrumbComponent.new) do |c|
        c.with_item(current: true) { 'Current' }
      end

      assert_selector 'li.cds--breadcrumb-item.cds--breadcrumb-item--current'
    end

    # -- No trailing slash --

    test 'renders with no_trailing_slash modifier' do
      render_inline(Carbon::BreadcrumbComponent.new(no_trailing_slash: true)) do |c|
        c.with_item(href: '/') { 'Home' }
      end

      assert_selector 'ol.cds--breadcrumb.cds--breadcrumb--no-trailing-slash'
    end

    # -- System arguments --

    test 'passes through system arguments on breadcrumb' do
      render_inline(Carbon::BreadcrumbComponent.new(id: 'my-breadcrumb', data: { testid: 'breadcrumb-1' })) do |c|
        c.with_item(href: '/') { 'Home' }
      end

      assert_selector 'ol#my-breadcrumb[data-testid="breadcrumb-1"]'
    end

    test 'merges custom class with component classes on breadcrumb' do
      render_inline(Carbon::BreadcrumbComponent.new(class: 'my-custom-class')) do |c|
        c.with_item(href: '/') { 'Home' }
      end

      assert_selector 'ol.cds--breadcrumb.my-custom-class'
    end

    test 'passes through system arguments on items' do
      render_inline(Carbon::BreadcrumbComponent.new) do |c|
        c.with_item(href: '/', id: 'home-item', data: { testid: 'item-1' }) { 'Home' }
      end

      assert_selector 'li#home-item[data-testid="item-1"]'
    end

    test 'merges custom class with component classes on items' do
      render_inline(Carbon::BreadcrumbComponent.new) do |c|
        c.with_item(href: '/', class: 'custom-item-class') { 'Home' }
      end

      assert_selector 'li.cds--breadcrumb-item.custom-item-class'
    end
  end
end
