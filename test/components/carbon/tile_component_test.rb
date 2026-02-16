# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TileComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default tile' do
      render_inline(Carbon::TileComponent.new) { 'Tile content' }

      assert_selector 'div.cds--tile'
    end

    test 'renders with cds--tile class' do
      render_inline(Carbon::TileComponent.new) { 'Content' }

      assert_selector '.cds--tile'
    end

    test 'renders content' do
      render_inline(Carbon::TileComponent.new) { 'Hello World' }

      assert_text 'Hello World'
    end

    # -- Light variant --

    test 'renders light variant' do
      render_inline(Carbon::TileComponent.new(light: true)) { 'Content' }

      assert_selector 'div.cds--tile.cds--tile--light'
    end

    test 'does not render light class by default' do
      render_inline(Carbon::TileComponent.new) { 'Content' }

      assert_no_selector '.cds--tile--light'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::TileComponent.new(id: 'my-tile')) { 'Content' }

      assert_selector 'div#my-tile.cds--tile'
    end

    test 'merges custom class' do
      render_inline(Carbon::TileComponent.new(class: 'custom-class')) { 'Content' }

      assert_selector 'div.cds--tile.custom-class'
    end

    test 'passes data attributes' do
      render_inline(Carbon::TileComponent.new(data: { testid: 'tile-1' })) { 'Content' }

      assert_selector 'div.cds--tile[data-testid="tile-1"]'
    end
  end
end
