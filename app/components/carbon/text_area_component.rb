# frozen_string_literal: true

module Carbon
  class TextAreaComponent < BaseComponent
    attr_reader :name, :value, :label_text, :helper_text, :placeholder, :disabled, :readonly, :invalid, :invalid_text,
                :rows, :cols, :max_count, :id

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
      rows: 4,
      cols: nil,
      max_count: nil,
      id: nil,
      **system_arguments
    )
      @name = name
      @value = value
      @label_text = label_text
      @helper_text = helper_text
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @invalid = invalid
      @invalid_text = invalid_text
      @rows = rows
      @cols = cols
      @max_count = max_count
      @id = id || "text-area-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    def wrapper_classes
      classes = ['cds--form-item', 'cds--text-area-wrapper']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def textarea_wrapper_classes
      classes = ['cds--text-area__wrapper']
      classes << 'cds--text-area__wrapper--invalid' if @invalid
      class_names(*classes)
    end

    def textarea_classes
      classes = ['cds--text-area']
      classes << 'cds--text-area--invalid' if @invalid
      class_names(*classes)
    end

    def textarea_attributes
      attrs = {
        class: textarea_classes,
        id: @id,
        name: @name,
        placeholder: @placeholder,
        rows: @rows,
        cols: @cols
      }
      attrs[:disabled] = '' if @disabled
      attrs[:readonly] = '' if @readonly
      attrs[:'data-invalid'] = 'true' if @invalid
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:maxlength] = @max_count if @max_count
      attrs.merge!(@system_arguments)
      attrs.compact
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
