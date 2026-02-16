# frozen_string_literal: true

require 'test_helper'

module Carbon
  class RadioButtonGroupComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default radio button group' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'size')) do |c|
        c.with_radio(value: 'small', label_text: 'Small')
        c.with_radio(value: 'medium', label_text: 'Medium')
      end

      assert_selector '.cds--form-item'
      assert_selector 'fieldset.cds--radio-button-group'
      assert_selector '.cds--radio-button-wrapper', count: 2
    end

    # -- Orientation --

    test 'renders vertical orientation by default' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'test')) do |c|
        c.with_radio(value: '1', label_text: 'One')
      end

      assert_selector 'fieldset.cds--radio-button-group--vertical'
    end

    test 'renders horizontal orientation' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'test', orientation: :horizontal)) do |c|
        c.with_radio(value: '1', label_text: 'One')
      end

      assert_selector 'fieldset.cds--radio-button-group--horizontal'
    end

    # -- Legend --

    test 'renders without legend by default' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'test')) do |c|
        c.with_radio(value: '1', label_text: 'One')
      end

      assert_no_selector 'legend'
    end

    test 'renders legend when legend_text is provided' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'test', legend_text: 'Choose size')) do |c|
        c.with_radio(value: 'small', label_text: 'Small')
      end

      assert_selector 'legend.cds--label', text: 'Choose size'
    end

    # -- Radio buttons --

    test 'renders multiple radio buttons with same name' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'color')) do |c|
        c.with_radio(value: 'red', label_text: 'Red')
        c.with_radio(value: 'blue', label_text: 'Blue')
        c.with_radio(value: 'green', label_text: 'Green')
      end

      assert_selector 'input[name="color"]', count: 3
      assert_selector 'input[value="red"]'
      assert_selector 'input[value="blue"]'
      assert_selector 'input[value="green"]'
    end

    test 'renders checked radio button' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'size')) do |c|
        c.with_radio(value: 'small', label_text: 'Small')
        c.with_radio(value: 'medium', label_text: 'Medium', checked: true)
      end

      assert_selector 'input[value="medium"][checked]'
      assert_no_selector 'input[value="small"][checked]'
    end

    test 'renders disabled radio button' do
      render_inline(Carbon::RadioButtonGroupComponent.new(name: 'size')) do |c|
        c.with_radio(value: 'small', label_text: 'Small', disabled: true)
        c.with_radio(value: 'medium', label_text: 'Medium')
      end

      assert_selector 'input[value="small"][disabled]'
      assert_no_selector 'input[value="medium"][disabled]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::RadioButtonGroupComponent.new(
          name: 'test',
          data: { testid: 'group-1' }
        )
      ) do |c|
        c.with_radio(value: '1', label_text: 'One')
      end

      assert_selector '[data-testid="group-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(
        Carbon::RadioButtonGroupComponent.new(
          name: 'test',
          class: 'my-custom-class'
        )
      ) do |c|
        c.with_radio(value: '1', label_text: 'One')
      end

      assert_selector '.cds--form-item.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid orientation' do
      assert_raises(ArgumentError) do
        Carbon::RadioButtonGroupComponent.new(name: 'test', orientation: :invalid)
      end
    end

    test 'accepts string values for orientation' do
      render_inline(
        Carbon::RadioButtonGroupComponent.new(name: 'test', orientation: 'horizontal')
      ) do |c|
        c.with_radio(value: '1', label_text: 'One')
      end

      assert_selector 'fieldset.cds--radio-button-group--horizontal'
    end
  end
end
