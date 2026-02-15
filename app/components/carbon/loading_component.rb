# frozen_string_literal: true

module Carbon
  class LoadingComponent < BaseComponent
    SIZES = %i[small normal].freeze

    DEFAULT_SIZE = :normal

    attr_reader :size, :active, :overlay

    def initialize(size: DEFAULT_SIZE, active: true, overlay: false, **system_arguments)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @active = active
      @overlay = overlay
      @system_arguments = system_arguments
    end

    def css_classes
      classes = ['cds--loading']
      classes << 'cds--loading--small' if @size == :small
      classes << 'cds--loading--stop' unless @active
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def overlay_css_classes
      classes = ['cds--loading-overlay']
      classes << 'cds--loading-overlay--stop' unless @active
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'status'
      attrs[:'aria-live'] = 'assertive'
      attrs
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
