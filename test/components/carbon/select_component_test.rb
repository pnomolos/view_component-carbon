# frozen_string_literal: true

require 'test_helper'

module Carbon
  class SelectComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default select' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'div.cds--form-item'
      assert_selector 'div.cds--select'
      assert_selector 'select.cds--select-input'
    end

    test 'renders label' do
      render_inline(Carbon::SelectComponent.new(label_text: 'Country')) do |c|
        c.with_option(value: 'us', text: 'United States')
      end

      assert_selector 'label.cds--label', text: 'Country'
    end

    test 'label for matches select id' do
      render_inline(Carbon::SelectComponent.new(id: 'country-select', label_text: 'Country')) do |c|
        c.with_option(value: 'us', text: 'United States')
      end

      assert_selector 'label[for="country-select"]'
      assert_selector 'select#country-select'
    end

    # -- Options --

    test 'renders options' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'opt1', text: 'Option 1')
        c.with_option(value: 'opt2', text: 'Option 2')
      end

      assert_selector 'option.cds--select-option', count: 2
      assert_selector 'option[value="opt1"]', text: 'Option 1'
      assert_selector 'option[value="opt2"]', text: 'Option 2'
    end

    test 'renders selected option' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'opt1', text: 'Option 1')
        c.with_option(value: 'opt2', text: 'Option 2', selected: true)
      end

      assert_selector 'option[value="opt2"][selected]'
    end

    test 'renders disabled option' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'opt1', text: 'Disabled', disabled: true)
      end

      assert_selector 'option[disabled]'
    end

    # -- Option groups --

    test 'renders option groups' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option_group(label: 'Fruits') do |group|
          group.with_option(value: 'apple', text: 'Apple')
          group.with_option(value: 'banana', text: 'Banana')
        end
        c.with_option_group(label: 'Vegetables') do |group|
          group.with_option(value: 'carrot', text: 'Carrot')
        end
      end

      assert_selector 'optgroup[label="Fruits"]'
      assert_selector 'optgroup[label="Vegetables"]'
      assert_selector 'optgroup[label="Fruits"] option', count: 2
      assert_selector 'optgroup[label="Vegetables"] option', count: 1
    end

    # -- Sizes --

    test 'renders default md size without modifier class' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_no_selector 'select.cds--select-input--md'
    end

    test 'renders sm size' do
      render_inline(Carbon::SelectComponent.new(size: :sm)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select.cds--select-input--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::SelectComponent.new(size: :lg)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select.cds--select-input--lg'
    end

    # -- States --

    test 'renders disabled state' do
      render_inline(Carbon::SelectComponent.new(disabled: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--select--disabled'
      assert_selector 'select[disabled]'
      assert_selector 'label.cds--label--disabled'
    end

    test 'renders invalid state' do
      render_inline(Carbon::SelectComponent.new(invalid: true, invalid_text: 'Required field')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--select--invalid'
      assert_selector 'select[aria-invalid="true"]'
      assert_selector '.cds--form-requirement', text: 'Required field'
    end

    test 'renders warning state' do
      render_inline(Carbon::SelectComponent.new(warn: true, warn_text: 'Be careful')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--select--warning'
      assert_selector '.cds--form-requirement', text: 'Be careful'
    end

    test 'renders helper text' do
      render_inline(Carbon::SelectComponent.new(helper_text: 'Choose wisely')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--form__helper-text', text: 'Choose wisely'
    end

    # -- Inline --

    test 'renders inline variant' do
      render_inline(Carbon::SelectComponent.new(inline: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--select--inline'
    end

    # -- Label --

    test 'hides label when hide_label is true' do
      render_inline(Carbon::SelectComponent.new(hide_label: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'label.cds--visually-hidden'
    end

    # -- Name --

    test 'renders name attribute' do
      render_inline(Carbon::SelectComponent.new(name: 'country')) do |c|
        c.with_option(value: 'us', text: 'US')
      end

      assert_selector 'select[name="country"]'
    end

    # -- Chevron --

    test 'renders chevron arrow icon' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--select-input__wrapper svg.cds--select__arrow'
    end

    # -- Invalid icon --

    test 'renders warning icon when invalid' do
      render_inline(Carbon::SelectComponent.new(invalid: true, invalid_text: 'Error')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--select-input__wrapper svg.cds--text-input__invalid-icon'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::SelectComponent.new(size: :xl)
      end
    end

    # -- System arguments --

    test 'passes through system arguments to select' do
      render_inline(Carbon::SelectComponent.new(data: { testid: 'my-select' })) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select[data-testid="my-select"]'
    end

    test 'merges custom class' do
      render_inline(Carbon::SelectComponent.new(class: 'custom-select')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--select.custom-select'
    end

    # -- P0 Accessibility fixes --

    test 'adds aria-readonly attribute' do
      render_inline(Carbon::SelectComponent.new(readonly: false)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select[aria-readonly="false"]'
    end

    test 'sets aria-readonly to true when readonly' do
      render_inline(Carbon::SelectComponent.new(readonly: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select[aria-readonly="true"]'
    end

    test 'adds title attribute with value' do
      render_inline(Carbon::SelectComponent.new(value: 'us')) do |c|
        c.with_option(value: 'us', text: 'United States')
      end

      assert_selector 'select[title="us"]'
    end

    test 'does not add title when no value' do
      render_inline(Carbon::SelectComponent.new) do |c|
        c.with_option(value: 'us', text: 'United States')
      end

      assert_no_selector 'select[title]'
    end

    test 'adds required attribute' do
      render_inline(Carbon::SelectComponent.new(required: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select[required]'
    end

    # -- P1 Correctness fixes --

    test 'readonly prop renders readonly class' do
      render_inline(Carbon::SelectComponent.new(readonly: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--select--readonly'
    end

    test 'readonly normalizes disabled state' do
      render_inline(Carbon::SelectComponent.new(readonly: true, disabled: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      # When readonly, disabled is normalized to false
      assert_no_selector 'select[disabled]'
      assert_no_selector 'div.cds--select--disabled'
    end

    test 'readonly normalizes invalid state' do
      render_inline(Carbon::SelectComponent.new(readonly: true, invalid: true, invalid_text: 'Error')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      # When readonly, invalid is normalized to false
      assert_no_selector 'select[aria-invalid]'
      assert_no_selector 'div.cds--select--invalid'
      assert_no_selector '.cds--form-requirement', text: 'Error'
    end

    test 'readonly normalizes warn state' do
      render_inline(Carbon::SelectComponent.new(readonly: true, warn: true, warn_text: 'Warning')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      # When readonly, warn is normalized to false
      assert_no_selector 'div.cds--select--warning'
      assert_no_selector '.cds--form-requirement', text: 'Warning'
    end

    test 'placeholder renders as disabled hidden option' do
      render_inline(Carbon::SelectComponent.new(placeholder: 'Choose an option')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'option[disabled][value=""]', text: 'Choose an option', visible: :hidden
    end

    test 'inline wrapper structure' do
      render_inline(Carbon::SelectComponent.new(inline: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--select-input--inline__wrapper'
      assert_selector '.cds--select-input--inline__wrapper > .cds--select-input__wrapper'
    end

    test 'inline wrapper has data-invalid when invalid' do
      render_inline(Carbon::SelectComponent.new(inline: true, invalid: true, invalid_text: 'Error')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--select-input--inline__wrapper[data-invalid]'
      assert_selector '.cds--select-input__wrapper[data-invalid]'
    end

    # -- P2 Feature additions --

    test 'renders autofocus attribute' do
      render_inline(Carbon::SelectComponent.new(autofocus: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select[autofocus]'
    end

    test 'renders pattern attribute' do
      render_inline(Carbon::SelectComponent.new(pattern: '[A-Z]+')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector 'select[pattern="[A-Z]+"]'
    end

    test 'fluid layout renders divider inside wrapper' do
      render_inline(Carbon::SelectComponent.new(is_fluid: true)) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--select-input__wrapper hr.cds--select__divider'
    end

    test 'fluid layout renders error text' do
      render_inline(Carbon::SelectComponent.new(is_fluid: true, invalid: true, invalid_text: 'Required')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--form-requirement', text: 'Required'
    end

    test 'non-fluid layout shows helper text outside wrapper' do
      render_inline(Carbon::SelectComponent.new(is_fluid: false, helper_text: 'Help')) do |c|
        c.with_option(value: 'a', text: 'A')
      end

      assert_selector '.cds--form__helper-text', text: 'Help'
    end
  end
end
