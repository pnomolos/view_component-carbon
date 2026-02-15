# frozen_string_literal: true

module Carbon
  class TagComponent < BaseComponent
    TYPES = %i[read_only filter dismissible].freeze
    COLORS = %i[red magenta purple blue cyan teal green gray cool_gray warm_gray high_contrast outline].freeze
    SIZES = %i[sm md lg].freeze

    DEFAULT_TYPE = :read_only
    DEFAULT_SIZE = :md
    DEFAULT_COLOR = :gray

    COLOR_CSS = {
      red: 'red',
      magenta: 'magenta',
      purple: 'purple',
      blue: 'blue',
      cyan: 'cyan',
      teal: 'teal',
      green: 'green',
      gray: 'gray',
      cool_gray: 'cool-gray',
      warm_gray: 'warm-gray',
      high_contrast: 'high-contrast',
      outline: 'outline'
    }.freeze

    SIZE_CSS = {
      sm: 'sm',
      md: 'md',
      lg: 'lg'
    }.freeze

    TYPE_CSS = {
      read_only: nil,
      filter: 'filter',
      dismissible: 'dismissible'
    }.freeze

    attr_reader :type, :color, :size, :disabled

    def initialize(type: DEFAULT_TYPE, color: DEFAULT_COLOR, size: DEFAULT_SIZE, disabled: false, **system_arguments)
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @color = validate_argument(:color, color, COLORS, DEFAULT_COLOR)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @system_arguments = system_arguments
    end

    def css_classes
      classes = ['cds--tag', "cds--tag--#{SIZE_CSS[@size]}", "cds--tag--#{COLOR_CSS[@color]}"]
      classes << "cds--tag--#{TYPE_CSS[@type]}" if TYPE_CSS[@type]
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:disabled] = '' if @disabled && closeable?
      attrs
    end

    def closeable?
      @type == :filter || @type == :dismissible
    end

    def tag_name
      closeable? ? :button : :span
    end

    def close_icon_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
      'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true">' \
      '<path d="M24 9.4L22.6 8 16 14.6 9.4 8 8 9.4 14.6 16 8 22.6 9.4 24 16 17.4 22.6 24 24 22.6 17.4 16 24 9.4z">' \
      '</path></svg>'.html_safe
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
