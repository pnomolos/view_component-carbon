# frozen_string_literal: true

require 'test_helper'

module Carbon
  class CheckboxComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default checkbox' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Accept terms'))

      assert_selector '.cds--form-item.cds--checkbox-wrapper'
      assert_selector 'input.cds--checkbox[type="checkbox"]'
      assert_selector 'label.cds--checkbox-label .cds--checkbox-label-text', text: 'Accept terms'
    end

    test 'checkbox has generated id and label for attribute matches' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test'))

      checkbox = page.find('input[type="checkbox"]')
      label = page.find('label')

      assert_predicate checkbox[:id], :present?
      assert_equal checkbox[:id], label[:for]
    end

    # -- Name and value --

    test 'renders with name attribute' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', name: 'terms'))

      assert_selector 'input[name="terms"]'
    end

    test 'renders with value attribute' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', value: 'yes'))

      assert_selector 'input[value="yes"]'
    end

    # -- Checked state --

    test 'renders unchecked by default' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test'))

      assert_no_selector 'input[checked]'
      assert_selector 'input[aria-checked="false"]'
    end

    test 'renders checked when checked is true' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', checked: true))

      assert_selector 'input[checked]'
      assert_selector 'input[aria-checked="true"]'
    end

    # -- Disabled state --

    test 'renders enabled by default' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test'))

      assert_no_selector 'input[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', disabled: true))

      assert_selector 'input[disabled]'
    end

    # -- Indeterminate state --

    test 'renders with aria-checked mixed when indeterminate' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', indeterminate: true))

      assert_selector 'input[aria-checked="mixed"]'
    end

    test 'adds stimulus controller when indeterminate' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', indeterminate: true))

      assert_selector '[data-controller="carbon--checkbox"]'
      assert_selector '[data-carbon--checkbox-indeterminate-value="true"]'
    end

    test 'does not add stimulus controller when not indeterminate' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test'))

      assert_no_selector '[data-controller="carbon--checkbox"]'
    end

    # -- Custom ID --

    test 'uses custom id when provided' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', id: 'custom-checkbox'))

      assert_selector 'input#custom-checkbox'
      assert_selector 'label[for="custom-checkbox"]'
    end

    # -- Hide label --

    test 'renders visible label by default' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test'))

      assert_selector 'label.cds--checkbox-label'
      assert_no_selector 'label.cds--visually-hidden'
    end

    test 'hides label visually when hide_label is true' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', hide_label: true))

      assert_selector 'label.cds--checkbox-label.cds--visually-hidden'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::CheckboxComponent.new(
          label_text: 'Test',
          data: { testid: 'checkbox-1' },
          aria: { describedby: 'hint' }
        )
      )

      assert_selector 'input[data-testid="checkbox-1"]'
      assert_selector 'input[aria-describedby="hint"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Test', class: 'my-custom-class'))

      assert_selector '.cds--form-item.cds--checkbox-wrapper.my-custom-class'
    end
  end
end
