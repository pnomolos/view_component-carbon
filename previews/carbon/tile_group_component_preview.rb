# frozen_string_literal: true

module Carbon
  class TileGroupComponentPreview < ViewComponent::Preview
    # @param disabled toggle
    def default(disabled: false)
      render Carbon::TileGroupComponent.new(
        name: 'color',
        legend: 'Choose a color',
        disabled: disabled,
        default_selected: 'blue'
      ) do |c|
        c.with_tile(value: 'red') { 'Red' }
        c.with_tile(value: 'blue') { 'Blue' }
        c.with_tile(value: 'green') { 'Green' }
      end
    end

    def without_default
      render Carbon::TileGroupComponent.new(name: 'size', legend: 'Select a size') do |c|
        c.with_tile(value: 'sm') { 'Small' }
        c.with_tile(value: 'md') { 'Medium' }
        c.with_tile(value: 'lg') { 'Large' }
      end
    end

    def with_disabled_tile
      render Carbon::TileGroupComponent.new(name: 'plan', legend: 'Choose a plan') do |c|
        c.with_tile(value: 'free') { 'Free' }
        c.with_tile(value: 'pro') { 'Pro' }
        c.with_tile(value: 'enterprise', disabled: true) { 'Enterprise (unavailable)' }
      end
    end

    def all_disabled
      render Carbon::TileGroupComponent.new(name: 'option', legend: 'All disabled', disabled: true) do |c|
        c.with_tile(value: 'a') { 'Option A' }
        c.with_tile(value: 'b') { 'Option B' }
      end
    end
  end
end
