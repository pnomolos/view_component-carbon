# frozen_string_literal: true

require 'test_helper'

module Carbon
  class NumberInputComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default number input' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Quantity'))

      assert_selector '.cds--form-item'
      assert_selector '.cds--number.cds--number--md[data-controller="carbon--number-input"]'
      assert_selector 'label.cds--label', text: 'Quantity'
      assert_selector 'input.cds--number__input[type="number"]'
      assert_selector '.cds--number__input-wrapper'
    end

    test 'renders increment and decrement buttons' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_selector 'button.cds--number__control-btn.down-icon[aria-label="Decrease number"]', text: '−'
      assert_selector 'button.cds--number__control-btn.up-icon[aria-label="Increase number"]', text: '+'
    end

    test 'buttons have stimulus actions' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_selector 'button[data-action="click->carbon--number-input#decrement"]'
      assert_selector 'button[data-action="click->carbon--number-input#increment"]'
    end

    test 'input has stimulus target' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_selector 'input[data-carbon--number-input-target="input"]'
    end

    # -- Name and value --

    test 'renders with name attribute' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', name: 'quantity'))

      assert_selector 'input[name="quantity"]'
    end

    test 'renders with value attribute' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', value: 42))

      assert_selector 'input[value="42"]'
    end

    # -- Min, max, step --

    test 'renders with min attribute' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', min: 0))

      assert_selector 'input[min="0"]'
    end

    test 'renders with max attribute' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', max: 100))

      assert_selector 'input[max="100"]'
    end

    test 'renders with step attribute' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', step: 5))

      assert_selector 'input[step="5"]'
    end

    test 'uses step 1 by default' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_selector 'input[step="1"]'
    end

    # -- Sizes --

    test 'renders sm size' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', size: :sm))

      assert_selector '.cds--number--sm'
    end

    test 'renders md size (default)' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_selector '.cds--number--md'
    end

    test 'renders lg size' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', size: :lg))

      assert_selector '.cds--number--lg'
    end

    # -- Disabled --

    test 'renders enabled by default' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_no_selector 'input[disabled]'
      assert_no_selector 'button[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', disabled: true))

      assert_selector 'input[disabled]'
      assert_selector 'button[disabled]', count: 2
    end

    # -- Helper text --

    test 'renders helper text when provided' do
      render_inline(
        Carbon::NumberInputComponent.new(
          label_text: 'Test',
          helper_text: 'Enter a number between 0 and 100'
        )
      )

      assert_selector '.cds--form__helper-text', text: 'Enter a number between 0 and 100'
    end

    test 'does not render helper text when not provided' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      assert_no_selector '.cds--form__helper-text'
    end

    # -- Invalid state --

    test 'renders invalid state with invalid text' do
      render_inline(
        Carbon::NumberInputComponent.new(
          label_text: 'Test',
          invalid: true,
          invalid_text: 'Value must be positive'
        )
      )

      assert_selector '.cds--number--invalid'
      assert_selector 'input[aria-invalid="true"]'
      assert_selector '.cds--form-requirement', text: 'Value must be positive'
    end

    test 'does not show helper text when invalid' do
      render_inline(
        Carbon::NumberInputComponent.new(
          label_text: 'Test',
          helper_text: 'Helper text',
          invalid: true,
          invalid_text: 'Invalid text'
        )
      )

      assert_no_selector '.cds--form__helper-text', text: 'Helper text'
      assert_selector '.cds--form-requirement', text: 'Invalid text'
    end

    # -- Custom ID --

    test 'generates id by default' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test'))

      input = page.find('input[type="number"]')
      label = page.find('label')

      assert_predicate input[:id], :present?
      assert_equal input[:id], label[:for]
    end

    test 'uses custom id when provided' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', id: 'custom-number'))

      assert_selector 'input#custom-number'
      assert_selector 'label[for="custom-number"]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::NumberInputComponent.new(
          label_text: 'Test',
          data: { testid: 'number-1' },
          aria: { describedby: 'hint' }
        )
      )

      assert_selector 'input[data-testid="number-1"]'
      assert_selector 'input[aria-describedby="hint"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', class: 'my-custom-class'))

      assert_selector '.cds--form-item.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::NumberInputComponent.new(label_text: 'Test', size: :invalid)
      end
    end

    test 'accepts string values for size' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Test', size: 'sm'))

      assert_selector '.cds--number--sm'
    end
  end
end
