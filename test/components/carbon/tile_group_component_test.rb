# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TileGroupComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders fieldset with tile-group class' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors')) do |c|
        c.with_tile(value: 'red') { 'Red' }
      end

      assert_selector 'fieldset.cds--tile-group'
    end

    test 'renders legend when provided' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors', legend: 'Choose a color')) do |c|
        c.with_tile(value: 'red') { 'Red' }
      end

      assert_selector 'legend.cds--label', text: 'Choose a color'
    end

    test 'does not render legend when not provided' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors')) do |c|
        c.with_tile(value: 'red') { 'Red' }
      end

      assert_no_selector 'legend'
    end

    # -- Tiles rendering --

    test 'renders radio tiles' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors')) do |c|
        c.with_tile(value: 'red') { 'Red' }
        c.with_tile(value: 'blue') { 'Blue' }
      end

      assert_selector 'input[type="radio"]', count: 2
    end

    test 'passes name to all tiles' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors')) do |c|
        c.with_tile(value: 'red') { 'Red' }
        c.with_tile(value: 'blue') { 'Blue' }
      end

      assert_selector 'input[name="colors"]', count: 2
    end

    # -- Default selected --

    test 'selects tile matching default_selected' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors', default_selected: 'blue')) do |c|
        c.with_tile(value: 'red') { 'Red' }
        c.with_tile(value: 'blue') { 'Blue' }
      end

      assert_selector 'input[value="blue"][checked]'
      assert_no_selector 'input[value="red"][checked]'
    end

    test 'marks selected tile label with is-selected class' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors', default_selected: 'blue')) do |c|
        c.with_tile(value: 'red') { 'Red' }
        c.with_tile(value: 'blue') { 'Blue' }
      end

      assert_selector 'label.cds--tile--is-selected', count: 1
    end

    # -- Disabled --

    test 'propagates disabled to all tiles' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors', disabled: true)) do |c|
        c.with_tile(value: 'red') { 'Red' }
        c.with_tile(value: 'blue') { 'Blue' }
      end

      assert_selector 'input[disabled]', count: 2
    end

    # -- Stimulus --

    test 'renders stimulus controller' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors')) do |c|
        c.with_tile(value: 'red') { 'Red' }
      end

      assert_selector 'fieldset[data-controller="carbon--tile-group"]'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::TileGroupComponent.new(name: 'colors', id: 'my-group', class: 'extra')) do |c|
        c.with_tile(value: 'red') { 'Red' }
      end

      assert_selector 'fieldset#my-group.cds--tile-group.extra'
    end
  end
end
