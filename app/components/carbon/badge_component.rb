# frozen_string_literal: true

module Carbon
  class BadgeComponent < BaseComponent
    COLORS = %i[red blue green gray].freeze
    DEFAULT_COLOR = :gray

    COLOR_CSS = {
      red: 'red',
      blue: 'blue',
      green: 'green',
      gray: 'gray'
    }.freeze

    attr_reader :count, :color

    def initialize(count: nil, color: DEFAULT_COLOR, **system_arguments)
      @count = count
      @color = validate_argument(:color, color, COLORS, DEFAULT_COLOR) if color
      @system_arguments = system_arguments
    end

    def css_classes
      classes = ['cds--badge']
      classes << "cds--badge--#{COLOR_CSS[@color]}" if @color
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    def display_count
      return nil if @count.nil?
      return '9+' if @count > 9

      @count.to_s
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
