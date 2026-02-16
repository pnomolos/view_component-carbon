# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TimePickerComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default time picker' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_selector '.cds--form-item'
      assert_selector '.cds--time-picker.cds--time-picker--md'
      assert_selector '.cds--time-picker__input label.cds--label', text: 'Time'
      assert_selector 'input.cds--time-picker__input-field.cds--text-input.cds--text-input--md[type="text"]'
    end

    test 'input has generated id and label for attribute matches' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      input = page.find('input[type="text"]')
      label = page.find('label')

      assert_predicate input[:id], :present?
      assert_equal input[:id], label[:for]
    end

    # -- Placeholder and pattern --

    test 'renders default placeholder hh:mm' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_selector 'input[placeholder="hh:mm"]'
    end

    test 'renders custom placeholder' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', placeholder: 'HH:MM'))

      assert_selector 'input[placeholder="HH:MM"]'
    end

    test 'renders maxlength 5' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_selector 'input[maxlength="5"]'
    end

    # -- Name and value --

    test 'renders with name attribute' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', name: 'start_time'))

      assert_selector 'input[name="start_time"]'
    end

    test 'renders with value attribute' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', value: '10:30'))

      assert_selector 'input[value="10:30"]'
    end

    # -- Sizes --

    test 'renders sm size' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', size: :sm))

      assert_selector '.cds--time-picker.cds--time-picker--sm'
      assert_selector 'input.cds--text-input--sm'
    end

    test 'renders md size (default)' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_selector '.cds--time-picker.cds--time-picker--md'
      assert_selector 'input.cds--text-input--md'
    end

    test 'renders lg size' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', size: :lg))

      assert_selector '.cds--time-picker.cds--time-picker--lg'
      assert_selector 'input.cds--text-input--lg'
    end

    # -- Disabled --

    test 'renders enabled by default' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_no_selector 'input[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', disabled: true))

      assert_selector 'input[disabled]'
    end

    # -- Invalid state --

    test 'renders invalid state with invalid text' do
      render_inline(
        Carbon::TimePickerComponent.new(
          label_text: 'Time',
          invalid: true,
          invalid_text: 'Invalid time format'
        )
      )

      assert_selector 'input[data-invalid][aria-invalid="true"]'
      assert_selector '.cds--time-picker--invalid'
      assert_selector '.cds--form-requirement', text: 'Invalid time format'
    end

    # -- Warning state --

    test 'renders warning state with warning text' do
      render_inline(
        Carbon::TimePickerComponent.new(
          label_text: 'Time',
          warn: true,
          warn_text: 'Time is in the past'
        )
      )

      assert_selector '.cds--time-picker--warning'
      assert_selector '.cds--form-requirement', text: 'Time is in the past'
    end

    test 'invalid takes precedence over warning' do
      render_inline(
        Carbon::TimePickerComponent.new(
          label_text: 'Time',
          warn: true,
          warn_text: 'Warning',
          invalid: true,
          invalid_text: 'Invalid'
        )
      )

      assert_selector '.cds--time-picker--invalid'
      assert_no_selector '.cds--time-picker--warning'
      assert_selector '.cds--form-requirement', text: 'Invalid'
    end

    # -- Selects slot --

    test 'renders with AM/PM select slot' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time')) do |c|
        c.with_select(id: 'period-select', label_text: 'AM/PM') do
          '<option value="AM">AM</option><option value="PM">PM</option>'.html_safe
        end
      end

      assert_selector '.cds--select.cds--time-picker__select'
      assert_selector 'select.cds--select-input#period-select'
      assert_selector 'select option[value="AM"]', text: 'AM'
      assert_selector 'select option[value="PM"]', text: 'PM'
      assert_selector '.cds--select__arrow svg'
    end

    test 'renders with multiple select slots' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time')) do |c|
        c.with_select(id: 'period') do
          '<option value="AM">AM</option><option value="PM">PM</option>'.html_safe
        end
        c.with_select(id: 'timezone') do
          '<option value="EST">EST</option><option value="PST">PST</option>'.html_safe
        end
      end

      assert_selector '.cds--select.cds--time-picker__select', count: 2
      assert_selector 'select#period'
      assert_selector 'select#timezone'
    end

    test 'select is disabled when time picker is disabled' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', disabled: true)) do |c|
        c.with_select(id: 'period') do
          '<option value="AM">AM</option>'.html_safe
        end
      end

      assert_selector 'select[disabled]'
    end

    # -- Custom ID --

    test 'uses custom id when provided' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', id: 'custom-time'))

      assert_selector 'input#custom-time'
      assert_selector 'label[for="custom-time"]'
    end

    # -- Hide label --

    test 'label is visible by default' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_selector 'label.cds--label:not(.cds--visually-hidden)', text: 'Time'
    end

    test 'hide_label adds visually-hidden class' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', hide_label: true))

      assert_selector 'label.cds--label.cds--visually-hidden', text: 'Time'
    end

    test 'label remains in DOM when hide_label is true' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', hide_label: true))

      label = page.find('label')

      assert_equal 'Time', label.text
      assert_includes label['class'], 'cds--visually-hidden'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::TimePickerComponent.new(label_text: 'Time', size: :invalid)
      end
    end

    test 'accepts string values for size' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', size: 'sm'))

      assert_selector '.cds--time-picker.cds--time-picker--sm'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::TimePickerComponent.new(
          label_text: 'Time',
          data: { testid: 'time-1' }
        )
      )

      assert_selector 'input[data-testid="time-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', class: 'my-custom-class'))

      assert_selector '.cds--form-item.my-custom-class'
    end

    # -- Readonly state --

    test 'renders readonly state' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time', readonly: true))

      assert_selector '.cds--time-picker--readonly'
      assert_selector 'input[readonly]'
      assert_selector 'input[aria-readonly="true"]'
    end

    test 'renders not readonly by default' do
      render_inline(Carbon::TimePickerComponent.new(label_text: 'Time'))

      assert_no_selector '.cds--time-picker--readonly'
      assert_no_selector 'input[readonly]'
    end
  end
end
