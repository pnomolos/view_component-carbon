# frozen_string_literal: true

module Carbon
  class TileComponentPreview < ViewComponent::Preview
    # @param light toggle
    def default(light: false)
      render Carbon::TileComponent.new(light: light) do
        'Default tile content. This is a read-only tile.'
      end
    end

    def light_variant
      render Carbon::TileComponent.new(light: true) do
        'This is a light tile.'
      end
    end

    def clickable_with_href
      render Carbon::ClickableTileComponent.new(href: 'https://example.com') do
        'Clickable tile with link'
      end
    end

    def clickable_without_href
      render Carbon::ClickableTileComponent.new do
        'Clickable tile as button'
      end
    end

    def clickable_disabled
      render Carbon::ClickableTileComponent.new(href: 'https://example.com', disabled: true) do
        'Disabled clickable tile'
      end
    end

    def clickable_with_target
      render Carbon::ClickableTileComponent.new(href: 'https://example.com', target: '_blank', rel: 'noopener') do
        'Opens in new tab'
      end
    end
  end
end
