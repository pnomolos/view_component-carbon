# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Loading spinner.
  #
  # @example Basic usage
  #   render Carbon::LoadingComponent.new(active: true)
  #
  # @see https://carbondesignsystem.com/components/loading/usage/
  class LoadingComponent < BaseComponent
    SIZES = %i[small normal].freeze

    DEFAULT_SIZE = :normal

    # @return [Symbol] spinner size
    attr_reader :size
    # @return [Boolean] whether loading is active
    attr_reader :active
    # @return [Boolean] whether to show an overlay
    attr_reader :overlay

    # @param size [Symbol] spinner size (:small, :normal)
    # @param active [Boolean] whether the spinner is active
    # @param inactive [Boolean] alias for active: false
    # @param overlay [Boolean] shows an overlay behind the spinner
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(size: DEFAULT_SIZE, active: true, inactive: false, overlay: false, **system_arguments)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @active = inactive ? false : active
      @overlay = overlay
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string for the spinner
    def css_classes
      classes = ['cds--loading']
      classes << 'cds--loading--small' if @size == :small
      classes << 'cds--loading--stop' unless @active
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [String] CSS class string for the overlay
    def overlay_css_classes
      classes = ['cds--loading-overlay']
      classes << 'cds--loading-overlay--stop' unless @active
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the loading element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'status'
      attrs[:'aria-live'] = 'assertive'
      attrs[:'aria-atomic'] = 'true'
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
