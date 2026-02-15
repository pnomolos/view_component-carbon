# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Badge indicator.
  #
  # @example Basic usage
  #   render Carbon::BadgeComponent.new(count: 5, color: :blue)
  #
  # @see https://carbondesignsystem.com/components/badge/usage/
  class BadgeComponent < BaseComponent
    COLORS = %i[red blue green gray].freeze
    DEFAULT_COLOR = :gray

    COLOR_CSS = {
      red: 'red',
      blue: 'blue',
      green: 'green',
      gray: 'gray'
    }.freeze

    # @return [Integer, nil] the badge count
    attr_reader :count
    # @return [Symbol] the badge color
    attr_reader :color

    # @param count [Integer, nil] numeric count to display
    # @param color [Symbol] badge color (:red, :blue, :green, :gray)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(count: nil, color: DEFAULT_COLOR, **system_arguments)
      @count = count
      @color = validate_argument(:color, color, COLORS, DEFAULT_COLOR) if color
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string for the badge
    def css_classes
      classes = ['cds--badge']
      classes << "cds--badge--#{COLOR_CSS[@color]}" if @color
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the badge element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    # @return [String, nil] formatted count string, capped at "9+"
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
