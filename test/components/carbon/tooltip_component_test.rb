# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TooltipComponentTest < CarbonViewComponents::TestCase
    test 'renders default tooltip' do
      render_inline(Carbon::TooltipComponent.new(label: 'This is a tooltip')) { 'Hover me' }

      assert_selector 'span.cds--tooltip.cds--popover--bottom'
      assert_selector 'button.cds--tooltip__trigger', text: 'Hover me'
    end

    test 'renders tooltip with label' do
      render_inline(Carbon::TooltipComponent.new(label: 'Helpful information')) { 'Button' }

      assert_selector '.cds--tooltip-content span', text: 'Helpful information'
    end

    test 'renders tooltip with description' do
      render_inline(Carbon::TooltipComponent.new(label: 'Label', description: 'Additional details')) { 'Button' }

      assert_selector '.cds--tooltip-content span', text: 'Label'
      assert_selector '.cds--tooltip__footer', text: 'Additional details'
    end

    test 'renders with top alignment' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', align: :top)) { 'Button' }

      assert_selector 'span.cds--popover--top'
    end

    test 'renders with bottom alignment' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', align: :bottom)) { 'Button' }

      assert_selector 'span.cds--popover--bottom'
    end

    test 'renders with left alignment' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', align: :left)) { 'Button' }

      assert_selector 'span.cds--popover--left'
    end

    test 'renders with right alignment' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', align: :right)) { 'Button' }

      assert_selector 'span.cds--popover--right'
    end

    test 'has Stimulus controller' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip')) { 'Button' }

      assert_selector 'span[data-controller="carbon--tooltip"]'
    end

    test 'trigger has correct ARIA attributes' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip')) { 'Button' }

      assert_selector 'button.cds--tooltip__trigger[aria-describedby]'
    end

    test 'tooltip content has role tooltip' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip')) { 'Button' }

      assert_selector '.cds--tooltip-content[role="tooltip"]'
    end

    test 'includes popover caret' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip')) { 'Button' }

      assert_selector '.cds--popover-caret'
    end

    test 'passes through system arguments' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', id: 'my-tooltip')) { 'Button' }

      assert_selector 'span#my-tooltip'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', class: 'custom-class')) { 'Button' }

      assert_selector 'span.cds--tooltip.custom-class'
    end

    test 'raises ArgumentError for invalid alignment' do
      assert_raises(ArgumentError) do
        Carbon::TooltipComponent.new(label: 'Tooltip', align: :invalid)
      end
    end

    test 'accepts string values for alignment' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tooltip', align: 'top')) { 'Button' }

      assert_selector 'span.cds--popover--top'
    end
  end
end
