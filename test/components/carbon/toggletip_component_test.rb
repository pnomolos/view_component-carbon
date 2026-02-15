# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ToggletipComponentTest < CarbonViewComponents::TestCase
    test 'renders default toggletip' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Toggletip content' }
      end

      assert_selector 'span.cds--toggletip.cds--popover--bottom'
      assert_selector 'button.cds--toggletip__button'
    end

    test 'renders toggletip button with info icon' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'button.cds--toggletip__button svg'
    end

    test 'renders toggletip content in body slot' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Helpful information' }
      end

      assert_selector '.cds--toggletip-content', text: 'Helpful information'
    end

    test 'renders with top alignment' do
      render_inline(Carbon::ToggletipComponent.new(align: :top)) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span.cds--popover--top'
    end

    test 'renders with bottom alignment' do
      render_inline(Carbon::ToggletipComponent.new(align: :bottom)) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span.cds--popover--bottom'
    end

    test 'renders with left alignment' do
      render_inline(Carbon::ToggletipComponent.new(align: :left)) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span.cds--popover--left'
    end

    test 'renders with right alignment' do
      render_inline(Carbon::ToggletipComponent.new(align: :right)) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span.cds--popover--right'
    end

    test 'has Stimulus controller' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span[data-controller="carbon--toggletip"]'
    end

    test 'button has correct ARIA attributes' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'button[type="button"][aria-expanded="false"]'
    end

    test 'button has click action' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'button[data-action="click->carbon--toggletip#toggle"]'
    end

    test 'includes popover caret' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Content' }
      end

      assert_selector '.cds--popover-caret'
    end

    test 'passes through system arguments' do
      render_inline(Carbon::ToggletipComponent.new(id: 'my-toggletip')) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span#my-toggletip'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::ToggletipComponent.new(class: 'custom-class')) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span.cds--toggletip.custom-class'
    end

    test 'raises ArgumentError for invalid alignment' do
      assert_raises(ArgumentError) do
        Carbon::ToggletipComponent.new(align: :invalid)
      end
    end

    test 'accepts string values for alignment' do
      render_inline(Carbon::ToggletipComponent.new(align: 'top')) do |c|
        c.with_body { 'Content' }
      end

      assert_selector 'span.cds--popover--top'
    end
  end
end
