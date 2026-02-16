# frozen_string_literal: true

module Carbon
  class TimePickerComponentPreview < ViewComponent::Preview
    # @param label_text text
    # @param placeholder text
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    def default(label_text: 'Select a time', placeholder: 'hh:mm', size: :md, disabled: false)
      render Carbon::TimePickerComponent.new(
        label_text: label_text,
        placeholder: placeholder,
        size: size.to_sym,
        disabled: disabled,
        name: 'start_time'
      )
    end

    def with_am_pm_select
      render Carbon::TimePickerComponent.new(
        label_text: 'Event time',
        name: 'event_time',
        value: '12:00'
      ) do |c|
        c.with_select(id: 'time-picker-period') do
          '<option value="AM">AM</option><option value="PM">PM</option>'.html_safe
        end
      end
    end

    def with_timezone
      render Carbon::TimePickerComponent.new(
        label_text: 'Meeting time',
        name: 'meeting_time',
        value: '09:30'
      ) do |c|
        c.with_select(id: 'time-picker-period') do
          '<option value="AM">AM</option><option value="PM">PM</option>'.html_safe
        end
        c.with_select(id: 'time-picker-timezone') do
          '<option value="EST">Eastern</option>
           <option value="CST">Central</option>
           <option value="MST">Mountain</option>
           <option value="PST">Pacific</option>'.html_safe
        end
      end
    end

    def invalid
      render Carbon::TimePickerComponent.new(
        label_text: 'Start time',
        name: 'start_time',
        invalid: true,
        invalid_text: 'Please enter a valid time in hh:mm format',
        value: '25:00'
      )
    end

    def disabled
      render Carbon::TimePickerComponent.new(
        label_text: 'Disabled time',
        disabled: true,
        value: '08:00'
      )
    end

    def small_size
      render Carbon::TimePickerComponent.new(
        label_text: 'Small time picker',
        size: :sm
      )
    end

    def large_size
      render Carbon::TimePickerComponent.new(
        label_text: 'Large time picker',
        size: :lg
      )
    end
  end
end
