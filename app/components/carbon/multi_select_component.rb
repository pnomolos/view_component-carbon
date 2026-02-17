# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System MultiSelect dropdown.
  #
  # @example Basic usage
  #   render Carbon::MultiSelectComponent.new(label_text: "Tags") do |ms|
  #     ms.with_item(value: "a", text: "Alpha")
  #   end
  #
  # @see https://carbondesignsystem.com/components/dropdown/usage/
  class MultiSelectComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :items, lambda { |value:, text:, selected: false, disabled: false|
      ItemData.new(value: value, text: text, selected: selected, disabled: disabled)
    }

    # @return [Symbol] component size
    attr_reader :size
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [String] trigger button text
    attr_reader :title_text
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether readonly
    attr_reader :readonly
    # @return [Boolean] whether filterable
    attr_reader :filterable

    # @param label_text [String, nil] label text
    # @param size [Symbol] component size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the component
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param helper_text [String, nil] helper text
    # @param title_text [String] trigger button text
    # @param filterable [Boolean] enables type-to-filter
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      label_text: nil,
      size: DEFAULT_SIZE,
      disabled: false,
      readonly: false,
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
      @readonly = readonly
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
      if @size != :md
        classes << "cds--list-box--#{@size}"
        classes << "cds--multi-select--#{@size}"
      end
      classes << 'cds--multi-select--filterable' if @filterable
      classes << 'cds--list-box--disabled' if @disabled
      classes << 'cds--multi-select--readonly' if @readonly
      classes << 'cds--multi-select--selected' if selected_count.positive?
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def listbox_data_attributes
      attrs = { controller: 'carbon--multi-select' }
      attrs[:'carbon--multi-select-title-text-value'] = @title_text
      attrs[:'carbon--multi-select-filterable-value'] = @filterable.to_s
      attrs[:'carbon--multi-select-read-only-value'] = @readonly.to_s
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

    # Data holder for multi-select item slots.
    class ItemData < ViewComponent::Base
      # @return [String] item value
      attr_reader :value
      # @return [String] item display text
      attr_reader :text
      # @return [Boolean] whether selected
      attr_reader :selected
      # @return [Boolean] whether disabled
      attr_reader :disabled
      # @return [String] unique item ID
      attr_reader :item_id

      # @param value [String] item value
      # @param text [String] item display text
      # @param selected [Boolean] whether selected
      # @param disabled [Boolean] whether disabled
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
