# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ClickableTileComponentTest < CarbonViewComponents::TestCase
    # -- Rendering as link --

    test 'renders as link when href provided' do
      render_inline(Carbon::ClickableTileComponent.new(href: '/page')) { 'Click me' }

      assert_selector 'a.cds--tile.cds--tile--clickable[href="/page"]'
    end

    test 'renders content in link' do
      render_inline(Carbon::ClickableTileComponent.new(href: '/page')) { 'Click me' }

      assert_text 'Click me'
    end

    # -- Rendering as div --

    test 'renders as div without href' do
      render_inline(Carbon::ClickableTileComponent.new) { 'Click me' }

      assert_selector 'div.cds--tile.cds--tile--clickable'
    end

    test 'renders role button without href' do
      render_inline(Carbon::ClickableTileComponent.new) { 'Content' }

      assert_selector 'div[role="button"]'
    end

    # -- Disabled state --

    test 'renders disabled class when disabled' do
      render_inline(Carbon::ClickableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector '.cds--tile--disabled'
    end

    test 'renders aria-disabled when disabled' do
      render_inline(Carbon::ClickableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector '[aria-disabled="true"]'
    end

    test 'sets tabindex to -1 when disabled' do
      render_inline(Carbon::ClickableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector '[tabindex="-1"]'
    end

    # -- Target and rel attributes --

    test 'renders target attribute on link' do
      render_inline(Carbon::ClickableTileComponent.new(href: '/page', target: '_blank')) { 'Content' }

      assert_selector 'a[target="_blank"]'
    end

    test 'renders rel attribute on link' do
      render_inline(Carbon::ClickableTileComponent.new(href: '/page', rel: 'noopener')) { 'Content' }

      assert_selector 'a[rel="noopener"]'
    end

    # -- Tabindex --

    test 'renders tabindex 0 by default' do
      render_inline(Carbon::ClickableTileComponent.new) { 'Content' }

      assert_selector '[tabindex="0"]'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::ClickableTileComponent.new(id: 'my-clickable')) { 'Content' }

      assert_selector '#my-clickable.cds--tile.cds--tile--clickable'
    end

    # -- Link class --

    test 'renders cds--link class when href provided' do
      render_inline(Carbon::ClickableTileComponent.new(href: '/page')) { 'Content' }

      assert_selector 'a.cds--link'
    end

    test 'does not render cds--link class without href' do
      render_inline(Carbon::ClickableTileComponent.new) { 'Content' }

      assert_no_selector '.cds--link'
    end

    # -- Color scheme --

    test 'renders regular color scheme by default' do
      render_inline(Carbon::ClickableTileComponent.new) { 'Content' }

      assert_no_selector '.cds--tile--light'
    end

    test 'renders light color scheme' do
      render_inline(Carbon::ClickableTileComponent.new(color_scheme: :light)) { 'Content' }

      assert_selector '.cds--tile--light'
    end

    test 'raises error for invalid color scheme' do
      assert_raises(ArgumentError) do
        Carbon::ClickableTileComponent.new(color_scheme: :invalid)
      end
    end

    # -- Rounded corners --

    test 'does not render rounded corners by default' do
      render_inline(Carbon::ClickableTileComponent.new) { 'Content' }

      assert_no_selector '.cds--tile--slug-rounded'
    end

    test 'renders rounded corners class when enabled' do
      render_inline(Carbon::ClickableTileComponent.new(has_rounded_corners: true)) { 'Content' }

      assert_selector '.cds--tile--slug-rounded'
    end
  end
end
