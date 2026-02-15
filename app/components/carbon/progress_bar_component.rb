# frozen_string_literal: true

module Carbon
  class ProgressBarComponent < BaseComponent
    SIZES = %i[big small].freeze
    STATUSES = %i[active finished error].freeze
    TYPES = %i[default inline indeterminate].freeze

    DEFAULT_SIZE = :big
    DEFAULT_STATUS = :active
    DEFAULT_TYPE = :default

    attr_reader :value, :max, :label, :helper_text, :size, :status, :type

    def initialize(
      value: nil,
      max: 100,
      label: nil,
      helper_text: nil,
      size: DEFAULT_SIZE,
      status: DEFAULT_STATUS,
      type: DEFAULT_TYPE,
      **system_arguments
    )
      @value = value
      @max = max
      @label = label
      @helper_text = helper_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @status = validate_argument(:status, status, STATUSES, DEFAULT_STATUS)
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @system_arguments = system_arguments

      validate_value_for_type
    end

    def css_classes
      classes = ['cds--progress-bar']
      classes << "cds--progress-bar--#{@size}"
      classes << "cds--progress-bar--#{@status}"
      classes << "cds--progress-bar--#{@type}" if @type != :default
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    def progress_attributes
      attrs = {
        role: 'progressbar',
        'aria-valuemin': 0,
        'aria-valuemax': @max
      }
      attrs[:'aria-valuenow'] = @value if @value && @type == :default
      attrs[:'aria-label'] = @label if @label
      attrs
    end

    def bar_style
      return '' if @type == :indeterminate || @value.nil?

      progress = [@value.to_f / @max, 1.0].min
      "transform: scaleX(#{progress})"
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    def validate_value_for_type
      return unless @type == :default && @value.nil?

      raise ArgumentError, 'value is required when type is :default'
    end
  end
end
