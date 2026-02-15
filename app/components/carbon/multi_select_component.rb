# frozen_string_literal: true

module Carbon
  class MultiSelectComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :items, lambda { |value:, text:, selected: false, disabled: false|
      ItemData.new(value: value, text: text, selected: selected, disabled: disabled)
    }

    attr_reader :size, :label_text, :title_text, :disabled, :filterable

    def initialize(
      label_text: nil,
      size: DEFAULT_SIZE,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      title_text: 'Choose items',
      filterable: false,
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @label_text = label_text
      @title_text = title_text
      @disabled = disabled
      @filterable = filterable
      @system_arguments = system_arguments
      @id = system_arguments[:id] || "multi-select-#{SecureRandom.hex(4)}"
      @menu_id = "menu-#{SecureRandom.hex(4)}"
      @label_id = "label-#{SecureRandom.hex(4)}"
      initialize_form_field(invalid: invalid, invalid_text: invalid_text, warn: warn,
                            warn_text: warn_text, helper_text: helper_text)
      super()
    end

    private

    def wrapper_classes
      class_names('cds--multi-select__wrapper', 'cds--list-box__wrapper')
    end

    def listbox_classes
      classes = form_field_wrapper_classes('cds--multi-select')
      classes << 'cds--list-box'
      classes << "cds--list-box--#{@size}" if @size != :md
      classes << "cds--multi-select--#{@size}" if @size != :md
      classes << 'cds--multi-select--filterable' if @filterable
      classes << 'cds--list-box--disabled' if @disabled
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def listbox_data_attributes
      attrs = { controller: 'carbon--multi-select' }
      attrs[:'carbon--multi-select-title-text-value'] = @title_text
      attrs[:'carbon--multi-select-filterable-value'] = @filterable.to_s
      attrs
    end

    def selected_count
      items.count(&:selected)
    end

    def trigger_label
      count = selected_count
      return @title_text if count.zero?

      "#{count} #{count == 1 ? 'item' : 'items'} selected"
    end

    def chevron_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true" ' \
        'class="cds--list-box__menu-icon">' \
        '<path d="M8 11L3 6 3.7 5.3 8 9.6 12.3 5.3 13 6z"></path></svg>'
    end

    def clear_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true">' \
        '<path d="M24 9.4L22.6 8 16 14.6 9.4 8 8 9.4l6.6 6.6L8 22.6 9.4 24l6.6-6.6 6.6 6.6 ' \
        '1.4-1.4-6.6-6.6L24 9.4z"></path></svg>'
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # Simple data holder for item slots
    class ItemData < ViewComponent::Base
      attr_reader :value, :text, :selected, :disabled, :item_id

      def initialize(value:, text:, selected:, disabled:)
        @value = value
        @text = text
        @selected = selected
        @disabled = disabled
        @item_id = "item-#{SecureRandom.hex(4)}"
        super()
      end

      def call
        nil
      end
    end
  end
end
