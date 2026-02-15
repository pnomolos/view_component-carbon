# frozen_string_literal: true

require 'test_helper'

module Carbon
  # Comprehensive markup verification test that renders every Stimulus-powered
  # component and checks the critical HTML structure matches Carbon Design System
  # expectations.
  class MarkupVerificationTest < CarbonViewComponents::TestCase
    # =========================================================================
    # ACCORDION
    # =========================================================================

    test 'accordion: root is ul.cds--accordion' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
      end

      assert_selector 'ul.cds--accordion'
    end

    test 'accordion: items are li.cds--accordion__item with stimulus controller' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
        c.with_item(title: 'Item 2') { 'Content 2' }
      end

      assert_selector 'li.cds--accordion__item[data-controller="carbon--accordion-item"]', count: 2
    end

    test 'accordion: has div.cds--accordion__wrapper wrapping div.cds--accordion__content' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Item 1') { 'Content 1' }
      end

      assert_selector 'li div.cds--accordion__wrapper > div.cds--accordion__content'
    end

    test 'accordion: button has aria-expanded' do
      render_inline(Carbon::AccordionComponent.new) do |c|
        c.with_item(title: 'Closed') { 'Content' }
        c.with_item(title: 'Open', open: true) { 'Content' }
      end

      assert_selector 'button[aria-expanded="false"]'
      assert_selector 'button[aria-expanded="true"]'
    end

    # =========================================================================
    # TABS
    # =========================================================================

    test 'tabs: outer wrapper is div[data-controller="carbon--tabs"]' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      assert_selector 'div[data-controller="carbon--tabs"]'
    end

    test 'tabs: inner div.cds--tabs is separate from panels' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1', selected: true) { 'Content 1' }
      end

      # div.cds--tabs should exist inside the wrapper
      assert_selector 'div[data-controller="carbon--tabs"] > div.cds--tabs'
      # Panels should be siblings of div.cds--tabs, NOT children
      assert_selector 'div[data-controller="carbon--tabs"] > .cds--tab-content', visible: :all
      assert_no_selector 'div.cds--tabs > .cds--tab-content', visible: :all
    end

    test 'tabs: tablist is div.cds--tab--list[role="tablist"] (NOT cds--tabs__nav)' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      assert_selector 'div.cds--tab--list[role="tablist"]'
      assert_no_selector '.cds--tabs__nav[role="tablist"]'
    end

    test 'tabs: tab buttons have correct classes and type="button"' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      assert_selector 'button.cds--tabs__nav-item.cds--tabs__nav-link[type="button"]'
    end

    test 'tabs: tab buttons have aria-controls and id' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1') { 'Content 1' }
      end

      tab = page.find('button[role="tab"]')
      assert tab['aria-controls'].present?, 'Tab button should have aria-controls'
      assert tab['id'].present?, 'Tab button should have id'
    end

    test 'tabs: inner label wrapper .cds--tabs__nav-item-label-wrapper > .cds--tabs__nav-item-label' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'First') { 'Content' }
      end

      assert_selector '.cds--tabs__nav-item-label-wrapper > .cds--tabs__nav-item-label', text: 'First'
    end

    test 'tabs: panels are siblings of .cds--tabs, not children' do
      render_inline(Carbon::TabsComponent.new) do |c|
        c.with_tab(label: 'Tab 1', selected: true) { 'Content 1' }
        c.with_tab(label: 'Tab 2') { 'Content 2' }
      end

      assert_selector '.cds--tab-content[role="tabpanel"]', count: 2, visible: :all
      # Panels should NOT be inside .cds--tabs
      assert_no_selector '.cds--tabs .cds--tab-content', visible: :all
    end

    # =========================================================================
    # TOGGLE
    # =========================================================================

    test 'toggle: root is div.cds--toggle (NOT wrapped in cds--form-item)' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Toggle'))

      assert_selector 'div.cds--toggle'
      # Should NOT be wrapped in a form-item
      assert_no_selector 'div.cds--form-item > div.cds--toggle'
    end

    test 'toggle: uses button.cds--toggle__button[role="switch"][type="button"] (NOT input checkbox)' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Toggle'))

      assert_selector 'button.cds--toggle__button[role="switch"][type="button"]'
      assert_no_selector 'input[type="checkbox"]'
    end

    test 'toggle: has div.cds--toggle__appearance' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Toggle'))

      assert_selector 'div.cds--toggle__appearance'
    end

    test 'toggle: has div.cds--toggle__switch' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Toggle'))

      assert_selector 'div.cds--toggle__switch'
    end

    test 'toggle: single span.cds--toggle__text (NOT separate --off/--on spans)' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Toggle'))

      assert_selector 'span.cds--toggle__text', count: 1
      assert_no_selector 'span.cds--toggle__text--off'
      assert_no_selector 'span.cds--toggle__text--on'
    end

    test 'toggle: cds--toggle--disabled when disabled' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Toggle', disabled: true))

      assert_selector 'div.cds--toggle.cds--toggle--disabled'
    end

    # =========================================================================
    # SLIDER
    # =========================================================================

    test 'slider: no native input[type="range"]' do
      render_inline(Carbon::SliderComponent.new(name: 'slider', value: 50, min: 0, max: 100))

      assert_no_selector 'input[type="range"]'
    end

    test 'slider: has div.cds--slider__thumb-wrapper with inline style' do
      render_inline(Carbon::SliderComponent.new(name: 'slider', value: 50, min: 0, max: 100))

      thumb_wrapper = page.find('.cds--slider__thumb-wrapper', visible: :all)
      assert thumb_wrapper['style'].present?, 'Thumb wrapper should have inline style'
    end

    test 'slider: has div.cds--slider__thumb[role="slider"] with aria attributes' do
      render_inline(Carbon::SliderComponent.new(name: 'slider', value: 50, min: 0, max: 100))

      assert_selector 'div.cds--slider__thumb[role="slider"][aria-valuenow="50"][aria-valuemin="0"][aria-valuemax="100"]'
    end

    test 'slider: has div.cds--slider__track' do
      render_inline(Carbon::SliderComponent.new(name: 'slider', value: 50, min: 0, max: 100))

      assert_selector 'div.cds--slider__track'
    end

    test 'slider: has div.cds--slider__filled-track with inline style' do
      render_inline(Carbon::SliderComponent.new(name: 'slider', value: 50, min: 0, max: 100))

      filled_track = page.find('.cds--slider__filled-track', visible: :all)
      assert filled_track['style'].present?, 'Filled track should have inline style'
    end

    test 'slider: number input wrapped in div.cds--text-input-wrapper.cds--slider-text-input__wrapper' do
      render_inline(Carbon::SliderComponent.new(name: 'slider', value: 50, min: 0, max: 100))

      assert_selector 'div.cds--text-input-wrapper.cds--slider-text-input__wrapper input[type="number"]'
    end

    # =========================================================================
    # CONTENT SWITCHER
    # =========================================================================

    test 'content_switcher: buttons have type="button"' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option 1', selected: true)
        c.with_option(label: 'Option 2')
      end

      assert_selector 'button[type="button"]', minimum: 2
    end

    test 'content_switcher: inner label span.cds--content-switcher__label' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option 1', selected: true)
      end

      assert_selector 'span.cds--content-switcher__label', text: 'Option 1'
    end

    # =========================================================================
    # TOOLTIP
    # =========================================================================

    test 'tooltip: container is span with popover classes and cds--tooltip' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tip text')) { 'Trigger' }

      assert_selector 'span.cds--popover-container.cds--popover--caret.cds--popover--drop-shadow.cds--tooltip'
    end

    test 'tooltip: trigger wrapper is div.cds--tooltip-trigger__wrapper (NOT button.cds--tooltip__trigger)' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tip text')) { 'Trigger' }

      assert_selector 'div.cds--tooltip-trigger__wrapper'
      assert_no_selector 'button.cds--tooltip__trigger'
    end

    test 'tooltip: content has aria-hidden' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tip text')) { 'Trigger' }

      assert_selector '.cds--popover-content[aria-hidden]', visible: :all
    end

    test 'tooltip: has span.cds--popover-caret' do
      render_inline(Carbon::TooltipComponent.new(label: 'Tip text')) { 'Trigger' }

      assert_selector 'span.cds--popover-caret', visible: :all
    end

    # =========================================================================
    # TOGGLETIP
    # =========================================================================

    test 'toggletip: container is span with cds--popover-container.cds--popover--caret.cds--popover--high-contrast.cds--toggletip' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Toggletip content' }
      end

      assert_selector 'span.cds--popover-container.cds--popover--caret.cds--popover--high-contrast.cds--toggletip'
    end

    test 'toggletip: button class is cds--toggletip-button (NOT cds--toggletip__button)' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Toggletip content' }
      end

      assert_selector 'button.cds--toggletip-button'
      assert_no_selector 'button.cds--toggletip__button'
    end

    test 'toggletip: content nesting is .cds--popover-content > div.cds--toggletip-content' do
      render_inline(Carbon::ToggletipComponent.new) do |c|
        c.with_body { 'Toggletip content' }
      end

      assert_selector '.cds--popover-content > div.cds--toggletip-content', visible: :all
    end

    # =========================================================================
    # POPOVER
    # =========================================================================

    test 'popover: container is span.cds--popover-container' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Popover content' }
      end

      assert_selector 'span.cds--popover-container'
    end

    test 'popover: NO div.cds--popover__trigger wrapper' do
      render_inline(Carbon::PopoverComponent.new) do |c|
        c.with_body { 'Popover content' }
      end

      assert_no_selector 'div.cds--popover__trigger'
    end

    test 'popover: cds--popover--caret on container when caret=true' do
      render_inline(Carbon::PopoverComponent.new(caret: true)) do |c|
        c.with_body { 'Popover content' }
      end

      assert_selector 'span.cds--popover-container.cds--popover--caret'
    end

    test 'popover: no cds--popover--caret on container when caret=false' do
      render_inline(Carbon::PopoverComponent.new(caret: false)) do |c|
        c.with_body { 'Popover content' }
      end

      assert_no_selector 'span.cds--popover--caret'
    end

    # =========================================================================
    # TOAST NOTIFICATION
    # =========================================================================

    test 'toast_notification: icon SVG has class cds--toast-notification__icon directly (NOT wrapped in a div)' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Test'))

      assert_selector 'svg.cds--toast-notification__icon'
      assert_no_selector 'div.cds--toast-notification__icon'
    end

    test 'toast_notification: no div.cds--toast-notification__icon wrapper' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Test'))

      # The SVG itself has the icon class, not a dedicated wrapper div
      icon = page.find('svg.cds--toast-notification__icon', visible: :all)
      parent = icon.find(:xpath, '..')
      # The parent should be the notification root container, not a dedicated icon wrapper
      assert_includes parent[:class], 'cds--toast-notification',
                      'SVG icon parent should be the notification root, not a dedicated icon wrapper'
      refute_includes parent[:class], 'cds--toast-notification__icon',
                      'SVG icon should NOT be inside a div.cds--toast-notification__icon wrapper'
    end

    # =========================================================================
    # INLINE NOTIFICATION
    # =========================================================================

    test 'inline_notification: icon SVG has class cds--inline-notification__icon directly (NOT wrapped in a div)' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Test'))

      assert_selector 'svg.cds--inline-notification__icon'
      assert_no_selector 'div.cds--inline-notification__icon'
    end

    test 'inline_notification: cds--inline-notification--hide-close-button when applicable' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Test', hide_close_button: true))

      assert_selector 'div.cds--inline-notification.cds--inline-notification--hide-close-button'
    end

    # =========================================================================
    # CODE SNIPPET
    # =========================================================================

    test 'code_snippet: container has role="textbox" tabindex="0" aria-readonly="true"' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :single, code: 'echo hello'))

      assert_selector '.cds--snippet-container[role="textbox"][tabindex="0"][aria-readonly="true"]'
    end

    test 'code_snippet: multi has aria-multiline="true"' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: "line 1\nline 2"))

      assert_selector '.cds--snippet-container[aria-multiline="true"]'
    end

    test 'code_snippet: multi has expand button with correct classes and chevron SVG' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: "line 1\nline 2"))

      assert_selector '.cds--btn.cds--btn--ghost.cds--snippet-btn--expand'
      assert_selector '.cds--snippet-btn--expand svg'
    end

    # =========================================================================
    # SEARCH
    # =========================================================================

    test 'search: root is div[role="search"][aria-label]' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'div[role="search"][aria-label]'
    end

    test 'search: cds--search--disabled when disabled' do
      render_inline(Carbon::SearchComponent.new(disabled: true))

      assert_selector 'div.cds--search--disabled'
    end

    test 'search: input is input.cds--search-input[role="searchbox"][autocomplete="off"]' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'input.cds--search-input[role="searchbox"][autocomplete="off"]'
    end

    test 'search: magnifier SVG has svg.cds--search-magnifier-icon' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'svg.cds--search-magnifier-icon'
    end

    test 'search: close button uses cds--search-close--hidden class (NOT hidden attribute) when empty' do
      render_inline(Carbon::SearchComponent.new)

      assert_selector 'button.cds--search-close.cds--search-close--hidden'
      close_btn = page.find('button.cds--search-close', visible: :all)
      assert_nil close_btn['hidden'], 'Close button should NOT use hidden attribute'
    end

    # =========================================================================
    # TEXT INPUT
    # =========================================================================

    test 'text_input: has div.cds--text-input__label-wrapper wrapping label and counter' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Name', max_count: 100))

      assert_selector 'div.cds--text-input__label-wrapper'
      assert_selector 'div.cds--text-input__label-wrapper label'
      assert_selector 'div.cds--text-input__label-wrapper .cds--text-input__counter'
    end

    test 'text_input: counter is inside label-wrapper (NOT inside field-wrapper)' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Name', max_count: 100))

      assert_selector 'div.cds--text-input__label-wrapper .cds--text-input__counter'
      assert_no_selector 'div.cds--text-input__field-wrapper .cds--text-input__counter'
    end

    test 'text_input: aria-describedby on input when helper text present' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Name', helper_text: 'Help text'))

      assert_selector 'input[aria-describedby]'
    end

    test 'text_input: aria-describedby on input when invalid text present' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Name', invalid: true, invalid_text: 'Error'))

      assert_selector 'input[aria-describedby]'
    end

    test 'text_input: warning icon inside field-wrapper when invalid' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Name', invalid: true, invalid_text: 'Error'))

      assert_selector '.cds--text-input__field-wrapper svg.cds--text-input__invalid-icon', visible: :all
    end

    test 'text_input: warning icon inside field-wrapper when warn' do
      render_inline(Carbon::TextInputComponent.new(label_text: 'Name', warn: true, warn_text: 'Warning'))

      assert_selector '.cds--text-input__field-wrapper svg.cds--text-input__invalid-icon', visible: :all
    end

    # =========================================================================
    # TEXT AREA
    # =========================================================================

    test 'text_area: root is div.cds--form-item (NOT div.cds--form-item.cds--text-area-wrapper)' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Description'))

      assert_selector 'div.cds--form-item'
      assert_no_selector 'div.cds--form-item.cds--text-area-wrapper'
    end

    test 'text_area: has div.cds--text-area__label-wrapper wrapping label and counter' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Description', max_count: 500))

      assert_selector 'div.cds--text-area__label-wrapper'
      assert_selector 'div.cds--text-area__label-wrapper label'
      assert_selector 'div.cds--text-area__label-wrapper .cds--text-area__counter'
    end

    test 'text_area: aria-describedby on textarea when helper text present' do
      render_inline(Carbon::TextAreaComponent.new(label_text: 'Description', helper_text: 'Help text'))

      assert_selector 'textarea[aria-describedby]'
    end

    # =========================================================================
    # NUMBER INPUT
    # =========================================================================

    test 'number_input: buttons in div.cds--number__controls (NOT inside cds--number__input-wrapper)' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Count', value: 1))

      assert_selector 'div.cds--number__controls button'
      assert_no_selector 'div.cds--number__input-wrapper button'
    end

    test 'number_input: has div.cds--number__rule-divider elements' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Count', value: 1))

      assert_selector 'div.cds--number__rule-divider', minimum: 1
    end

    test 'number_input: buttons have tabindex="-1"' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Count', value: 1))

      page.all('div.cds--number__controls button').each do |button|
        assert_equal '-1', button['tabindex'], 'Number input buttons should have tabindex="-1"'
      end
    end

    test 'number_input: buttons contain SVG icons (NOT literal +/- text)' do
      render_inline(Carbon::NumberInputComponent.new(label_text: 'Count', value: 1))

      page.all('div.cds--number__controls button').each do |button|
        assert button.has_css?('svg'), 'Number input buttons should contain SVG icons'
        # Should not contain literal text like "+" or "-"
        text_content = button.text.strip
        refute_match(/\A[+-]\z/, text_content, 'Button should not have literal +/- text')
      end
    end

    # =========================================================================
    # CHECKBOX
    # =========================================================================

    test 'checkbox: label text in div.cds--checkbox-label-text (NOT span)' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Accept'))

      assert_selector 'div.cds--checkbox-label-text', text: 'Accept'
      assert_no_selector 'span.cds--checkbox-label-text'
    end

    test 'checkbox: cds--checkbox-wrapper--invalid when invalid' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Accept', invalid: true, invalid_text: 'Required'))

      assert_selector '.cds--checkbox-wrapper--invalid'
    end

    test 'checkbox: has div.cds--checkbox__validation-msg when invalid' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Accept', invalid: true, invalid_text: 'Required'))

      assert_selector 'div.cds--checkbox__validation-msg'
    end

    test 'checkbox: has div.cds--checkbox__validation-msg when warn' do
      render_inline(Carbon::CheckboxComponent.new(label_text: 'Accept', warn: true, warn_text: 'Caution'))

      assert_selector 'div.cds--checkbox__validation-msg'
    end

    # =========================================================================
    # PAGINATION
    # =========================================================================

    test 'pagination: buttons wrapped in div.cds--pagination__control-buttons' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'div.cds--pagination__control-buttons button', minimum: 2
    end

    test 'pagination: label has for attribute' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      label = page.find('label.cds--pagination__text')
      assert label['for'].present?, 'Pagination label should have a for attribute'
    end

    test 'pagination: item range span has .cds--pagination__items-count' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'span.cds--pagination__items-count'
    end
  end
end
