# frozen_string_literal: true

module Carbon
  class OverflowMenuComponentPreview < ViewComponent::Preview
    # @param size select { choices: [xs, sm, md, lg] }
    # @param flipped toggle
    # @param align select { choices: [top, bottom, left, right] }
    def default(size: :md, flipped: false, align: :bottom)
      render Carbon::OverflowMenuComponent.new(
        size: size.to_sym,
        flipped: flipped,
        align: align.to_sym
      ) do |c|
        c.with_item(text: 'Option 1')
        c.with_item(text: 'Option 2')
        c.with_item(text: 'Option 3')
      end
    end

    def with_danger_item
      render Carbon::OverflowMenuComponent.new do |c|
        c.with_item(text: 'Edit')
        c.with_item(text: 'Duplicate')
        c.with_item(text: 'Delete', danger: true)
      end
    end

    def with_disabled_item
      render Carbon::OverflowMenuComponent.new do |c|
        c.with_item(text: 'Edit')
        c.with_item(text: 'Copy', disabled: true)
        c.with_item(text: 'Delete')
      end
    end

    def with_links
      render Carbon::OverflowMenuComponent.new do |c|
        c.with_item(text: 'Documentation', href: '/docs')
        c.with_item(text: 'Settings', href: '/settings')
        c.with_item(text: 'Sign Out')
      end
    end

    def flipped
      render Carbon::OverflowMenuComponent.new(flipped: true) do |c|
        c.with_item(text: 'Option 1')
        c.with_item(text: 'Option 2')
        c.with_item(text: 'Option 3')
      end
    end

    def custom_icon_description
      render Carbon::OverflowMenuComponent.new(icon_description: 'Row actions') do |c|
        c.with_item(text: 'Edit row')
        c.with_item(text: 'Delete row', danger: true)
      end
    end
  end
end
