# frozen_string_literal: true

require 'test_helper'

module Carbon
  class BadgeComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default badge with no count' do
      render_inline(Carbon::BadgeComponent.new)

      assert_selector 'span.cds--badge.cds--badge--gray'
    end

    test 'renders badge with count' do
      render_inline(Carbon::BadgeComponent.new(count: 5))

      assert_selector 'span.cds--badge', text: '5'
    end

    # -- Count display --

    test 'renders count when count is 1' do
      render_inline(Carbon::BadgeComponent.new(count: 1))

      assert_selector 'span.cds--badge', text: '1'
    end

    test 'renders count when count is 9' do
      render_inline(Carbon::BadgeComponent.new(count: 9))

      assert_selector 'span.cds--badge', text: '9'
    end

    test 'renders 9+ when count is 10' do
      render_inline(Carbon::BadgeComponent.new(count: 10))

      assert_selector 'span.cds--badge', text: '9+'
    end

    test 'renders 9+ when count is greater than 10' do
      render_inline(Carbon::BadgeComponent.new(count: 100))

      assert_selector 'span.cds--badge', text: '9+'
    end

    test 'renders empty badge when count is nil' do
      render_inline(Carbon::BadgeComponent.new(count: nil))

      assert_selector 'span.cds--badge'
      assert_no_selector 'span.cds--badge', text: /\d/
    end

    test 'renders empty badge when count is 0' do
      render_inline(Carbon::BadgeComponent.new(count: 0))

      assert_selector 'span.cds--badge', text: '0'
    end

    # -- Colors --

    test 'renders red color' do
      render_inline(Carbon::BadgeComponent.new(color: :red, count: 1))

      assert_selector '.cds--badge--red'
    end

    test 'renders blue color' do
      render_inline(Carbon::BadgeComponent.new(color: :blue, count: 1))

      assert_selector '.cds--badge--blue'
    end

    test 'renders green color' do
      render_inline(Carbon::BadgeComponent.new(color: :green, count: 1))

      assert_selector '.cds--badge--green'
    end

    test 'renders gray color (default)' do
      render_inline(Carbon::BadgeComponent.new(count: 1))

      assert_selector '.cds--badge--gray'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::BadgeComponent.new(count: 1, id: 'my-badge', data: { testid: 'badge-1' }))

      assert_selector "span#my-badge[data-testid='badge-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::BadgeComponent.new(count: 1, class: 'my-custom-class'))

      assert_selector 'span.cds--badge.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid color' do
      assert_raises(ArgumentError) do
        Carbon::BadgeComponent.new(color: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for color' do
      render_inline(Carbon::BadgeComponent.new(count: 1, color: 'blue'))

      assert_selector '.cds--badge--blue'
    end
  end
end
