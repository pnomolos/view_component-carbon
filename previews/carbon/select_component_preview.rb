# frozen_string_literal: true

module Carbon
  class SelectComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    # @param inline toggle
    def default(size: :md, disabled: false, inline: false)
      render Carbon::SelectComponent.new(
        label_text: 'Select label',
        size: size.to_sym,
        disabled: disabled,
        inline: inline,
        name: 'example'
      ) do |c|
        c.with_option(value: '', text: 'Choose an option', disabled: true, selected: true)
        c.with_option(value: 'opt1', text: 'Option 1')
        c.with_option(value: 'opt2', text: 'Option 2')
        c.with_option(value: 'opt3', text: 'Option 3')
      end
    end

    def with_selected
      render Carbon::SelectComponent.new(
        label_text: 'Country',
        name: 'country'
      ) do |c|
        c.with_option(value: 'us', text: 'United States')
        c.with_option(value: 'ca', text: 'Canada', selected: true)
        c.with_option(value: 'mx', text: 'Mexico')
      end
    end

    def with_option_groups
      render Carbon::SelectComponent.new(
        label_text: 'Food category',
        name: 'food'
      ) do |c|
        c.with_option_group(label: 'Fruits') do |group|
          group.with_option(value: 'apple', text: 'Apple')
          group.with_option(value: 'banana', text: 'Banana')
          group.with_option(value: 'cherry', text: 'Cherry')
        end
        c.with_option_group(label: 'Vegetables') do |group|
          group.with_option(value: 'carrot', text: 'Carrot')
          group.with_option(value: 'broccoli', text: 'Broccoli')
        end
      end
    end

    def invalid
      render Carbon::SelectComponent.new(
        label_text: 'Required field',
        name: 'required',
        invalid: true,
        invalid_text: 'Please make a selection'
      ) do |c|
        c.with_option(value: '', text: 'Choose an option', disabled: true, selected: true)
        c.with_option(value: 'opt1', text: 'Option 1')
        c.with_option(value: 'opt2', text: 'Option 2')
      end
    end

    def warning
      render Carbon::SelectComponent.new(
        label_text: 'Region',
        name: 'region',
        warn: true,
        warn_text: 'Some regions may have limited availability'
      ) do |c|
        c.with_option(value: 'us', text: 'United States')
        c.with_option(value: 'eu', text: 'Europe')
        c.with_option(value: 'ap', text: 'Asia Pacific')
      end
    end

    def with_helper_text
      render Carbon::SelectComponent.new(
        label_text: 'Timezone',
        name: 'timezone',
        helper_text: 'Select your local timezone'
      ) do |c|
        c.with_option(value: 'est', text: 'Eastern Time (ET)')
        c.with_option(value: 'cst', text: 'Central Time (CT)')
        c.with_option(value: 'pst', text: 'Pacific Time (PT)')
      end
    end

    def inline
      render Carbon::SelectComponent.new(
        label_text: 'Sort by',
        name: 'sort',
        inline: true
      ) do |c|
        c.with_option(value: 'name', text: 'Name')
        c.with_option(value: 'date', text: 'Date')
        c.with_option(value: 'size', text: 'Size')
      end
    end

    def disabled
      render Carbon::SelectComponent.new(
        label_text: 'Disabled select',
        disabled: true
      ) do |c|
        c.with_option(value: 'opt1', text: 'Option 1')
        c.with_option(value: 'opt2', text: 'Option 2')
      end
    end

    def small_size
      render Carbon::SelectComponent.new(
        label_text: 'Small select',
        size: :sm
      ) do |c|
        c.with_option(value: 'a', text: 'Option A')
        c.with_option(value: 'b', text: 'Option B')
      end
    end

    def large_size
      render Carbon::SelectComponent.new(
        label_text: 'Large select',
        size: :lg
      ) do |c|
        c.with_option(value: 'a', text: 'Option A')
        c.with_option(value: 'b', text: 'Option B')
      end
    end
  end
end
