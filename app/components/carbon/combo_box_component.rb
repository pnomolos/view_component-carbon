# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System ComboBox (filterable dropdown).
  #
  # @example Basic usage
  #   render Carbon::ComboBoxComponent.new(label_text: "Choose") do |cb|
  #     cb.with_item(value: "1", text: "Option 1")
  #   end
  #
  # @see https://carbondesignsystem.com/components/dropdown/usage/
  class ComboBoxComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :items, lambda { |value:, text:, disabled: false|
      ItemData.new(value: value, text: text, disabled: disabled)
    }

    # @return [Symbol] combo box size
    attr_reader :size
    # @return [String, nil] label text
    attr_reader :label_text
    # @return [String] placeholder text
    attr_reader :placeholder
    # @return [Boolean] whether the combo box is disabled
    attr_reader :disabled

    # @param label_text [String, nil] label text
    # @param size [Symbol] combo box size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the combo box
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param helper_text [String, nil] helper text
    # @param placeholder [String] placeholder text for the input
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      label_text: nil,
      size: DEFAULT_SIZE,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      placeholder: 'Filter...',
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @label_text = label_text
      @placeholder = placeholder
      @disabled = disabled
      @system_arguments = system_arguments
      @id = system_arguments[:id] || "combo-box-#{SecureRandom.hex(4)}"
      @input_id = "combo-input-#{SecureRandom.hex(4)}"
      @menu_id = "menu-#{SecureRandom.hex(4)}"
      @label_id = "label-#{SecureRandom.hex(4)}"
      initialize_form_field(invalid: invalid, invalid_text: invalid_text, warn: warn,
                            warn_text: warn_text, helper_text: helper_text)
      super()
    end

    private

    def wrapper_classes
      class_names('cds--combo-box__wrapper', 'cds--list-box__wrapper')
    end

    def listbox_classes
      classes = form_field_wrapper_classes('cds--combo-box')
      classes << 'cds--list-box'
      classes << "cds--list-box--#{@size}" if @size != :md
      classes << "cds--combo-box--#{@size}" if @size != :md
      classes << 'cds--list-box--disabled' if @disabled
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
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

    # Data holder for combo box item slots.
    class ItemData < ViewComponent::Base
      # @return [String] item value
      attr_reader :value
      # @return [String] item display text
      attr_reader :text
      # @return [Boolean] whether the item is disabled
      attr_reader :disabled
      # @return [String] unique item ID
      attr_reader :item_id

      # @param value [String] item value
      # @param text [String] item display text
      # @param disabled [Boolean] whether the item is disabled
      def initialize(value:, text:, disabled:)
        @value = value
        @text = text
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
