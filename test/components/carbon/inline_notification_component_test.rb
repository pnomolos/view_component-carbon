# frozen_string_literal: true

require 'test_helper'

module Carbon
  class InlineNotificationComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default inline notification' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Notification'))

      assert_selector '.cds--inline-notification.cds--inline-notification--info'
      assert_selector "[role='status'][aria-live='polite']"
      assert_selector '.cds--inline-notification__title', text: 'Notification'
    end

    # -- Kinds --

    test 'renders info kind (default)' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Info', kind: :info))

      assert_selector '.cds--inline-notification--info'
    end

    test 'renders success kind' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Success', kind: :success))

      assert_selector '.cds--inline-notification--success'
    end

    test 'renders warning kind' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Warning', kind: :warning))

      assert_selector '.cds--inline-notification--warning'
    end

    test 'renders error kind' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Error', kind: :error))

      assert_selector '.cds--inline-notification--error'
    end

    test 'renders info_square kind' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Info Square', kind: :info_square))

      assert_selector '.cds--inline-notification--info-square'
    end

    # -- Title and subtitle --

    test 'renders title' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Main Title'))

      assert_selector '.cds--inline-notification__title', text: 'Main Title'
    end

    test 'renders subtitle when provided' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title', subtitle: 'Subtitle'))

      assert_selector '.cds--inline-notification__subtitle', text: 'Subtitle'
    end

    test 'does not render subtitle when not provided' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_no_selector '.cds--inline-notification__subtitle'
    end

    # -- Close button --

    test 'renders close button by default' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_selector "button.cds--inline-notification__close-button[aria-label='Close']"
    end

    test 'hides close button when hide_close_button is true' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title', hide_close_button: true))

      assert_no_selector '.cds--inline-notification__close-button'
    end

    test 'close button has stimulus action' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_selector 'button[data-action="click->carbon--inline-notification#close"]'
    end

    # -- Low contrast --

    test 'applies low-contrast class when low_contrast is true' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title', low_contrast: true))

      assert_selector '.cds--inline-notification--low-contrast'
    end

    test 'does not apply low-contrast class by default' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_no_selector '.cds--inline-notification--low-contrast'
    end

    # -- Stimulus controller --

    test 'has stimulus controller data attribute' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_selector '[data-controller="carbon--inline-notification"]'
    end

    # -- Icon --

    test 'renders icon' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_selector '.cds--inline-notification__icon svg'
    end

    # -- Structure --

    test 'has correct structure' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title'))

      assert_selector '.cds--inline-notification__details'
      assert_selector '.cds--inline-notification__text-wrapper'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::InlineNotificationComponent.new(
                      title: 'Title',
                      id: 'my-notification',
                      data: { testid: 'notification-1' }
                    ))

      assert_selector ".cds--inline-notification#my-notification[data-testid='notification-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title', class: 'my-custom-class'))

      assert_selector '.cds--inline-notification.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid kind' do
      assert_raises(ArgumentError) do
        Carbon::InlineNotificationComponent.new(title: 'Title', kind: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for kind' do
      render_inline(Carbon::InlineNotificationComponent.new(title: 'Title', kind: 'success'))

      assert_selector '.cds--inline-notification--success'
    end
  end
end
