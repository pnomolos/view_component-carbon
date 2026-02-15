# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Dropdown select.
  #
  # @example Basic usage
  #   render Carbon::DropdownComponent.new(label_text: "Color") do |dd|
  #     dd.with_item(value: "red", text: "Red")
  #   end
  #
  # @see https://carbondesignsystem.com/components/dropdown/usage/
  class DropdownComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :items, 'Carbon::DropdownComponent::ItemComponent'

    # @return [String] label text
    attr_reader :label_text
    # @return [Symbol] dropdown size
    attr_reader :size
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether the label is hidden
    attr_reader :hide_label
    # @return [String] title text for the trigger button
    attr_reader :title_text

    # @param label_text [String] label text
    # @param size [Symbol] dropdown size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the dropdown
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param helper_text [String, nil] helper text
    # @param hide_label [Boolean] visually hides the label
    # @param title_text [String] trigger button text
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      label_text: 'Label',
      size: DEFAULT_SIZE,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      hide_label: false,
      title_text: 'Choose item',
      **system_arguments
    )
      @label_text = label_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @hide_label = hide_label
      @title_text = title_text
      @system_arguments = system_arguments
      @menu_id = "dropdown-menu-#{SecureRandom.hex(4)}"
      initialize_form_field(invalid: invalid, invalid_text: invalid_text, warn: warn,
                            warn_text: warn_text, helper_text: helper_text)
    end

    # @return [ItemComponent, nil] the currently selected item
    def selected_item
      items.find(&:selected)
    end

    # @return [String] text shown in the trigger button
    def display_text
      selected_item&.text || @title_text
    end

    private

    def css_classes
      classes = ['cds--dropdown', "cds--dropdown--#{@size}", 'cds--list-box', "cds--list-box--#{@size}"]
      classes << 'cds--dropdown--invalid' if @invalid
      classes << 'cds--dropdown--warning' if @warn
      classes << 'cds--dropdown--disabled' if @disabled
      classes << 'cds--list-box--disabled' if @disabled
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.except(:class).dup
      attrs[:class] = css_classes
      attrs['data-controller'] = 'carbon--dropdown'
      attrs
    end

    def label_classes
      classes = ['cds--label']
      classes << 'cds--visually-hidden' if @hide_label
      classes << 'cds--label--disabled' if @disabled
      class_names(classes)
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # A single dropdown option.
    class ItemComponent < BaseComponent
      # @return [String] item value
      attr_reader :value
      # @return [String] item display text
      attr_reader :text
      # @return [Boolean] whether selected
      attr_reader :selected
      # @return [Boolean] whether disabled
      attr_reader :disabled

      # @param value [String] item value
      # @param text [String] item display text
      # @param selected [Boolean] marks item as selected
      # @param disabled [Boolean] disables the item
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(value:, text:, selected: false, disabled: false, **system_arguments)
        @value = value
        @text = text
        @selected = selected
        @disabled = disabled
        @system_arguments = system_arguments
      end

      # @return [String] CSS class string for the item
      def css_classes
        classes = ['cds--list-box__menu-item']
        classes << 'cds--list-box__menu-item--active' if @selected
        class_names(classes)
      end

      def call
        # Rendered by parent template
        nil
      end
    end
  end
end
