# frozen_string_literal: true

module Carbon
  class DropdownComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    def default(size: :md, disabled: false)
      render Carbon::DropdownComponent.new(
        label_text: 'Dropdown label',
        title_text: 'Choose an option',
        size: size.to_sym,
        disabled: disabled
      ) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
        c.with_item(value: 'opt3', text: 'Option 3')
        c.with_item(value: 'opt4', text: 'Option 4')
      end
    end

    def with_selected_item
      render Carbon::DropdownComponent.new(
        label_text: 'Color',
        title_text: 'Choose a color'
      ) do |c|
        c.with_item(value: 'red', text: 'Red')
        c.with_item(value: 'blue', text: 'Blue', selected: true)
        c.with_item(value: 'green', text: 'Green')
      end
    end

    def invalid
      render Carbon::DropdownComponent.new(
        label_text: 'Required field',
        title_text: 'Select an option',
        invalid: true,
        invalid_text: 'A selection is required'
      ) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end
    end

    def warning
      render Carbon::DropdownComponent.new(
        label_text: 'Region',
        title_text: 'Select region',
        warn: true,
        warn_text: 'This region may have limited availability'
      ) do |c|
        c.with_item(value: 'us', text: 'United States')
        c.with_item(value: 'eu', text: 'Europe')
        c.with_item(value: 'ap', text: 'Asia Pacific')
      end
    end

    def with_helper_text
      render Carbon::DropdownComponent.new(
        label_text: 'Language',
        title_text: 'Select language',
        helper_text: 'Choose your preferred language'
      ) do |c|
        c.with_item(value: 'en', text: 'English')
        c.with_item(value: 'fr', text: 'French')
        c.with_item(value: 'de', text: 'German')
        c.with_item(value: 'es', text: 'Spanish')
      end
    end

    def disabled
      render Carbon::DropdownComponent.new(
        label_text: 'Disabled dropdown',
        title_text: 'Cannot select',
        disabled: true
      ) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end
    end

    def with_disabled_items
      render Carbon::DropdownComponent.new(
        label_text: 'Plan',
        title_text: 'Select a plan'
      ) do |c|
        c.with_item(value: 'free', text: 'Free')
        c.with_item(value: 'pro', text: 'Pro')
        c.with_item(value: 'enterprise', text: 'Enterprise', disabled: true)
      end
    end

    def small_size
      render Carbon::DropdownComponent.new(
        label_text: 'Small dropdown',
        title_text: 'Choose',
        size: :sm
      ) do |c|
        c.with_item(value: 'a', text: 'Option A')
        c.with_item(value: 'b', text: 'Option B')
      end
    end

    def large_size
      render Carbon::DropdownComponent.new(
        label_text: 'Large dropdown',
        title_text: 'Choose',
        size: :lg
      ) do |c|
        c.with_item(value: 'a', text: 'Option A')
        c.with_item(value: 'b', text: 'Option B')
      end
    end
  end
end
