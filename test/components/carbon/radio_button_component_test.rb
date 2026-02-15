# frozen_string_literal: true

require 'test_helper'

module Carbon
  class RadioButtonComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default radio button' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'size',
          value: 'small',
          label_text: 'Small'
        )
      )

      assert_selector '.cds--radio-button-wrapper'
      assert_selector 'input.cds--radio-button[type="radio"]'
      assert_selector 'label.cds--radio-button__label'
      assert_selector '.cds--radio-button__appearance'
      assert_selector '.cds--radio-button__label-text', text: 'Small'
    end

    test 'radio has generated id and label for attribute matches' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test'
        )
      )

      radio = page.find('input[type="radio"]')
      label = page.find('label')

      assert_predicate radio[:id], :present?
      assert_equal radio[:id], label[:for]
    end

    # -- Name and value --

    test 'renders with name attribute' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'color',
          value: 'red',
          label_text: 'Red'
        )
      )

      assert_selector 'input[name="color"]'
    end

    test 'renders with value attribute' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'color',
          value: 'blue',
          label_text: 'Blue'
        )
      )

      assert_selector 'input[value="blue"]'
    end

    # -- Checked state --

    test 'renders unchecked by default' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test'
        )
      )

      assert_no_selector 'input[checked]'
    end

    test 'renders checked when checked is true' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test',
          checked: true
        )
      )

      assert_selector 'input[checked]'
    end

    # -- Disabled state --

    test 'renders enabled by default' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test'
        )
      )

      assert_no_selector 'input[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test',
          disabled: true
        )
      )

      assert_selector 'input[disabled]'
    end

    # -- Custom ID --

    test 'uses custom id when provided' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test',
          id: 'custom-radio'
        )
      )

      assert_selector 'input#custom-radio'
      assert_selector 'label[for="custom-radio"]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test',
          data: { testid: 'radio-1' }
        )
      )

      assert_selector 'input[data-testid="radio-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(
        Carbon::RadioButtonComponent.new(
          name: 'test',
          value: 'val',
          label_text: 'Test',
          class: 'my-custom-class'
        )
      )

      assert_selector '.cds--radio-button-wrapper.my-custom-class'
    end
  end
end
