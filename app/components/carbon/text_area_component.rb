# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Text Area.
  #
  # @example Basic usage
  #   render Carbon::TextAreaComponent.new(label_text: "Description", name: "desc")
  #
  # @see https://carbondesignsystem.com/components/text-input/usage/
  class TextAreaComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    # @return [String, nil] input name
    attr_reader :name
    # @return [String, nil] current value
    attr_reader :value
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [String, nil] helper text
    attr_reader :helper_text
    # @return [String, nil] placeholder text
    attr_reader :placeholder
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether readonly
    attr_reader :readonly
    # @return [Boolean] whether in invalid state
    attr_reader :invalid
    # @return [String, nil] validation error message
    attr_reader :invalid_text
    # @return [Boolean] whether in warning state
    attr_reader :warn
    # @return [String, nil] warning message
    attr_reader :warn_text
    # @return [Integer] number of visible rows
    attr_reader :rows
    # @return [Integer, nil] number of columns
    attr_reader :cols
    # @return [Integer, nil] maximum character count
    attr_reader :max_count
    # @return [String] counter mode ('character' or 'word')
    attr_reader :counter_mode
    # @return [Boolean] whether the counter is enabled
    attr_reader :enable_counter
    # @return [String] unique element ID
    attr_reader :id

    # @param name [String, nil] input name attribute
    # @param value [String, nil] initial value
    # @param label_text [String, nil] label text
    # @param helper_text [String, nil] helper text
    # @param placeholder [String, nil] placeholder text
    # @param disabled [Boolean] disables the textarea
    # @param readonly [Boolean] makes the textarea readonly
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param rows [Integer] number of visible rows
    # @param cols [Integer, nil] number of columns
    # @param max_count [Integer, nil] maximum character count
    # @param counter_mode [String] counter mode ('character' or 'word')
    # @param enable_counter [Boolean] whether to enable the counter
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
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
      counter_mode: 'character',
      enable_counter: false,
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
      @counter_mode = counter_mode
      @enable_counter = enable_counter || max_count.present?
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

    # @return [String] CSS class string for the outer wrapper
    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [String] CSS class string for the textarea wrapper
    def textarea_wrapper_classes
      class_names(*form_field_wrapper_classes('cds--text-area__wrapper'))
    end

    # @return [String] CSS class string for the textarea
    def textarea_classes
      classes = ['cds--text-area']
      classes << 'cds--text-area--invalid' if @invalid
      classes << 'cds--text-area--warn' if @warn
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the textarea
    def textarea_attributes
      attrs = base_textarea_attributes
      add_textarea_state_attributes(attrs)
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    # @return [Hash] base HTML attributes for the textarea
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

    # @param attrs [Hash] attributes hash to modify
    # @return [void]
    def add_textarea_state_attributes(attrs)
      attrs[:disabled] = '' if @disabled
      attrs[:readonly] = '' if @readonly
      attrs[:'aria-readonly'] = 'true' if @readonly
      add_textarea_validation_attributes(attrs)
      attrs[:maxlength] = @max_count if @max_count
      attrs[:'aria-describedby'] = build_aria_describedby if aria_describedby_id || counter_description_id
    end

    # @param attrs [Hash] attributes hash to modify
    # @return [void]
    def add_textarea_validation_attributes(attrs)
      attrs[:'data-invalid'] = '' if @invalid
      attrs[:'aria-invalid'] = 'true' if @invalid
      attrs[:'data-warn'] = 'true' if @warn
    end

    # @return [Boolean] whether a Stimulus controller is needed
    def stimulus_controller?
      @max_count.present?
    end

    # @return [Hash] Stimulus data attributes for the wrapper
    def wrapper_data_attributes
      return {} unless stimulus_controller?

      {
        data: {
          controller: 'carbon--text-area',
          'carbon--text-area-max-count-value': @max_count
        }
      }
    end

    # @return [String, nil] ID for counter description element
    def counter_description_id
      return nil unless stimulus_controller?

      "#{@id}-counter-desc"
    end

    # @return [String, nil] Combined aria-describedby value
    def build_aria_describedby
      ids = []
      ids << counter_description_id if counter_description_id
      ids << aria_describedby_id if aria_describedby_id
      ids.join(' ') if ids.any?
    end
  end
end
