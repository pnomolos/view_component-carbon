# frozen_string_literal: true

module Carbon
  class RadioButtonGroupComponent < BaseComponent
    ORIENTATIONS = %i[horizontal vertical].freeze
    DEFAULT_ORIENTATION = :vertical

    renders_many :radios, lambda { |**args|
      Carbon::RadioButtonComponent.new(name: @name, **args)
    }

    attr_reader :name, :orientation, :legend_text

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

    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def wrapper_attributes
      @system_arguments
    end

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
