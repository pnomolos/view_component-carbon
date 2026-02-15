# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Inline Notification.
  #
  # @example Basic usage
  #   render Carbon::InlineNotificationComponent.new(title: "Success!", kind: :success)
  #
  # @see https://carbondesignsystem.com/components/notification/usage/
  class InlineNotificationComponent < BaseComponent
    KINDS = %i[info success warning error info_square].freeze

    DEFAULT_KIND = :info

    KIND_CSS = {
      info: 'info',
      success: 'success',
      warning: 'warning',
      error: 'error',
      info_square: 'info-square'
    }.freeze

    # @return [Symbol] notification kind
    attr_reader :kind
    # @return [String] notification title
    attr_reader :title
    # @return [String, nil] notification subtitle
    attr_reader :subtitle
    # @return [Boolean] whether to hide the close button
    attr_reader :hide_close_button
    # @return [Boolean] whether to use low-contrast styling
    attr_reader :low_contrast

    # @param title [String] notification title
    # @param kind [Symbol] notification kind (:info, :success, :warning, :error, :info_square)
    # @param subtitle [String, nil] notification subtitle
    # @param hide_close_button [Boolean] hides the close button
    # @param low_contrast [Boolean] uses low-contrast styling
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      title:, kind: DEFAULT_KIND,
      subtitle: nil,
      hide_close_button: false,
      low_contrast: false,
      **system_arguments
    )
      @kind = validate_argument(:kind, kind, KINDS, DEFAULT_KIND)
      @title = title
      @subtitle = subtitle
      @hide_close_button = hide_close_button
      @low_contrast = low_contrast
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--inline-notification', "cds--inline-notification--#{KIND_CSS[@kind]}"]
      classes << 'cds--inline-notification--low-contrast' if @low_contrast
      classes << 'cds--inline-notification--hide-close-button' if @hide_close_button
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the notification element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'status'
      attrs[:aria] = { live: 'polite' }.merge(attrs.fetch(:aria, {}))
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--inline-notification'
      attrs
    end

    # @return [String] SVG markup for the notification icon
    def icon_svg
      case @kind
      when :success
        success_icon
      when :warning
        warning_icon
      when :error
        error_icon
      else
        info_icon
      end
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    def info_icon
      '<svg class="cds--inline-notification__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" ' \
      'width="20" height="20" fill="currentColor">' \
      '<path d="M16 2a14 14 0 1 0 14 14A14 14 0 0 0 16 2zm0 26a12 12 0 1 1 12-12 12 12 0 0 1-12 12z"/>' \
      '<path d="M15 10h2v2h-2zm0 4h2v8h-2z"/></svg>'.html_safe
    end

    def success_icon
      '<svg class="cds--inline-notification__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" ' \
      'width="20" height="20" fill="currentColor">' \
      '<path d="M16 2a14 14 0 1 0 14 14A14 14 0 0 0 16 2zm0 26a12 12 0 1 1 12-12 12 12 0 0 1-12 12z"/>' \
      '<path d="M14 21.5l-5-4.96 1.59-1.57L14 18.35 21.41 11 23 12.58l-9 8.92z"/></svg>'.html_safe
    end

    def warning_icon
      '<svg class="cds--inline-notification__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" ' \
      'width="20" height="20" fill="currentColor">' \
      '<path d="M16 2a14 14 0 1 0 14 14A14 14 0 0 0 16 2zm0 26a12 12 0 1 1 12-12 12 12 0 0 1-12 12z"/>' \
      '<path d="M15 8h2v11h-2zm1 14a1.5 1.5 0 1 0 1.5 1.5A1.5 1.5 0 0 0 16 22z"/></svg>'.html_safe
    end

    def error_icon
      '<svg class="cds--inline-notification__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" ' \
      'width="20" height="20" fill="currentColor">' \
      '<path d="M16 2a14 14 0 1 0 14 14A14 14 0 0 0 16 2zm0 26a12 12 0 1 1 12-12 12 12 0 0 1-12 12z"/>' \
      '<path d="M21.41 9l-5.41 5.41L10.59 9 9 10.59 14.41 16 9 21.41 10.59 23 16 17.59 21.41 23 23 21.41 ' \
      '17.59 16 23 10.59 21.41 9z"/></svg>'.html_safe
    end

    def close_icon
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor">' \
      '<path d="M24 9.4L22.6 8 16 14.6 9.4 8 8 9.4l6.6 6.6L8 22.6 9.4 24l6.6-6.6 6.6 6.6 1.4-1.4-6.6-6.6L24 9.4z"/>' \
      '</svg>'.html_safe
    end
  end
end
