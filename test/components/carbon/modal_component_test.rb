# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ModalComponentTest < CarbonViewComponents::TestCase # rubocop:disable Metrics/ClassLength
    # -- Default rendering --

    test 'renders default modal' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Modal body content' }
      end

      assert_selector 'div.cds--modal'
    end

    test 'renders with role presentation on outer div' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal[role="presentation"]'
    end

    test 'renders dialog container with aria-modal' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal-container[role="dialog"][aria-modal="true"]'
    end

    test 'renders stimulus controller' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-controller="carbon--modal"]'
    end

    # -- Open state --

    test 'renders closed by default' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_no_selector 'div.cds--modal--open'
    end

    test 'renders open when open is true' do
      render_inline(Carbon::ModalComponent.new(open: true)) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal.cds--modal--open'
    end

    test 'sets open value data attribute' do
      render_inline(Carbon::ModalComponent.new(open: true)) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-open-value="true"]'
    end

    # -- Sizes --

    test 'renders md size by default (no size modifier class)' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal-container'
      assert_no_selector 'div.cds--modal-container--md'
    end

    test 'renders xs size' do
      render_inline(Carbon::ModalComponent.new(size: :xs)) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal-container--xs'
    end

    test 'renders sm size' do
      render_inline(Carbon::ModalComponent.new(size: :sm)) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal-container--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::ModalComponent.new(size: :lg)) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal-container--lg'
    end

    # -- Danger variant --

    test 'renders without danger class by default' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_no_selector 'div.cds--modal--danger'
    end

    test 'renders danger variant' do
      render_inline(Carbon::ModalComponent.new(danger: true)) do |c|
        c.with_header(title: 'Test Modal')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal.cds--modal--danger'
    end

    # -- Header slot --

    test 'renders header with title' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'My Modal Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-header .cds--modal-header__heading', text: 'My Modal Title'
    end

    test 'renders header with subtitle' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title', subtitle: 'Subtitle text')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-header .cds--modal-header__description', text: 'Subtitle text'
    end

    test 'renders header with label' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title', label: 'Label text')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-header .cds--modal-header__label', text: 'Label text'
    end

    test 'renders close button with icon and stimulus action' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-header button.cds--modal-close[aria-label="Close"]'
      assert_selector '.cds--modal-close svg.cds--modal-close__icon'
      assert_selector 'button.cds--modal-close[data-action="carbon--modal#close"]'
    end

    # -- Body slot --

    test 'renders body content' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Body text here' }
      end

      assert_selector '.cds--modal-content', text: 'Body text here'
    end

    # -- Footer slot --

    test 'renders footer' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
        c.with_footer { 'Footer content' }
      end

      assert_selector '.cds--modal-footer', text: 'Footer content'
    end

    test 'renders without footer when not provided' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_no_selector '.cds--modal-footer'
    end

    # -- aria-label --

    test 'renders aria-label on container when provided' do
      render_inline(Carbon::ModalComponent.new(aria_label: 'My accessible modal')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container[aria-label="My accessible modal"]'
    end

    test 'computes aria-label from header label when not explicitly provided' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Modal Title', label: 'Label Text')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container[aria-label="Label Text"]'
    end

    test 'computes aria-label from header title when label not provided' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Modal Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container[aria-label="Modal Title"]'
    end

    test 'explicit aria-label takes precedence over header title when no label' do
      render_inline(Carbon::ModalComponent.new(aria_label: 'Explicit Label')) do |c|
        c.with_header(title: 'Modal Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container[aria-label="Explicit Label"]'
    end

    test 'header label takes precedence over explicit aria-label' do
      render_inline(Carbon::ModalComponent.new(aria_label: 'Explicit Label')) do |c|
        c.with_header(title: 'Modal Title', label: 'Header Label')
        c.with_body { 'Content' }
      end

      # Priority: label > aria_label > title
      assert_selector '.cds--modal-container[aria-label="Header Label"]'
    end

    # -- prevent_close_on_click_outside --

    test 'sets prevent close on click outside data attribute' do
      render_inline(Carbon::ModalComponent.new(prevent_close_on_click_outside: true)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-prevent-close-on-click-outside-value="true"]'
    end

    # -- alert variant --

    test 'renders role dialog by default' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container[role="dialog"]'
    end

    test 'renders role alert when alert is true' do
      render_inline(Carbon::ModalComponent.new(alert: true)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container[role="alert"]'
    end

    # -- prevent_close --

    test 'sets prevent close data attribute' do
      render_inline(Carbon::ModalComponent.new(prevent_close: true)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-prevent-close-value="true"]'
    end

    # -- should_submit_on_enter --

    test 'sets should submit on enter data attribute' do
      render_inline(Carbon::ModalComponent.new(should_submit_on_enter: true)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-should-submit-on-enter-value="true"]'
    end

    # -- full_width --

    test 'renders without full width class by default' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_no_selector '.cds--modal-container--full-width'
    end

    test 'renders full width variant' do
      render_inline(Carbon::ModalComponent.new(full_width: true)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container.cds--modal-container--full-width'
    end

    # -- has_scrolling_content --

    test 'does not render overflow indicator by default' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_no_selector '.cds--modal-content--overflow-indicator'
    end

    test 'renders overflow indicator when has_scrolling_content is true' do
      render_inline(Carbon::ModalComponent.new(has_scrolling_content: true)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-content--overflow-indicator'
    end

    # -- container_class --

    test 'applies custom container class' do
      render_inline(Carbon::ModalComponent.new(container_class: 'custom-container-class')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container.custom-container-class'
    end

    test 'applies multiple custom container classes' do
      render_inline(Carbon::ModalComponent.new(container_class: 'class-one class-two')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector '.cds--modal-container.class-one.class-two'
    end

    # -- loading props --

    test 'sets loading status data attribute' do
      render_inline(Carbon::ModalComponent.new(loading_status: 'active')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-loading-status-value="active"]'
    end

    test 'sets loading description data attribute' do
      render_inline(Carbon::ModalComponent.new(loading_description: 'Saving...')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-loading-description-value="Saving..."]'
    end

    test 'sets loading icon description data attribute' do
      render_inline(Carbon::ModalComponent.new(loading_icon_description: 'Processing')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-loading-icon-description-value="Processing"]'
    end

    test 'sets loading success delay data attribute' do
      render_inline(Carbon::ModalComponent.new(loading_success_delay: 2000)) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div[data-carbon--modal-loading-success-delay-value="2000"]'
    end

    # -- close_button_label --

    test 'renders close button with default label' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'button.cds--modal-close[aria-label="Close"]'
    end

    test 'renders close button with custom label from header' do
      render_inline(Carbon::ModalComponent.new) do |c|
        c.with_header(title: 'Title', close_button_label: 'Dismiss')
        c.with_body { 'Content' }
      end

      assert_selector 'button.cds--modal-close[aria-label="Dismiss"]'
    end

    # -- xs size (already in SIZES) --

    test 'renders xs size via open param' do
      render_inline(Carbon::ModalComponent.new(open: true, size: :xs))

      assert_selector '.cds--modal-container--xs'
    end

    test 'renders full width via open param' do
      render_inline(Carbon::ModalComponent.new(open: true, full_width: true))

      assert_selector '.cds--modal-container--full-width'
    end

    test 'renders scrolling content overflow indicator via open param' do
      render_inline(Carbon::ModalComponent.new(open: true, has_scrolling_content: true))

      assert_selector '.cds--modal-content--overflow-indicator'
    end

    test 'renders custom close label on header' do
      render_inline(Carbon::ModalComponent.new(open: true)) do |c|
        c.with_header(title: 'Title', close_button_label: 'Dismiss')
        c.with_body { 'Content' }
      end

      assert_selector 'button[aria-label="Dismiss"]'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::ModalComponent.new(size: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::ModalComponent.new(id: 'custom-id')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      # The component generates its own id, but system_arguments id is overridden
      assert_selector 'div.cds--modal'
    end

    test 'merges custom class' do
      render_inline(Carbon::ModalComponent.new(class: 'custom-class')) do |c|
        c.with_header(title: 'Title')
        c.with_body { 'Content' }
      end

      assert_selector 'div.cds--modal.custom-class'
    end

    # -- Complete modal structure --

    test 'renders complete modal with all slots' do
      render_inline(Carbon::ModalComponent.new(open: true, size: :lg, danger: true)) do |c|
        c.with_header(title: 'Delete Resource', label: 'Account', subtitle: 'This action cannot be undone')
        c.with_body { 'Are you sure you want to delete this resource?' }
        c.with_footer { '<button class="cds--btn cds--btn--secondary">Cancel</button>'.html_safe }
      end

      assert_selector 'div.cds--modal.cds--modal--open.cds--modal--danger'
      assert_selector 'div.cds--modal-container.cds--modal-container--lg[role="dialog"]'
      assert_selector '.cds--modal-header__label', text: 'Account'
      assert_selector '.cds--modal-header__heading', text: 'Delete Resource'
      assert_selector '.cds--modal-header__description', text: 'This action cannot be undone'
      assert_selector '.cds--modal-content', text: 'Are you sure you want to delete this resource?'
      assert_selector '.cds--modal-footer .cds--btn'
      assert_selector 'button.cds--modal-close'
    end
  end
end
