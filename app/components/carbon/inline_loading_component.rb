# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Inline Loading indicator.
  #
  # @example Basic usage
  #   render Carbon::InlineLoadingComponent.new(status: :active, description: "Loading...")
  #
  # @see https://carbondesignsystem.com/components/inline-loading/usage/
  class InlineLoadingComponent < BaseComponent
    STATUSES = %i[active finished error inactive].freeze

    DEFAULT_STATUS = :active

    # @return [Symbol] loading status
    attr_reader :status
    # @return [String, nil] description text
    attr_reader :description
    # @return [Boolean] overlay variant flag
    attr_reader :overlay

    # @param status [Symbol] loading status (:active, :finished, :error, :inactive)
    # @param description [String, nil] description text
    # @param overlay [Boolean] enable overlay variant
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(status: DEFAULT_STATUS, description: nil, overlay: false, **system_arguments)
      @status = validate_argument(:status, status, STATUSES, DEFAULT_STATUS)
      @description = description
      @overlay = overlay
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--inline-loading']
      classes << "cds--inline-loading--#{@status}"
      classes << 'cds--inline-loading--overlay' if @overlay
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the loading element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'status'
      attrs[:'aria-live'] = 'assertive'
      attrs
    end

    # @return [String] SVG markup for the status icon
    def icon_svg
      case @status
      when :finished
        checkmark_icon
      when :error
        error_icon
      else
        ''
      end
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    def checkmark_icon
      '<svg class="cds--inline-loading__checkmark-container" xmlns="http://www.w3.org/2000/svg" ' \
      'viewBox="0 0 16 16" fill="currentColor">' \
      '<title>Finished</title>' \
      '<path d="M6.5 11.5L3 8l1-1 2.5 2.5L11 5l1 1z"/>' \
      '</svg>'.html_safe
    end

    def error_icon
      '<svg class="cds--inline-loading--error" xmlns="http://www.w3.org/2000/svg" ' \
      'viewBox="0 0 16 16" fill="currentColor">' \
      '<title>Error</title>' \
      '<path d="M8 1C4.1 1 1 4.1 1 8s3.1 7 7 7 7-3.1 7-7-3.1-7-7-7zm3.5 9.5l-1 1L8 9l-2.5 2.5-1-1L7 8 ' \
      '4.5 5.5l1-1L8 7l2.5-2.5 1 1L9 8l2.5 2.5z"/>' \
      '</svg>'.html_safe
    end
  end
end
