# frozen_string_literal: true

require 'test_helper'

module Carbon
  class LoadingComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default loading spinner' do
      render_inline(Carbon::LoadingComponent.new)

      assert_selector 'div.cds--loading[role="status"][aria-live="assertive"]'
      assert_selector '.cds--loading__svg'
      assert_selector '.cds--visually-hidden', text: 'Loading'
    end

    test 'renders normal size by default' do
      render_inline(Carbon::LoadingComponent.new)

      assert_selector '.cds--loading'
      assert_no_selector '.cds--loading--small'
    end

    # -- Sizes --

    test 'renders small size' do
      render_inline(Carbon::LoadingComponent.new(size: :small))

      assert_selector '.cds--loading.cds--loading--small'
    end

    test 'renders normal size' do
      render_inline(Carbon::LoadingComponent.new(size: :normal))

      assert_selector '.cds--loading'
      assert_no_selector '.cds--loading--small'
    end

    # -- Active state --

    test 'renders active by default' do
      render_inline(Carbon::LoadingComponent.new)

      assert_selector '.cds--loading'
      assert_no_selector '.cds--loading--stop'
    end

    test 'renders inactive state' do
      render_inline(Carbon::LoadingComponent.new(active: false))

      assert_selector '.cds--loading.cds--loading--stop'
    end

    # -- Overlay --

    test 'renders without overlay by default' do
      render_inline(Carbon::LoadingComponent.new)

      assert_no_selector '.cds--loading-overlay'
      assert_selector '.cds--loading'
    end

    test 'renders with overlay' do
      render_inline(Carbon::LoadingComponent.new(overlay: true))

      assert_selector '.cds--loading-overlay'
      assert_selector '.cds--loading-overlay .cds--loading'
    end

    test 'renders overlay with stop class when inactive' do
      render_inline(Carbon::LoadingComponent.new(overlay: true, active: false))

      assert_selector '.cds--loading-overlay.cds--loading-overlay--stop'
      assert_selector '.cds--loading.cds--loading--stop'
    end

    # -- SVG structure --

    test 'renders SVG with correct structure' do
      render_inline(Carbon::LoadingComponent.new)

      assert_selector 'svg.cds--loading__svg'
      assert_selector 'svg title', text: 'Loading'
      assert_selector 'circle.cds--loading__stroke[cx="50"][cy="50"][r="44"]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::LoadingComponent.new(id: 'my-loading', data: { testid: 'loading-1' }))

      assert_selector 'div#my-loading[data-testid="loading-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::LoadingComponent.new(class: 'my-custom-class'))

      assert_selector '.cds--loading.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::LoadingComponent.new(size: :invalid)
      end
    end

    test 'accepts string values for size' do
      render_inline(Carbon::LoadingComponent.new(size: 'small'))

      assert_selector '.cds--loading--small'
    end
  end
end
