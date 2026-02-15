# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TabsComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default tabs' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      assert_selector 'div.cds--tabs'
    end

    test 'renders with stimulus controller' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      assert_selector 'div[data-controller="carbon--tabs"]'
    end

    test 'renders tabs nav' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      assert_selector '.cds--tabs__nav[role="tablist"]'
    end

    # -- Type --

    test 'renders default type' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_no_selector 'div.cds--tabs--contained'
    end

    test 'renders contained type' do
      render_inline(Carbon::TabsComponent.new(type: :contained)) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_selector 'div.cds--tabs--contained'
    end

    # -- Tab Component --

    test 'renders tab buttons' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'First') { 'Content 1' }
        c.with_tab(label: 'Second') { 'Content 2' }
      end

      assert_selector 'button.cds--tabs__nav-link[role="tab"]', count: 2
      assert_selector 'button', text: 'First'
      assert_selector 'button', text: 'Second'
    end

    test 'renders tab panels' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Panel Content 1' }
        c.with_tab(label: 'Tab 2') { 'Panel Content 2' }
      end

      assert_selector '.cds--tab-content[role="tabpanel"]', count: 2, visible: :all
      assert_selector '.cds--tab-content', text: 'Panel Content 1', visible: :all
      assert_selector '.cds--tab-content', text: 'Panel Content 2', visible: :all
    end

    test 'renders selected tab' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1', selected: true) { 'Content 1' }
        c.with_tab(label: 'Tab 2') { 'Content 2' }
      end

      selected_tab = page.find('button', text: 'Tab 1')

      assert_equal 'true', selected_tab['aria-selected']
      assert_equal '0', selected_tab['tabindex']

      unselected_tab = page.find('button', text: 'Tab 2')

      assert_equal 'false', unselected_tab['aria-selected']
      assert_equal '-1', unselected_tab['tabindex']
    end

    test 'hides unselected panels' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1', selected: true) { 'Content 1' }
        c.with_tab(label: 'Tab 2') { 'Content 2' }
      end

      panels = page.all('.cds--tab-content', visible: :all)

      assert_nil panels[0]['hidden']
      assert_equal '', panels[1]['hidden']
    end

    test 'renders disabled tab' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Disabled', disabled: true) { 'Content' }
      end

      assert_selector 'button.cds--tabs__nav-link--disabled[disabled]'
    end

    test 'renders tab with stimulus action' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_selector 'button[data-action="click->carbon--tabs#select"]'
    end

    test 'renders tab with stimulus target' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_selector 'button[data-carbon--tabs-target="tab"]'
    end

    test 'renders panel with stimulus target' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_selector '.cds--tab-content[data-carbon--tabs-target="panel"]', visible: :all
    end

    test 'tab and panel have matching ids' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      tab = page.find('button[role="tab"]')
      panel_id = tab['data-panel-id']

      assert_selector ".cds--tab-content[data-panel-id='#{panel_id}']", visible: :all
      assert_selector ".cds--tab-content##{panel_id}", visible: :all
    end

    # -- Validation --

    test 'raises ArgumentError for invalid type' do
      assert_raises(ArgumentError) do
        Carbon::TabsComponent.new(type: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::TabsComponent.new(id: 'my-tabs')) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_selector 'div#my-tabs'
    end

    test 'merges custom class' do
      render_inline(Carbon::TabsComponent.new(class: 'custom-tabs')) do |c|
        c.with_tab(label: 'Tab') { 'Content' }
      end

      assert_selector 'div.cds--tabs.custom-tabs'
    end
  end
end
