# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ToastNotificationComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default toast notification' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Notification'))

      assert_selector '.cds--toast-notification.cds--toast-notification--info'
      assert_selector "[role='status'][aria-live='polite']"
      assert_selector '.cds--toast-notification__title', text: 'Notification'
    end

    # -- Kinds --

    test 'renders info kind (default)' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Info', kind: :info))

      assert_selector '.cds--toast-notification--info'
    end

    test 'renders success kind' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Success', kind: :success))

      assert_selector '.cds--toast-notification--success'
    end

    test 'renders warning kind' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Warning', kind: :warning))

      assert_selector '.cds--toast-notification--warning'
    end

    test 'renders error kind' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Error', kind: :error))

      assert_selector '.cds--toast-notification--error'
    end

    test 'renders info_square kind' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Info Square', kind: :info_square))

      assert_selector '.cds--toast-notification--info-square'
    end

    # -- Title, subtitle, caption --

    test 'renders title' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Main Title'))

      assert_selector '.cds--toast-notification__title', text: 'Main Title'
    end

    test 'renders subtitle when provided' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', subtitle: 'Subtitle'))

      assert_selector '.cds--toast-notification__subtitle', text: 'Subtitle'
    end

    test 'does not render subtitle when not provided' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_no_selector '.cds--toast-notification__subtitle'
    end

    test 'renders caption when provided' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', caption: 'Caption'))

      assert_selector '.cds--toast-notification__caption', text: 'Caption'
    end

    test 'does not render caption when not provided' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_no_selector '.cds--toast-notification__caption'
    end

    # -- Close button --

    test 'renders close button by default' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_selector "button.cds--toast-notification__close-button[aria-label='close notification']"
    end

    test 'hides close button when hide_close_button is true' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', hide_close_button: true))

      assert_no_selector '.cds--toast-notification__close-button'
    end

    test 'close button has stimulus action' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_selector 'button[data-action="click->carbon--toast-notification#close"]'
    end

    # -- Timeout --

    test 'sets timeout data attribute when timeout is provided' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', timeout: 3000))

      assert_selector '[data-carbon--toast-notification-timeout-value="3000"]'
    end

    test 'does not set timeout data attribute when timeout is nil' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', timeout: nil))

      assert_no_selector '[data-carbon--toast-notification-timeout-value]'
    end

    test 'does not set timeout data attribute when timeout is 0' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', timeout: 0))

      assert_no_selector '[data-carbon--toast-notification-timeout-value]'
    end

    # -- Low contrast --

    test 'applies low-contrast class when low_contrast is true' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', low_contrast: true))

      assert_selector '.cds--toast-notification--low-contrast'
    end

    test 'does not apply low-contrast class by default' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_no_selector '.cds--toast-notification--low-contrast'
    end

    # -- Stimulus controller --

    test 'has stimulus controller data attribute' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_selector '[data-controller="carbon--toast-notification"]'
    end

    # -- Icon --

    test 'renders icon' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title'))

      assert_selector 'svg.cds--toast-notification__icon'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::ToastNotificationComponent.new(
                      title: 'Title',
                      id: 'my-toast',
                      data: { testid: 'toast-1' }
                    ))

      assert_selector ".cds--toast-notification#my-toast[data-testid='toast-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', class: 'my-custom-class'))

      assert_selector '.cds--toast-notification.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid kind' do
      assert_raises(ArgumentError) do
        Carbon::ToastNotificationComponent.new(title: 'Title', kind: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for kind' do
      render_inline(Carbon::ToastNotificationComponent.new(title: 'Title', kind: 'success'))

      assert_selector '.cds--toast-notification--success'
    end
  end
end
