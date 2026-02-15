# frozen_string_literal: true

require 'test_helper'

module Carbon
  class InlineLoadingComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default inline loading' do
      render_inline(Carbon::InlineLoadingComponent.new(description: 'Loading data'))

      assert_selector 'div.cds--inline-loading.cds--inline-loading--active[role="status"][aria-live="assertive"]'
      assert_selector '.cds--inline-loading__text', text: 'Loading data'
    end

    test 'renders active state by default' do
      render_inline(Carbon::InlineLoadingComponent.new)

      assert_selector '.cds--inline-loading--active'
      assert_selector '.cds--loading.cds--loading--small'
    end

    # -- Statuses --

    test 'renders active status with spinner' do
      render_inline(Carbon::InlineLoadingComponent.new(status: :active))

      assert_selector '.cds--inline-loading--active'
      assert_selector '.cds--loading.cds--loading--small'
      assert_selector '.cds--loading__svg'
    end

    test 'renders finished status with checkmark' do
      render_inline(Carbon::InlineLoadingComponent.new(status: :finished))

      assert_selector '.cds--inline-loading--finished'
      assert_selector '.cds--inline-loading__checkmark-container'
      assert_no_selector '.cds--loading'
    end

    test 'renders error status with error icon' do
      render_inline(Carbon::InlineLoadingComponent.new(status: :error))

      assert_selector '.cds--inline-loading--error'
      assert_selector 'svg.cds--inline-loading--error'
      assert_no_selector '.cds--loading'
    end

    test 'renders inactive status without spinner or icon' do
      render_inline(Carbon::InlineLoadingComponent.new(status: :inactive))

      assert_selector '.cds--inline-loading--inactive'
      assert_no_selector '.cds--loading'
      assert_no_selector '.cds--inline-loading__checkmark-container'
    end

    # -- Description --

    test 'renders without description when not provided' do
      render_inline(Carbon::InlineLoadingComponent.new)

      assert_no_selector '.cds--inline-loading__text'
    end

    test 'renders with description' do
      render_inline(Carbon::InlineLoadingComponent.new(description: 'Saving changes'))

      assert_selector '.cds--inline-loading__text', text: 'Saving changes'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::InlineLoadingComponent.new(id: 'my-inline', data: { testid: 'inline-1' }))

      assert_selector 'div#my-inline[data-testid="inline-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::InlineLoadingComponent.new(class: 'my-custom-class'))

      assert_selector '.cds--inline-loading.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid status' do
      assert_raises(ArgumentError) do
        Carbon::InlineLoadingComponent.new(status: :invalid)
      end
    end

    test 'accepts string values for status' do
      render_inline(Carbon::InlineLoadingComponent.new(status: 'finished'))

      assert_selector '.cds--inline-loading--finished'
    end
  end
end
