# frozen_string_literal: true

require 'test_helper'

module Carbon
  class DropdownComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default dropdown' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'div.cds--form-item'
      assert_selector 'div.cds--dropdown__wrapper.cds--list-box__wrapper'
      assert_selector 'div.cds--dropdown.cds--list-box'
    end

    test 'renders with stimulus controller' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'div[data-controller="carbon--dropdown"]'
    end

    test 'renders label' do
      render_inline(Carbon::DropdownComponent.new(label_text: 'Choose color')) do |c|
        c.with_item(value: 'red', text: 'Red')
      end

      assert_selector 'label.cds--label', text: 'Choose color'
    end

    test 'renders trigger button with combobox role' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Pick one')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button.cds--list-box__field[role="combobox"]'
      assert_selector 'button[aria-expanded="false"]'
      assert_selector 'button[aria-haspopup="listbox"]'
      # When no aria_label provided, should use aria-labelledby
      assert_selector 'button[aria-labelledby]'
    end

    test 'renders menu with listbox role' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--list-box__menu[role="listbox"]'
    end

    # -- Items --

    test 'renders items as option roles' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector 'div.cds--list-box__menu-item[role="option"]', count: 2
    end

    test 'renders item text' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'First Item')
      end

      assert_selector '.cds--list-box__menu-item__option', text: 'First Item'
    end

    test 'renders selected item with active class' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector 'div.cds--list-box__menu-item--active[aria-selected="true"]', count: 1
      assert_selector 'div[aria-selected="false"]', count: 1
    end

    test 'displays selected item text in trigger' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Pick')) do |c|
        c.with_item(value: 'opt1', text: 'Selected One', selected: true)
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector '.cds--list-box__label', text: 'Selected One'
    end

    test 'displays title_text when no item selected' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Choose')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box__label', text: 'Choose'
    end

    test 'renders checkmark icon for selected item' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
      end

      assert_selector '.cds--list-box__menu-item__selected-icon'
    end

    test 'renders disabled item' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Disabled', disabled: true)
      end

      assert_selector 'div[aria-disabled="true"]'
    end

    # -- Sizes --

    test 'renders default md size' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--md'
    end

    test 'renders sm size' do
      render_inline(Carbon::DropdownComponent.new(size: :sm)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::DropdownComponent.new(size: :lg)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--lg'
    end

    # -- States --

    test 'renders disabled state' do
      render_inline(Carbon::DropdownComponent.new(disabled: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--disabled'
      assert_selector 'button[disabled]'
    end

    test 'renders invalid state' do
      render_inline(Carbon::DropdownComponent.new(invalid: true, invalid_text: 'Required')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--invalid'
      assert_selector '.cds--form-requirement', text: 'Required'
    end

    test 'renders warning state' do
      render_inline(Carbon::DropdownComponent.new(warn: true, warn_text: 'Careful')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--warning'
      assert_selector '.cds--form-requirement', text: 'Careful'
    end

    test 'renders helper text' do
      render_inline(Carbon::DropdownComponent.new(helper_text: 'Pick something')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--form__helper-text', text: 'Pick something'
    end

    # -- Label --

    test 'hides label when hide_label is true' do
      render_inline(Carbon::DropdownComponent.new(hide_label: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'label.cds--visually-hidden'
    end

    # -- Stimulus data attributes --

    test 'renders trigger with stimulus target and action' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button[data-carbon--dropdown-target="trigger"]'
      assert_selector 'button[data-action*="click->carbon--dropdown#toggle"]'
    end

    test 'renders menu with stimulus target' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div[data-carbon--dropdown-target="menu"]'
    end

    test 'renders items with stimulus target and action' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div[data-carbon--dropdown-target="item"]'
      assert_selector 'div[data-action="click->carbon--dropdown#select"]'
    end

    # -- Menu icon --

    test 'renders chevron icon in trigger' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--list-box__menu-icon svg'
    end

    # -- aria-controls --

    test 'trigger aria-controls matches menu id' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      trigger = page.find('button[role="combobox"]')
      menu_id = trigger['aria-controls']

      assert_selector "div##{menu_id}"
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::DropdownComponent.new(size: :xl)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::DropdownComponent.new(id: 'my-dropdown')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div#my-dropdown[data-controller="carbon--dropdown"]'
    end

    test 'merges custom class' do
      render_inline(Carbon::DropdownComponent.new(class: 'custom-dd')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown.custom-dd'
    end

    # -- P0: ARIA improvements --

    test 'renders aria-label on trigger when provided' do
      render_inline(Carbon::DropdownComponent.new(aria_label: 'Select option')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button[aria-label="Select option"]'
      refute_selector 'button[aria-labelledby]'
    end

    test 'renders aria-labelledby on trigger when no aria_label provided' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Color')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      trigger = page.find('button[role="combobox"]')
      label_id = trigger['aria-labelledby']

      assert_predicate label_id, :present?
      assert_selector "label##{label_id}", text: 'Color'
    end

    test 'renders aria-label on menu when aria_label provided' do
      render_inline(Carbon::DropdownComponent.new(aria_label: 'Options')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div[role="listbox"][aria-label="Options"]'
    end

    test 'renders aria-labelledby on menu when no aria_label provided' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Size')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      menu = page.find('div[role="listbox"]')
      label_id = menu['aria-labelledby']

      assert_predicate label_id, :present?
      assert_selector "label##{label_id}", text: 'Size'
    end

    test 'menu items have unique IDs for aria-activedescendant' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
        c.with_item(value: 'b', text: 'B')
      end

      menu = page.find('div[role="listbox"]')
      menu_id = menu['id']

      assert_selector "div##{menu_id}-item-0[role='option']"
      assert_selector "div##{menu_id}-item-1[role='option']"
    end

    test 'renders required attribute on trigger when required' do
      render_inline(Carbon::DropdownComponent.new(required: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button[required]'
      assert_selector 'button[aria-required="true"]'
    end

    # -- P1: Correctness --

    test 'renders read_only state' do
      render_inline(Carbon::DropdownComponent.new(read_only: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div[data-carbon--dropdown-read-only-value="true"]'
      refute_selector 'button[disabled]'
    end

    test 'renders open state with expanded class' do
      render_inline(Carbon::DropdownComponent.new(open: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--list-box--expanded'
      assert_selector 'button[aria-expanded="true"]'
    end

    test 'renders closed state without expanded class' do
      render_inline(Carbon::DropdownComponent.new(open: false)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      refute_selector 'div.cds--list-box--expanded'
      assert_selector 'button[aria-expanded="false"]'
    end

    test 'value prop selects matching item' do
      render_inline(Carbon::DropdownComponent.new(value: 'opt2')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector 'div[role="option"][data-value="opt2"][aria-selected="true"]'
      assert_selector 'div[role="option"][data-value="opt1"][aria-selected="false"]'
      assert_selector '.cds--list-box__label', text: 'Option 2'
    end

    test 'label prop provides placeholder text' do
      render_inline(Carbon::DropdownComponent.new(label: 'Pick one')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--list-box__label', text: 'Pick one'
    end

    test 'label prop shows when no item selected' do
      render_inline(Carbon::DropdownComponent.new(label: 'Choose', value: nil)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--list-box__label', text: 'Choose'
    end

    test 'renders validation invalid icon' do
      render_inline(Carbon::DropdownComponent.new(invalid: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'svg.cds--list-box__invalid-icon'
      refute_selector 'svg.cds--list-box__invalid-icon--warning'
    end

    test 'renders validation warning icon' do
      render_inline(Carbon::DropdownComponent.new(warn: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'svg.cds--list-box__invalid-icon.cds--list-box__invalid-icon--warning'
    end

    test 'label has for attribute pointing to trigger' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Test')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      label = page.find('label')
      trigger_id = label['for']

      assert_predicate trigger_id, :present?
      assert_selector "button##{trigger_id}"
    end

    # -- P2: Missing features --

    test 'renders direction value' do
      render_inline(Carbon::DropdownComponent.new(direction: :top)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div[data-carbon--dropdown-direction-value="top"]'
    end

    test 'renders autoalign class when enabled' do
      render_inline(Carbon::DropdownComponent.new(autoalign: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--autoalign'
    end

    test 'renders inline type classes' do
      render_inline(Carbon::DropdownComponent.new(type: 'inline')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--inline'
      assert_selector 'div.cds--list-box--inline'
    end

    test 'renders name attribute and hidden input' do
      render_inline(Carbon::DropdownComponent.new(name: 'color', value: 'red')) do |c|
        c.with_item(value: 'red', text: 'Red')
      end

      assert_selector 'input[type="hidden"][name="color"][value="red"]', visible: :all
    end

    test 'renders selected class when item selected' do
      render_inline(Carbon::DropdownComponent.new(value: 'opt1')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'div.cds--dropdown--selected'
    end

    test 'does not render selected class when no item selected' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      refute_selector 'div.cds--dropdown--selected'
    end

    test 'renders toggle_label_closed in aria-label when provided' do
      render_inline(Carbon::DropdownComponent.new(toggle_label_closed: 'Open menu', toggle_label_open: 'Close menu',
                                                  open: false)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button[aria-label="Open menu"]'
    end

    test 'renders toggle_label_open in aria-label when provided and open' do
      render_inline(Carbon::DropdownComponent.new(toggle_label_closed: 'Open menu', toggle_label_open: 'Close menu',
                                                  open: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button[aria-label="Close menu"]'
    end

    test 'renders disabled helper text class when disabled' do
      render_inline(Carbon::DropdownComponent.new(disabled: true, helper_text: 'Help')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--form__helper-text.cds--form__helper-text--disabled'
    end

    # -- P3: Polish --

    test 'menu uses div not ul element' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--list-box__menu[role="listbox"]'
      refute_selector 'ul.cds--list-box__menu'
    end

    test 'menu items use div not li element' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--list-box__menu-item[role="option"]'
      refute_selector 'li.cds--list-box__menu-item'
    end

    # -- Backwards compatibility --

    test 'label_text param still works (deprecated)' do
      render_inline(Carbon::DropdownComponent.new(label_text: 'Old API')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'label', text: 'Old API'
    end

    test 'title_text overrides label_text when both provided' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'New', label_text: 'Old')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'label', text: 'New'
    end
  end
end
