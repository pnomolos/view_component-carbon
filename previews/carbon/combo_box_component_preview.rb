# frozen_string_literal: true

module Carbon
  class ComboBoxComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    def default(size: :md, disabled: false)
      render Carbon::ComboBoxComponent.new(
        label_text: 'Color',
        placeholder: 'Filter colors...',
        size: size.to_sym,
        disabled: disabled
      ) do |c|
        c.with_item(value: 'red', text: 'Red')
        c.with_item(value: 'green', text: 'Green')
        c.with_item(value: 'blue', text: 'Blue')
        c.with_item(value: 'yellow', text: 'Yellow')
        c.with_item(value: 'purple', text: 'Purple')
      end
    end

    def with_many_items
      render Carbon::ComboBoxComponent.new(
        label_text: 'Country',
        placeholder: 'Search countries...'
      ) do |c|
        c.with_item(value: 'us', text: 'United States')
        c.with_item(value: 'ca', text: 'Canada')
        c.with_item(value: 'mx', text: 'Mexico')
        c.with_item(value: 'uk', text: 'United Kingdom')
        c.with_item(value: 'de', text: 'Germany')
        c.with_item(value: 'fr', text: 'France')
        c.with_item(value: 'jp', text: 'Japan')
        c.with_item(value: 'au', text: 'Australia')
      end
    end

    def with_disabled_items
      render Carbon::ComboBoxComponent.new(
        label_text: 'Plan',
        placeholder: 'Choose a plan...'
      ) do |c|
        c.with_item(value: 'basic', text: 'Basic Plan')
        c.with_item(value: 'pro', text: 'Pro Plan')
        c.with_item(value: 'enterprise', text: 'Enterprise Plan', disabled: true)
      end
    end

    def invalid
      render Carbon::ComboBoxComponent.new(
        label_text: 'Required Field',
        placeholder: 'Select an option...',
        invalid: true,
        invalid_text: 'Please select an option.'
      ) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end
    end

    def with_warning
      render Carbon::ComboBoxComponent.new(
        label_text: 'Category',
        placeholder: 'Choose category...',
        warn: true,
        warn_text: 'Some categories may be deprecated.'
      ) do |c|
        c.with_item(value: 'opt1', text: 'Category A')
        c.with_item(value: 'opt2', text: 'Category B')
      end
    end

    def with_helper_text
      render Carbon::ComboBoxComponent.new(
        label_text: 'Framework',
        placeholder: 'Search frameworks...',
        helper_text: 'Choose the primary framework for your project.'
      ) do |c|
        c.with_item(value: 'rails', text: 'Ruby on Rails')
        c.with_item(value: 'django', text: 'Django')
        c.with_item(value: 'express', text: 'Express.js')
        c.with_item(value: 'spring', text: 'Spring Boot')
      end
    end
  end
end
