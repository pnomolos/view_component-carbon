# frozen_string_literal: true

require 'test_helper'

module Carbon
  class DatePickerComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default date picker' do
      render_inline(Carbon::DatePickerComponent.new)

      assert_selector 'div.cds--form-item'
      assert_selector 'div.cds--date-picker'
      assert_selector 'div.cds--date-picker--simple'
    end

    test 'renders with date-picker-container' do
      render_inline(Carbon::DatePickerComponent.new)

      assert_selector 'div.cds--date-picker-container'
    end

    test 'renders input with date-picker__input class' do
      render_inline(Carbon::DatePickerComponent.new)

      assert_selector 'input.cds--date-picker__input[type="text"]'
    end

    test 'renders label' do
      render_inline(Carbon::DatePickerComponent.new(label_text: 'Start date'))

      assert_selector 'label.cds--label', text: 'Start date'
    end

    test 'renders default label text' do
      render_inline(Carbon::DatePickerComponent.new)

      assert_selector 'label.cds--label', text: 'Date Picker label'
    end

    # -- Types --

    test 'renders simple type by default' do
      render_inline(Carbon::DatePickerComponent.new)

      assert_selector 'div.cds--date-picker--simple'
      assert_no_selector '[data-controller]'
    end

    test 'renders single type' do
      render_inline(Carbon::DatePickerComponent.new(type: :single))

      assert_selector 'div.cds--date-picker--single'
    end

    test 'renders range type' do
      render_inline(Carbon::DatePickerComponent.new(type: :range))

      assert_selector 'div.cds--date-picker--range'
    end

    test 'raises ArgumentError for invalid type' do
      assert_raises(ArgumentError) do
        Carbon::DatePickerComponent.new(type: :invalid)
      end
    end

    # -- Stimulus controller --

    test 'simple type has no stimulus controller' do
      render_inline(Carbon::DatePickerComponent.new(type: :simple))

      assert_no_selector '[data-controller="carbon--date-picker"]'
    end

    test 'single type has stimulus controller' do
      render_inline(Carbon::DatePickerComponent.new(type: :single))

      assert_selector '[data-controller="carbon--date-picker"]'
      assert_selector '[data-carbon--date-picker-type-value="single"]'
    end

    test 'range type has stimulus controller' do
      render_inline(Carbon::DatePickerComponent.new(type: :range))

      assert_selector '[data-controller="carbon--date-picker"]'
      assert_selector '[data-carbon--date-picker-type-value="range"]'
    end

    test 'stimulus controller receives date format value' do
      render_inline(Carbon::DatePickerComponent.new(type: :single, date_format: 'd/m/Y'))

      assert_selector '[data-carbon--date-picker-date-format-value="d/m/Y"]'
    end

    # -- Input target --

    test 'single type input has stimulus target' do
      render_inline(Carbon::DatePickerComponent.new(type: :single))

      assert_selector 'input[data-carbon--date-picker-target="input"]'
    end

    test 'simple type input has no stimulus target' do
      render_inline(Carbon::DatePickerComponent.new(type: :simple))

      assert_no_selector 'input[data-carbon--date-picker-target]'
    end

    # -- Calendar icon --

    test 'simple type has no calendar icon' do
      render_inline(Carbon::DatePickerComponent.new(type: :simple))

      assert_no_selector '.cds--date-picker__icon'
    end

    test 'single type has calendar icon' do
      render_inline(Carbon::DatePickerComponent.new(type: :single))

      assert_selector 'svg.cds--date-picker__icon'
    end

    test 'range type has calendar icon' do
      render_inline(Carbon::DatePickerComponent.new(type: :range))

      assert_selector 'svg.cds--date-picker__icon'
    end

    # -- Placeholder --

    test 'renders default placeholder' do
      render_inline(Carbon::DatePickerComponent.new)

      assert_selector 'input[placeholder="mm/dd/yyyy"]'
    end

    test 'renders custom placeholder' do
      render_inline(Carbon::DatePickerComponent.new(placeholder: 'dd/mm/yyyy'))

      assert_selector 'input[placeholder="dd/mm/yyyy"]'
    end

    # -- Value --

    test 'renders with value' do
      render_inline(Carbon::DatePickerComponent.new(value: '01/15/2025'))

      assert_selector 'input[value="01/15/2025"]'
    end

    # -- Form attributes --

    test 'renders with name attribute' do
      render_inline(Carbon::DatePickerComponent.new(name: 'start_date'))

      assert_selector 'input[name="start_date"]'
    end

    test 'renders with id attribute' do
      render_inline(Carbon::DatePickerComponent.new(id: 'my-date'))

      assert_selector 'input#my-date'
    end

    test 'label for matches input id' do
      render_inline(Carbon::DatePickerComponent.new(id: 'my-date'))

      assert_selector 'label[for="my-date"]'
      assert_selector 'input#my-date'
    end

    # -- States --

    test 'renders disabled state' do
      render_inline(Carbon::DatePickerComponent.new(disabled: true))

      assert_selector 'input[disabled]'
      assert_selector 'label.cds--label--disabled'
    end

    test 'renders readonly state' do
      render_inline(Carbon::DatePickerComponent.new(readonly: true))

      assert_selector 'input[readonly]'
    end

    # -- Validation states --

    test 'renders invalid state' do
      render_inline(Carbon::DatePickerComponent.new(invalid: true, invalid_text: 'Invalid date'))

      assert_selector '.cds--form-requirement', text: 'Invalid date'
      assert_selector 'input[data-invalid]'
    end

    test 'renders warning state' do
      render_inline(Carbon::DatePickerComponent.new(warn: true, warn_text: 'Check date'))

      assert_selector '.cds--form-requirement', text: 'Check date'
    end

    test 'renders helper text' do
      render_inline(Carbon::DatePickerComponent.new(helper_text: 'Use mm/dd/yyyy'))

      assert_selector '.cds--form__helper-text', text: 'Use mm/dd/yyyy'
    end

    test 'helper text hidden when invalid' do
      render_inline(Carbon::DatePickerComponent.new(helper_text: 'Help', invalid: true, invalid_text: 'Error'))

      assert_no_selector '.cds--form__helper-text'
      assert_selector '.cds--form-requirement', text: 'Error'
    end

    # -- Min/Max dates --

    test 'renders min date as stimulus value' do
      render_inline(Carbon::DatePickerComponent.new(type: :single, min_date: '2025-01-01'))

      assert_selector '[data-carbon--date-picker-min-date-value="2025-01-01"]'
    end

    test 'renders max date as stimulus value' do
      render_inline(Carbon::DatePickerComponent.new(type: :single, max_date: '2025-12-31'))

      assert_selector '[data-carbon--date-picker-max-date-value="2025-12-31"]'
    end

    # -- Range type --

    test 'range type renders second input with slot' do
      render_inline(Carbon::DatePickerComponent.new(type: :range)) do |c|
        c.with_range_input(label_text: 'End date')
      end

      assert_selector '.cds--date-picker-container', count: 2
      assert_selector 'label.cds--label', text: 'End date'
    end

    test 'range input has stimulus target' do
      render_inline(Carbon::DatePickerComponent.new(type: :range)) do |c|
        c.with_range_input(label_text: 'End date')
      end

      assert_selector 'input[data-carbon--date-picker-target="rangeInput"]'
    end

    # -- ARIA --

    test 'input has aria-describedby when helper text present' do
      render_inline(Carbon::DatePickerComponent.new(helper_text: 'Help text'))

      input = page.find('input.cds--date-picker__input')
      describedby_id = input['aria-describedby']

      assert_predicate describedby_id, :present?
      assert_selector "##{describedby_id}", text: 'Help text'
    end

    test 'input has aria-describedby when invalid text present' do
      render_inline(Carbon::DatePickerComponent.new(invalid: true, invalid_text: 'Error'))

      input = page.find('input.cds--date-picker__input')
      describedby_id = input['aria-describedby']

      assert_predicate describedby_id, :present?
      assert_selector "##{describedby_id}", text: 'Error'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::DatePickerComponent.new(type: :single, id: 'date-input',
                                                    data: { custom: 'value' }))

      assert_selector '[data-custom="value"]'
    end

    test 'merges custom class' do
      render_inline(Carbon::DatePickerComponent.new(class: 'custom-picker'))

      assert_selector 'div.cds--date-picker.custom-picker'
    end
  end
end
