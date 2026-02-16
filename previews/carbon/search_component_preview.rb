# frozen_string_literal: true

module Carbon
  class SearchComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    # @param placeholder text
    # @param label_text text
    # @param value text
    # @param disabled toggle
    # @param expandable toggle
    def default(
      size: :md,
      placeholder: 'Search',
      label_text: 'Search',
      value: '',
      disabled: false,
      expandable: false
    )
      render Carbon::SearchComponent.new(
        size: size.to_sym,
        placeholder: placeholder,
        label_text: label_text,
        value: value.presence,
        disabled: disabled,
        expandable: expandable
      )
    end

    # @!group All Sizes

    def small
      render Carbon::SearchComponent.new(size: :sm)
    end

    def medium
      render Carbon::SearchComponent.new(size: :md)
    end

    def large
      render Carbon::SearchComponent.new(size: :lg)
    end

    # @!endgroup

    def with_value
      render Carbon::SearchComponent.new(value: 'carbon')
    end

    def disabled
      render Carbon::SearchComponent.new(disabled: true, value: 'search term')
    end

    def expandable
      render Carbon::SearchComponent.new(expandable: true)
    end

    def custom_placeholder
      render Carbon::SearchComponent.new(
        placeholder: 'Type to search...',
        label_text: 'Find items'
      )
    end
  end
end
