# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TextAreaComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default text area' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Comments'))

      assert_selector '.cds--form-item'
      assert_no_selector '.cds--text-area-wrapper'
      assert_selector '.cds--text-area__label-wrapper label.cds--label', text: 'Comments'
      assert_selector 'textarea.cds--text-area'
      assert_selector '.cds--text-area__wrapper'
    end

    test 'textarea has generated id and label for attribute matches' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      textarea = page.find('textarea')
      label = page.find('label')

      assert_predicate textarea[:id], :present?
      assert_equal textarea[:id], label[:for]
    end

    # -- Name and value --

    test 'renders with name attribute' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', name: 'comments'))

      assert_selector 'textarea[name="comments"]'
    end

    test 'renders with value content' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', value: 'Some text content'))

      assert_selector 'textarea', text: 'Some text content'
    end

    # -- Placeholder --

    test 'renders with placeholder' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', placeholder: 'Enter your comments'))

      assert_selector 'textarea[placeholder="Enter your comments"]'
    end

    # -- Rows and cols --

    test 'renders with 4 rows by default' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      assert_selector 'textarea[rows="4"]'
    end

    test 'renders with custom rows' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', rows: 10))

      assert_selector 'textarea[rows="10"]'
    end

    test 'renders with custom cols' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', cols: 80))

      assert_selector 'textarea[cols="80"]'
    end

    # -- Disabled and readonly --

    test 'renders enabled by default' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      assert_no_selector 'textarea[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', disabled: true))

      assert_selector 'textarea[disabled]'
    end

    test 'renders readonly when readonly is true' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', readonly: true))

      assert_selector 'textarea[readonly]'
    end

    # -- Helper text --

    test 'renders helper text when provided' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          helper_text: 'Please provide detailed feedback'
        )
      )

      assert_selector '.cds--form__helper-text', text: 'Please provide detailed feedback'
    end

    test 'does not render helper text when not provided' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      assert_no_selector '.cds--form__helper-text'
    end

    test 'textarea has aria-describedby pointing to helper text' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          helper_text: 'Some help'
        )
      )

      helper = page.find('.cds--form__helper-text')
      textarea = page.find('textarea')

      assert_equal helper[:id], textarea[:'aria-describedby']
    end

    # -- Invalid state --

    test 'renders invalid state with invalid text' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          invalid: true,
          invalid_text: 'This field is required'
        )
      )

      assert_selector 'textarea[data-invalid][aria-invalid="true"]'
      assert_selector '.cds--text-area__wrapper--invalid'
      assert_selector '.cds--text-area__wrapper[data-invalid]'
      assert_selector '.cds--form-requirement', text: 'This field is required'
      assert_selector '.cds--text-area__wrapper svg.cds--text-input__invalid-icon'
    end

    test 'does not show helper text when invalid' do
      render_inline(
        Carbon::TextAreaComponent.new(
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
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          warn: true,
          warn_text: 'Check this value'
        )
      )

      assert_selector 'textarea[data-warn="true"]'
      assert_selector '.cds--text-area__wrapper--warn'
      assert_selector '.cds--form-requirement', text: 'Check this value'
      assert_selector '.cds--text-area__wrapper svg.cds--text-input__invalid-icon'
    end

    test 'invalid takes precedence over warning' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          warn: true,
          warn_text: 'Warning',
          invalid: true,
          invalid_text: 'Invalid'
        )
      )

      assert_selector '.cds--text-area__wrapper--invalid'
      assert_no_selector '.cds--text-area__wrapper--warn'
      assert_selector '.cds--form-requirement', text: 'Invalid'
    end

    # -- Character counter --

    test 'does not add character counter by default' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      assert_no_selector '.cds--text-area__counter'
      assert_no_selector '[data-controller="carbon--text-area"]'
    end

    test 'adds character counter when max_count is provided' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector '[data-controller="carbon--text-area"]'
      assert_selector '[data-carbon--text-area-max-count-value="500"]'
      assert_selector '.cds--text-area__label-wrapper ' \
                      '.cds--text-area__counter[data-carbon--text-area-target="counter"]',
                      text: '0 / 500'
      assert_selector 'textarea[maxlength="500"]'
    end

    test 'character counter has aria-live region' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector '.cds--text-area__counter[aria-live="polite"][aria-atomic="true"]'
    end

    # -- Custom ID --

    test 'uses custom id when provided' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', id: 'custom-textarea'))

      assert_selector 'textarea#custom-textarea'
      assert_selector 'label[for="custom-textarea"]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          data: { testid: 'textarea-1' },
          aria: { describedby: 'hint' }
        )
      )

      assert_selector 'textarea[data-testid="textarea-1"]'
      assert_selector 'textarea[aria-describedby="hint"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', class: 'my-custom-class'))

      assert_selector '.cds--form-item.my-custom-class'
    end

    # -- Empty value --

    test 'renders empty textarea when value is nil' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', value: nil))

      textarea = page.find('textarea')

      assert_equal '', textarea.text.strip
    end

    # -- P0 Accessibility: ARIA attributes --

    test 'textarea has aria-readonly when readonly' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', readonly: true))

      assert_selector 'textarea[aria-readonly="true"]'
    end

    test 'textarea does not have aria-readonly when not readonly' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      assert_no_selector 'textarea[aria-readonly]'
    end

    test 'counter has screen reader description when enabled' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector 'span.cds--visually-hidden', text: 'Character limit 500'
    end

    test 'counter description linked via aria-describedby' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      textarea = page.find('textarea')
      counter_desc = page.find('span.cds--visually-hidden', text: 'Character limit 500')

      assert_includes textarea[:'aria-describedby'], counter_desc[:id]
    end

    test 'counter has live region for announcements' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector 'span.cds--text-area__counter-alert[role="alert"][aria-live="assertive"][aria-atomic="true"]'
    end

    test 'live region has announcer target' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector 'span[data-carbon--text-area-target="announcer"]'
    end

    test 'aria-describedby includes both counter and helper text' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          helper_text: 'Help text',
          max_count: 500
        )
      )

      textarea = page.find('textarea')
      aria_describedby = textarea[:'aria-describedby']

      assert_match(/counter-desc/, aria_describedby)
      assert_match(/helper/, aria_describedby)
    end

    # -- P1 Correctness: CSS classes --

    test 'uses warn class not warning class' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', warn: true, warn_text: 'Warning'))

      assert_selector '.cds--text-area--warn'
      assert_no_selector '.cds--text-area--warning'
    end

    test 'label has disabled class when disabled' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', disabled: true))

      assert_selector 'label.cds--label--disabled'
    end

    test 'label does not have disabled class when not disabled' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test'))

      assert_no_selector 'label.cds--label--disabled'
    end

    test 'helper text has disabled class when disabled' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          helper_text: 'Help text',
          disabled: true
        )
      )

      assert_selector '.cds--form__helper-text--disabled'
    end

    test 'helper text does not have disabled class when not disabled' do
      render_inline(
        Carbon::TextAreaComponent.new(
          label_text: 'Test',
          helper_text: 'Help text'
        )
      )

      assert_no_selector '.cds--form__helper-text--disabled'
    end

    test 'counter has label class' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector '.cds--text-area__counter.cds--label'
    end

    test 'counter has label-counter class' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_selector '.cds--text-area__label-counter'
    end

    test 'counter has disabled class when disabled' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500, disabled: true))

      assert_selector '.cds--text-area__counter.cds--label--disabled'
    end

    test 'counter does not have disabled class when not disabled' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Test', max_count: 500))

      assert_no_selector '.cds--text-area__counter.cds--label--disabled'
    end

    test 'accepts counter_mode parameter' do
      component = Carbon::TextAreaComponent.new(label_text: 'Text', max_count: 100, counter_mode: 'word')

      assert_equal 'word', component.counter_mode
    end
  end
end
