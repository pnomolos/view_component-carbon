# frozen_string_literal: true

module Carbon
  class TextAreaComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    attr_reader :name, :value, :label_text, :helper_text, :placeholder, :disabled, :readonly, :invalid, :invalid_text,
                :warn, :warn_text, :rows, :cols, :max_count, :id

    def initialize(
      name: nil,
      value: nil,
      label_text: nil,
      helper_text: nil,
      placeholder: nil,
      disabled: false,
      readonly: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      rows: 4,
      cols: nil,
      max_count: nil,
      id: nil,
      **system_arguments
    )
      @name = name
      @value = value
      @label_text = label_text
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @rows = rows
      @cols = cols
      @max_count = max_count
      @id = id || "text-area-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments

      initialize_form_field(
        invalid: invalid,
        invalid_text: invalid_text,
        warn: warn,
        warn_text: warn_text,
        helper_text: helper_text
      )
    end

    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def textarea_wrapper_classes
      class_names(*form_field_wrapper_classes('cds--text-area__wrapper'))
    end

    def textarea_classes
      classes = ['cds--text-area']
      classes << 'cds--text-area--invalid' if @invalid
      classes << 'cds--text-area--warning' if @warn
      class_names(*classes)
    end

    def textarea_attributes
      attrs = base_textarea_attributes
      add_textarea_state_attributes(attrs)
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def base_textarea_attributes
      {
        class: textarea_classes,
        id: @id,
        name: @name,
        placeholder: @placeholder,
        rows: @rows,
        cols: @cols
      }
    end

    def add_textarea_state_attributes(attrs)
      attrs[:disabled] = '' if @disabled
      attrs[:readonly] = '' if @readonly
      add_textarea_validation_attributes(attrs)
      attrs[:maxlength] = @max_count if @max_count
      attrs[:'aria-describedby'] = aria_describedby_id if aria_describedby_id
    end

    def add_textarea_validation_attributes(attrs)
      attrs[:'data-invalid'] = '' if @invalid
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'data-warn'] = 'true' if @warn
    end

    def stimulus_controller?
      @max_count.present?
    end

    def wrapper_data_attributes
      return {} unless stimulus_controller?

      {
        data: {
          controller: 'carbon--text-area',
          'carbon--text-area-max-count-value': @max_count
        }
      }
    end
  end
end
