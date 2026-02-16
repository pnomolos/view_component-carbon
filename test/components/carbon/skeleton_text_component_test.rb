# frozen_string_literal: true

require 'test_helper'

module Carbon
  class SkeletonTextComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default skeleton text with 3 lines' do
      render_inline(Carbon::SkeletonTextComponent.new)

      assert_selector 'p.cds--skeleton__text', count: 3
    end

    test 'renders paragraph skeleton with alternating widths' do
      render_inline(Carbon::SkeletonTextComponent.new(lines: 3))

      assert_selector 'p.cds--skeleton__text[style*="width: 100%"]', count: 2
      assert_selector 'p.cds--skeleton__text[style*="width: 75%"]', count: 1
    end

    # -- Heading variant --

    test 'renders heading skeleton when heading is true' do
      render_inline(Carbon::SkeletonTextComponent.new(heading: true))

      assert_selector 'h1.cds--skeleton__heading'
      assert_no_selector 'p.cds--skeleton__text'
    end

    # -- Lines --

    test 'renders specified number of lines' do
      render_inline(Carbon::SkeletonTextComponent.new(lines: 5))

      assert_selector 'p.cds--skeleton__text', count: 5
    end

    test 'renders single line when lines is 1' do
      render_inline(Carbon::SkeletonTextComponent.new(lines: 1))

      assert_selector 'p.cds--skeleton__text', count: 1
    end

    # -- Width --

    test 'renders single line with custom width when paragraph is false' do
      render_inline(Carbon::SkeletonTextComponent.new(lines: 1, paragraph: false, width: '50%'))

      assert_selector 'p.cds--skeleton__text[style*="width: 50%"]'
    end

    # -- Paragraph --

    test 'renders as paragraph by default when lines > 1' do
      render_inline(Carbon::SkeletonTextComponent.new(lines: 3))

      assert_selector 'p.cds--skeleton__text', count: 3
    end

    test 'renders single line when paragraph is false' do
      render_inline(Carbon::SkeletonTextComponent.new(lines: 1, paragraph: false))

      assert_selector 'p.cds--skeleton__text', count: 1
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::SkeletonTextComponent.new(id: 'my-skeleton', data: { testid: 'skeleton-1' }))

      assert_selector "p#my-skeleton[data-testid='skeleton-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::SkeletonTextComponent.new(class: 'my-custom-class'))

      assert_selector 'p.cds--skeleton__text.my-custom-class'
    end
  end
end
