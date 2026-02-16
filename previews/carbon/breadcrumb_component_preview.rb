# frozen_string_literal: true

module Carbon
  class BreadcrumbComponentPreview < ViewComponent::Preview
    # @param no_trailing_slash toggle
    def default(no_trailing_slash: false)
      render Carbon::BreadcrumbComponent.new(no_trailing_slash: no_trailing_slash) do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(href: '/products') { 'Products' }
        c.with_item(href: '/products/category') { 'Category' }
        c.with_item(current: true) { 'Current Page' }
      end
    end

    def simple
      render Carbon::BreadcrumbComponent.new do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(current: true) { 'Current Page' }
      end
    end

    def no_trailing_slash
      render Carbon::BreadcrumbComponent.new(no_trailing_slash: true) do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(href: '/docs') { 'Documentation' }
        c.with_item(current: true) { 'Guide' }
      end
    end

    def deep_navigation
      render Carbon::BreadcrumbComponent.new do |c|
        c.with_item(href: '/') { 'Home' }
        c.with_item(href: '/products') { 'Products' }
        c.with_item(href: '/products/electronics') { 'Electronics' }
        c.with_item(href: '/products/electronics/computers') { 'Computers' }
        c.with_item(href: '/products/electronics/computers/laptops') { 'Laptops' }
        c.with_item(current: true) { 'Gaming Laptops' }
      end
    end
  end
end
