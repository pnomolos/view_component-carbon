# frozen_string_literal: true

module Carbon
  class DatePickerComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    TYPES = %i[simple single range].freeze
    DEFAULT_TYPE = :simple

    renders_one :range_input, lambda { |label_text: 'End date', placeholder: @placeholder, name: nil, id: nil|
      DatePickerRangeInputComponent.new(
        label_text: label_text,
        placeholder: placeholder,
        name: name,
        id: id,
        disabled: @disabled,
        readonly: @readonly
      )
    }

    attr_reader :label_text, :type, :disabled, :readonly, :placeholder, :date_format

    def initialize(
      type: DEFAULT_TYPE,
      value: nil,
      date_format: 'm/d/Y',
      label_text: 'Date Picker label',
      placeholder: 'mm/dd/yyyy',
      disabled: false,
      readonly: false,
      name: nil,
      id: nil,
      min_date: nil,
      max_date: nil,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      **system_arguments
    )
      @type = validate_type(type)
      @value = value
      @date_format = date_format
      @label_text = label_text
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @name = name
      @id = id || "date-picker-#{SecureRandom.hex(4)}"
      @min_date = min_date
      @max_date = max_date
      @system_arguments = system_arguments
      initialize_form_field(invalid: invalid, invalid_text: invalid_text, warn: warn,
                            warn_text: warn_text, helper_text: helper_text)
    end

    def simple?
      @type == :simple
    end

    def calendar_type?
      @type == :single || @type == :range
    end

    private

    def wrapper_classes
      classes = ['cds--date-picker', "cds--date-picker--#{@type}"]
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def wrapper_attributes
      attrs = @system_arguments.except(:class).dup
      attrs[:class] = wrapper_classes
      unless simple?
        attrs['data-controller'] = 'carbon--date-picker'
        attrs['data-carbon--date-picker-type-value'] = @type.to_s
        attrs['data-carbon--date-picker-date-format-value'] = @date_format
        attrs['data-carbon--date-picker-min-date-value'] = @min_date if @min_date
        attrs['data-carbon--date-picker-max-date-value'] = @max_date if @max_date
      end
      attrs
    end

    def input_classes
      classes = ['cds--date-picker__input']
      classes << 'cds--date-picker__input--invalid' if @invalid
      class_names(classes)
    end

    def input_attributes
      build_base_input_attrs.merge(build_optional_input_attrs).merge(data_invalid_attrs)
    end

    def build_base_input_attrs
      { type: 'text', class: input_classes, placeholder: @placeholder, id: @id }
    end

    def build_optional_input_attrs
      attrs = {}
      attrs[:name] = @name if @name
      attrs[:value] = @value if @value
      attrs[:disabled] = true if @disabled
      attrs[:readonly] = true if @readonly
      attrs['data-carbon--date-picker-target'] = 'input' unless simple?
      attrs['aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs
    end

    def label_classes
      classes = ['cds--label']
      classes << 'cds--label--disabled' if @disabled
      class_names(classes)
    end

    def calendar_icon_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true" ' \
        'class="cds--date-picker__icon">' \
        '<path d="M26,4h-4V2h-2v2h-8V2h-2v2H6C4.9,4,4,4.9,4,6v20c0,1.1,0.9,2,2,2h20c1.1,0,2-0.9,' \
        '2-2V6C28,4.9,27.1,4,26,4z ' \
        'M26,26H6V12h20V26z M26,10H6V6h4v2h2V6h8v2h2V6h4V10z"></path>' \
        '</svg>'
    end

    def validate_type(value)
      value = value.to_sym if value.is_a?(String)
      return value if TYPES.include?(value)

      raise ArgumentError,
            "Invalid type: #{value.inspect}. Must be one of: #{TYPES.map(&:inspect).join(', ')}"
    end

    class DatePickerRangeInputComponent < BaseComponent
      attr_reader :label_text, :placeholder, :name, :id, :disabled, :readonly

      def initialize(label_text:, placeholder:, name:, id:, disabled:, readonly:)
        @label_text = label_text
        @placeholder = placeholder
        @name = name
        @id = id || "date-picker-range-#{SecureRandom.hex(4)}"
        @disabled = disabled
        @readonly = readonly
      end

      def call
        # Rendered by parent template
        nil
      end
    end
  end
end
