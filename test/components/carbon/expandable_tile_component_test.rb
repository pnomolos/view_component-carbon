# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ExpandableTileComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default expandable tile' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'div.cds--tile.cds--tile--expandable'
    end

    test 'renders chevron button' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button.cds--tile__chevron[type="button"]'
    end

    # -- Slots --

    test 'renders above the fold content' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above content' }
        c.with_below_the_fold { 'Below content' }
      end

      assert_selector '.cds--tile-content__above-the-fold', text: 'Above content'
    end

    test 'renders below the fold content' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above content' }
        c.with_below_the_fold { 'Below content' }
      end

      assert_selector '.cds--tile-content__below-the-fold', text: 'Below content'
    end

    # -- Expanded state --

    test 'does not render expanded class by default' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_no_selector '.cds--tile--is-expanded'
    end

    test 'renders expanded class when expanded' do
      render_inline(Carbon::ExpandableTileComponent.new(expanded: true)) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'div.cds--tile--is-expanded'
    end

    test 'renders aria-expanded false by default' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button[aria-expanded="false"]'
    end

    test 'renders aria-expanded true when expanded' do
      render_inline(Carbon::ExpandableTileComponent.new(expanded: true)) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button[aria-expanded="true"]'
    end

    # -- Aria controls --

    test 'chevron aria-controls links to below fold id' do
      render_inline(Carbon::ExpandableTileComponent.new(id: 'my-tile')) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button[aria-controls="my-tile-below"]'
      assert_selector '#my-tile-below.cds--tile-content__below-the-fold'
    end

    # -- Aria label --

    test 'renders default aria label for collapsed' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button[aria-label="Interact to expand tile"]'
    end

    test 'renders expanded aria label when expanded' do
      render_inline(Carbon::ExpandableTileComponent.new(expanded: true)) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button[aria-label="Interact to collapse tile"]'
    end

    # -- Stimulus --

    test 'renders stimulus controller' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector '[data-controller="carbon--expandable-tile"]'
    end

    test 'renders stimulus expanded value' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector '[data-carbon--expandable-tile-expanded-value="false"]'
    end

    test 'renders stimulus targets' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'button[data-carbon--expandable-tile-target="chevron"]'
      assert_selector '[data-carbon--expandable-tile-target="belowFold"]'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::ExpandableTileComponent.new(id: 'custom-tile', class: 'extra')) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector 'div#custom-tile.cds--tile.extra'
    end

    # -- Color scheme --

    test 'renders regular color scheme by default' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_no_selector '.cds--tile--light'
    end

    test 'renders light color scheme' do
      render_inline(Carbon::ExpandableTileComponent.new(color_scheme: :light)) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector '.cds--tile--light'
    end

    test 'raises error for invalid color scheme' do
      assert_raises(ArgumentError) do
        Carbon::ExpandableTileComponent.new(color_scheme: :invalid)
      end
    end

    # -- Interactive content --

    test 'does not render interactive content class by default' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_no_selector '.cds--tile-content__has-interactive-content'
      assert_no_selector '.cds--tile__chevron--interactive'
    end

    test 'renders interactive content classes when enabled' do
      render_inline(Carbon::ExpandableTileComponent.new(with_interactive: true)) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector '.cds--tile-content__has-interactive-content'
      assert_selector '.cds--tile__chevron--interactive'
    end

    # -- Rounded corners --

    test 'does not render rounded corners by default' do
      render_inline(Carbon::ExpandableTileComponent.new) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_no_selector '.cds--tile--slug-rounded'
    end

    test 'renders rounded corners class when enabled' do
      render_inline(Carbon::ExpandableTileComponent.new(has_rounded_corners: true)) do |c|
        c.with_above_the_fold { 'Above' }
        c.with_below_the_fold { 'Below' }
      end

      assert_selector '.cds--tile--slug-rounded'
    end
  end
end
