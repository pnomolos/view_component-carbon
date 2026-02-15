# frozen_string_literal: true

module Carbon
  class InlineNotificationComponentPreview < ViewComponent::Preview
    # @param kind select { choices: [info, success, warning, error, info_square] }
    # @param title text
    # @param subtitle text
    # @param hide_close_button toggle
    # @param low_contrast toggle
    def default(
      kind: :info,
      title: 'Notification title',
      subtitle: 'Subtitle text',
      hide_close_button: false,
      low_contrast: false
    )
      render Carbon::InlineNotificationComponent.new(
        kind: kind.to_sym,
        title: title,
        subtitle: subtitle,
        hide_close_button: hide_close_button,
        low_contrast: low_contrast
      )
    end

    # @!group All Kinds

    def info
      render Carbon::InlineNotificationComponent.new(
        kind: :info,
        title: 'Info notification',
        subtitle: 'This is an informational message'
      )
    end

    def success
      render Carbon::InlineNotificationComponent.new(
        kind: :success,
        title: 'Success!',
        subtitle: 'Your changes have been saved'
      )
    end

    def warning
      render Carbon::InlineNotificationComponent.new(
        kind: :warning,
        title: 'Warning',
        subtitle: 'Please review your input'
      )
    end

    def error
      render Carbon::InlineNotificationComponent.new(
        kind: :error,
        title: 'Error',
        subtitle: 'Something went wrong'
      )
    end

    def info_square
      render Carbon::InlineNotificationComponent.new(
        kind: :info_square,
        title: 'Info square',
        subtitle: 'Alternative info style'
      )
    end

    # @!endgroup

    def low_contrast
      render Carbon::InlineNotificationComponent.new(
        title: 'Low contrast',
        subtitle: 'Low contrast notification',
        low_contrast: true
      )
    end

    def without_close_button
      render Carbon::InlineNotificationComponent.new(
        title: 'No close button',
        subtitle: 'This notification cannot be dismissed',
        hide_close_button: true
      )
    end

    def title_only
      render Carbon::InlineNotificationComponent.new(
        title: 'Title only notification'
      )
    end
  end
end
