# frozen_string_literal: true

require 'test_helper'

module Carbon
  class SearchComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default search' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector '.cds--search.cds--search--md'
      assert_selector "[role='search']"
      assert_selector 'input.cds--search-input[type="text"][role="searchbox"][autocomplete="off"]'
    end

    # -- Sizes --

    test 'renders sm size' do
      render_inline(Carbon::SearchComponent.new(size: :sm))

      assert_selector '.cds--search--sm'
    end

    test 'renders md size (default)' do
      render_inline(Carbon::SearchComponent.new(size: :md))

      assert_selector '.cds--search--md'
    end

    test 'renders lg size' do
      render_inline(Carbon::SearchComponent.new(size: :lg))

      assert_selector '.cds--search--lg'
    end

    # -- Label --

    test 'renders label with default text' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'label.cds--label', text: 'Search'
    end

    test 'renders label with custom text' do
      render_inline(Carbon::SearchComponent.new(label_text: 'Find items'))

      assert_selector 'label.cds--label', text: 'Find items'
    end

    test 'label has correct for attribute' do
      render_inline(Carbon::SearchComponent.new(id: 'my-search'))

      assert_selector "label[for='my-search']"
    end

    # -- Input --

    test 'renders input with default placeholder' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector "input[placeholder='Search']"
    end

    test 'renders input with custom placeholder' do
      render_inline(Carbon::SearchComponent.new(placeholder: 'Type to search...'))

      assert_selector "input[placeholder='Type to search...']"
    end

    test 'renders input with value' do
      render_inline(Carbon::SearchComponent.new(value: 'test query'))

      assert_selector "input[value='test query']"
    end

    test 'renders input without value when not provided' do
      render_inline(Carbon::SearchComponent.new)

      assert_no_selector 'input[value]'
    end

    test 'input has stimulus target' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'input[data-carbon--search-target="input"]'
    end

    test 'input has stimulus action for input event' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'input[data-action="input->carbon--search#onInput"]'
    end

    # -- Disabled --

    test 'renders disabled input when disabled is true' do
      render_inline(Carbon::SearchComponent.new(disabled: true))

      assert_selector 'input[disabled]'
      assert_selector '.cds--search--disabled'
      assert_selector 'button.cds--search-close[disabled]', visible: :all
    end

    test 'does not render disabled attribute by default' do
      render_inline(Carbon::SearchComponent.new)

      assert_no_selector 'input[disabled]'
      assert_no_selector '.cds--search--disabled'
    end

    # -- Close button --

    test 'renders close button with default label' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector "button.cds--search-close[aria-label='Clear search input']", visible: :all
    end

    test 'renders close button with custom label' do
      render_inline(Carbon::SearchComponent.new(close_button_label_text: 'Remove search'))

      assert_selector "button.cds--search-close[aria-label='Remove search']", visible: :all
    end

    test 'close button is hidden by default when no value' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'button.cds--search-close.cds--search-close--hidden', visible: :all
    end

    test 'close button is visible when value is provided' do
      render_inline(Carbon::SearchComponent.new(value: 'search'))

      assert_no_selector 'button.cds--search-close--hidden', visible: :all
    end

    test 'close button has stimulus action' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'button[data-action="click->carbon--search#clear"]', visible: :all
    end

    test 'close button has stimulus target' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'button[data-carbon--search-target="closeButton"]', visible: :all
    end

    # -- Expandable --

    test 'applies expandable class when expandable is true' do
      render_inline(Carbon::SearchComponent.new(expandable: true))

      assert_selector '.cds--search--expandable'
    end

    test 'does not apply expandable class by default' do
      render_inline(Carbon::SearchComponent.new)

      assert_no_selector '.cds--search--expandable'
    end

    # -- ID --

    test 'uses provided id' do
      render_inline(Carbon::SearchComponent.new(id: 'custom-search'))

      assert_selector 'input#custom-search'
      assert_selector "label[for='custom-search']"
    end

    test 'generates id when not provided' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'input[id^="search-"]'
    end

    # -- Stimulus controller --

    test 'has stimulus controller data attribute' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector '[data-controller="carbon--search"]'
    end

    # -- Icons --

    test 'renders search icon' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector '.cds--search-magnifier svg.cds--search-magnifier-icon'
    end

    # -- Aria label on root --

    test 'root element has aria-label matching placeholder' do
      render_inline(Carbon::SearchComponent.new(placeholder: 'Find items'))

      assert_selector '.cds--search[aria-label="Find items"]'
    end

    # -- Close button title --

    test 'close button has title attribute' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'button.cds--search-close[title="Clear search"]', visible: :all
    end

    test 'renders close icon in button' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector '.cds--search-close svg', visible: :all
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::SearchComponent.new(
                      id: 'my-search',
                      data: { testid: 'search-1' }
                    ))

      assert_selector ".cds--search[data-testid='search-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::SearchComponent.new(class: 'my-custom-class'))

      assert_selector '.cds--search.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::SearchComponent.new(size: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for size' do
      render_inline(Carbon::SearchComponent.new(size: 'lg'))

      assert_selector '.cds--search--lg'
    end

    test 'renders name attribute' do
      render_inline(Carbon::SearchComponent.new(label_text: 'Search', name: 'q'))

      assert_selector 'input[name="q"]'
    end

    test 'renders autocomplete attribute' do
      render_inline(Carbon::SearchComponent.new(label_text: 'Search', autocomplete: 'on'))

      assert_selector 'input[autocomplete="on"]'
    end

    test 'defaults autocomplete to off' do
      render_inline(Carbon::SearchComponent.new(label_text: 'Search'))

      assert_selector 'input[autocomplete="off"]'
    end
  end
end
