# frozen_string_literal: true

module Carbon
  class MultiSelectComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    # @param filterable toggle
    # @param disabled toggle
    def default(size: :md, filterable: false, disabled: false)
      render Carbon::MultiSelectComponent.new(
        label_text: 'Colors',
        title_text: 'Choose colors',
        size: size.to_sym,
        filterable: filterable,
        disabled: disabled
      ) do |c|
        c.with_item(value: 'red', text: 'Red')
        c.with_item(value: 'green', text: 'Green')
        c.with_item(value: 'blue', text: 'Blue')
        c.with_item(value: 'yellow', text: 'Yellow')
        c.with_item(value: 'purple', text: 'Purple')
      end
    end

    def with_preselected_items
      render Carbon::MultiSelectComponent.new(
        label_text: 'Fruits',
        title_text: 'Select fruits'
      ) do |c|
        c.with_item(value: 'apple', text: 'Apple', selected: true)
        c.with_item(value: 'banana', text: 'Banana')
        c.with_item(value: 'cherry', text: 'Cherry', selected: true)
        c.with_item(value: 'date', text: 'Date')
      end
    end

    def filterable
      render Carbon::MultiSelectComponent.new(
        label_text: 'Countries',
        title_text: 'Choose countries',
        filterable: true
      ) do |c|
        c.with_item(value: 'us', text: 'United States')
        c.with_item(value: 'ca', text: 'Canada')
        c.with_item(value: 'mx', text: 'Mexico')
        c.with_item(value: 'uk', text: 'United Kingdom')
        c.with_item(value: 'de', text: 'Germany')
        c.with_item(value: 'fr', text: 'France')
      end
    end

    def with_disabled_items
      render Carbon::MultiSelectComponent.new(
        label_text: 'Features',
        title_text: 'Select features'
      ) do |c|
        c.with_item(value: 'basic', text: 'Basic Plan')
        c.with_item(value: 'pro', text: 'Pro Plan')
        c.with_item(value: 'enterprise', text: 'Enterprise Plan', disabled: true)
      end
    end

    def invalid
      render Carbon::MultiSelectComponent.new(
        label_text: 'Required Field',
        title_text: 'Choose at least one',
        invalid: true,
        invalid_text: 'Please select at least one option.'
      ) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end
    end

    def with_warning
      render Carbon::MultiSelectComponent.new(
        label_text: 'Preferences',
        title_text: 'Choose preferences',
        warn: true,
        warn_text: 'Some selections may not be available.'
      ) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end
    end

    def with_helper_text
      render Carbon::MultiSelectComponent.new(
        label_text: 'Tags',
        title_text: 'Choose tags',
        helper_text: 'You can select multiple tags for this item.'
      ) do |c|
        c.with_item(value: 'bug', text: 'Bug')
        c.with_item(value: 'feature', text: 'Feature')
        c.with_item(value: 'docs', text: 'Documentation')
      end
    end
  end
end
