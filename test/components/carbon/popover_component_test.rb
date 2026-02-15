# frozen_string_literal: true

require 'test_helper'

module Carbon
  class PopoverComponentTest < CarbonViewComponents::TestCase
    test 'renders default popover' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Popover content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover-container.cds--popover--bottom'
      assert_selector '.cds--popover__trigger', text: 'Trigger'
    end

    test 'renders popover content in body slot' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Helpful information' }
        'Trigger'
      end

      assert_selector '.cds--popover-content', text: 'Helpful information'
    end

    test 'renders with top alignment' do
      render_inline(Carbon::PopoverComponent.new(align: :top)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--top'
    end

    test 'renders with bottom alignment' do
      render_inline(Carbon::PopoverComponent.new(align: :bottom)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--bottom'
    end

    test 'renders with left alignment' do
      render_inline(Carbon::PopoverComponent.new(align: :left)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--left'
    end

    test 'renders with right alignment' do
      render_inline(Carbon::PopoverComponent.new(align: :right)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--right'
    end

    test 'renders with drop shadow by default' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--drop-shadow'
    end

    test 'renders without drop shadow when disabled' do
      render_inline(Carbon::PopoverComponent.new(drop_shadow: false)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_no_selector 'span.cds--popover--drop-shadow'
    end

    test 'renders with high contrast' do
      render_inline(Carbon::PopoverComponent.new(high_contrast: true)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--high-contrast'
    end

    test 'renders without high contrast by default' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_no_selector 'span.cds--popover--high-contrast'
    end

    test 'renders with open state' do
      render_inline(Carbon::PopoverComponent.new(open: true)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--open'
    end

    test 'renders closed by default' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_no_selector 'span.cds--popover--open'
    end

    test 'renders with caret by default' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector '.cds--popover-caret'
    end

    test 'renders without caret when disabled' do
      render_inline(Carbon::PopoverComponent.new(caret: false)) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_no_selector '.cds--popover-caret'
    end

    test 'has Stimulus controller' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span[data-controller="carbon--popover"]'
    end

    test 'trigger has click action' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector '.cds--popover__trigger[data-action="click->carbon--popover#toggle"]'
    end

    test 'passes through system arguments' do
      render_inline(Carbon::PopoverComponent.new(id: 'my-popover')) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span#my-popover'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::PopoverComponent.new(class: 'custom-class')) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover-container.custom-class'
    end

    test 'raises ArgumentError for invalid alignment' do
      assert_raises(ArgumentError) do
        Carbon::PopoverComponent.new(align: :invalid)
      end
    end

    test 'accepts string values for alignment' do
      render_inline(Carbon::PopoverComponent.new(align: 'top')) do |c|
        c.with_body { 'Content' }
        'Trigger'
      end

      assert_selector 'span.cds--popover--top'
    end
  end
end
