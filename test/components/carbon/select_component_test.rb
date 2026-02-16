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
  end
end
