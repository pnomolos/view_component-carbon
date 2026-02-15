# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TextInputComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default text input' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Username'))

      assert_selector '.cds--form-item.cds--text-input-wrapper'
      assert_selector 'label.cds--label', text: 'Username'
      assert_selector 'input.cds--text-input.cds--text-input--md[type="text"]'
    end

    test 'input has generated id and label for attribute matches' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test'))

      input = page.find('input[type="text"]')
      label = page.find('label')

      assert_predicate input[:id], :present?
      assert_equal input[:id], label[:for]
    end

    # -- Name and value --

    test 'renders with name attribute' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', name: 'username'))

      assert_selector 'input[name="username"]'
    end

    test 'renders with value attribute' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', value: 'John'))

      assert_selector 'input[value="John"]'
    end

    # -- Placeholder --

    test 'renders with placeholder' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', placeholder: 'Enter text'))

      assert_selector 'input[placeholder="Enter text"]'
    end

    # -- Sizes --

    test 'renders sm size' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', size: :sm))

      assert_selector 'input.cds--text-input--sm'
    end

    test 'renders md size (default)' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test'))

      assert_selector 'input.cds--text-input--md'
    end

    test 'renders lg size' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', size: :lg))

      assert_selector 'input.cds--text-input--lg'
    end

    # -- Types --

    test 'renders text type (default)' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test'))

      assert_selector 'input[type="text"]'
    end

    test 'renders password type' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', type: :password))

      assert_selector 'input[type="password"]'
    end

    test 'renders email type' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', type: :email))

      assert_selector 'input[type="email"]'
    end

    test 'renders url type' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', type: :url))

      assert_selector 'input[type="url"]'
    end

    # -- Disabled and readonly --

    test 'renders enabled by default' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test'))

      assert_no_selector 'input[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', disabled: true))

      assert_selector 'input[disabled]'
    end

    test 'renders readonly when readonly is true' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', readonly: true))

      assert_selector 'input[readonly]'
    end

    # -- Helper text --

    test 'renders helper text when provided' do
      render_inline(
        Carbon::TextInputComponent.new(
          label_text: 'Test',
          helper_text: 'Enter your username'
        )
      )

      assert_selector '.cds--form__helper-text', text: 'Enter your username'
    end

    test 'does not render helper text when not provided' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test'))

      assert_no_selector '.cds--form__helper-text'
    end

    # -- Invalid state --

    test 'renders invalid state with invalid text' do
      render_inline(
        Carbon::TextInputComponent.new(
          label_text: 'Test',
          invalid: true,
          invalid_text: 'This field is required'
        )
      )

      assert_selector 'input.cds--text-input--invalid[data-invalid="true"][aria-invalid="true"]'
      assert_selector '.cds--form-requirement', text: 'This field is required'
    end

    test 'does not show helper text when invalid' do
      render_inline(
        Carbon::TextInputComponent.new(
          label_text: 'Test',
          helper_text: 'Helper text',
          invalid: true,
          invalid_text: 'Invalid text'
        )
      )

      assert_no_selector '.cds--form__helper-text', text: 'Helper text'
      assert_selector '.cds--form-requirement', text: 'Invalid text'
    end

    # -- Warning state --

    test 'renders warning state with warning text' do
      render_inline(
        Carbon::TextInputComponent.new(
          label_text: 'Test',
          warn: true,
          warn_text: 'This value might be incorrect'
        )
      )

      assert_selector 'input.cds--text-input--warning[data-warn="true"]'
      assert_selector '.cds--text-input__field-wrapper--warning'
      assert_selector '.cds--form__helper-text--warning', text: 'This value might be incorrect'
    end

    test 'invalid takes precedence over warning' do
      render_inline(
        Carbon::TextInputComponent.new(
          label_text: 'Test',
          warn: true,
          warn_text: 'Warning',
          invalid: true,
          invalid_text: 'Invalid'
        )
      )

      assert_selector 'input.cds--text-input--invalid'
      assert_no_selector 'input.cds--text-input--warning'
      assert_no_selector '.cds--form__helper-text--warning'
      assert_selector '.cds--form-requirement', text: 'Invalid'
    end

    # -- Character counter --

    test 'does not add character counter by default' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test'))

      assert_no_selector '.cds--text-input__counter'
      assert_no_selector '[data-controller="carbon--text-input"]'
    end

    test 'adds character counter when max_count is provided' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', max_count: 100))

      assert_selector '[data-controller="carbon--text-input"]'
      assert_selector '[data-carbon--text-input-max-count-value="100"]'
      assert_selector '.cds--text-input__counter[data-carbon--text-input-target="counter"]', text: '0 / 100'
      assert_selector 'input[maxlength="100"]'
    end

    # -- Custom ID --

    test 'uses custom id when provided' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', id: 'custom-input'))

      assert_selector 'input#custom-input'
      assert_selector 'label[for="custom-input"]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::TextInputComponent.new(
          label_text: 'Test',
          data: { testid: 'input-1' },
          aria: { describedby: 'hint' }
        )
      )

      assert_selector 'input[data-testid="input-1"]'
      assert_selector 'input[aria-describedby="hint"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', class: 'my-custom-class'))

      assert_selector '.cds--form-item.cds--text-input-wrapper.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::TextInputComponent.new(label_text: 'Test', size: :invalid)
      end
    end

    test 'raises ArgumentError for invalid type' do
      assert_raises(ArgumentError) do
        Carbon::TextInputComponent.new(label_text: 'Test', type: :invalid)
      end
    end

    test 'accepts string values for size' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', size: 'sm'))

      assert_selector 'input.cds--text-input--sm'
    end

    test 'accepts string values for type' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Test', type: 'email'))

      assert_selector 'input[type="email"]'
    end
  end
end
