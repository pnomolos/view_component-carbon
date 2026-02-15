# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Radio Button Group.
  #
  # @example Basic usage
  #   render Carbon::RadioButtonGroupComponent.new(name: "color", legend_text: "Color") do |g|
  #     g.with_radio(value: "red", label_text: "Red")
  #   end
  #
  # @see https://carbondesignsystem.com/components/radio-button/usage/
  class RadioButtonGroupComponent < BaseComponent
    ORIENTATIONS = %i[horizontal vertical].freeze
    DEFAULT_ORIENTATION = :vertical

    renders_many :radios, lambda { |**args|
      Carbon::RadioButtonComponent.new(name: @name, **args)
    }

    # @return [String] input name shared by all radios
    attr_reader :name
    # @return [Symbol] layout orientation
    attr_reader :orientation
    # @return [String, nil] fieldset legend text
    attr_reader :legend_text

    # @param name [String] input name shared by all radios
    # @param legend_text [String, nil] fieldset legend text
    # @param orientation [Symbol] layout (:horizontal, :vertical)
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      name:,
      legend_text: nil,
      orientation: DEFAULT_ORIENTATION,
      **system_arguments
    )
      @name = name
      @legend_text = legend_text
      @orientation = validate_argument(:orientation, orientation, ORIENTATIONS, DEFAULT_ORIENTATION)
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string for the wrapper
    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the wrapper
    def wrapper_attributes
      @system_arguments
    end

    # @return [String] CSS class string for the fieldset
    def fieldset_classes
      classes = [
        'cds--radio-button-group',
        "cds--radio-button-group--#{@orientation}"
      ]
      class_names(*classes)
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
