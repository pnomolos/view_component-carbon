# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Badge indicator.
  #
  # @example Basic usage
  #   render Carbon::BadgeComponent.new(count: 5, kind: :blue)
  #
  # @see https://carbondesignsystem.com/components/badge/usage/
  class BadgeComponent < BaseComponent
    KINDS = %i[red gray green blue purple cyan teal magenta high_contrast].freeze
    DEFAULT_KIND = :gray

    KIND_CSS = {
      red: 'red',
      gray: 'gray',
      green: 'green',
      blue: 'blue',
      purple: 'purple',
      cyan: 'cyan',
      teal: 'teal',
      magenta: 'magenta',
      high_contrast: 'high-contrast'
    }.freeze

    # @return [Integer, nil] the badge count
    attr_reader :count
    # @return [Symbol] the badge kind
    attr_reader :kind

    # @param count [Integer, nil] numeric count to display
    # @param kind [Symbol] badge kind (:red, :gray, :green, :blue, :purple, :cyan, :teal, :magenta, :high_contrast)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(count: nil, kind: DEFAULT_KIND, **system_arguments)
      @count = count
      @kind = validate_argument(:kind, kind, KINDS, DEFAULT_KIND) if kind
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string for the badge
    def css_classes
      classes = ['cds--badge']
      classes << "cds--badge--#{KIND_CSS[@kind]}" if @kind
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
