# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Dropdown select.
  #
  # @example Basic usage
  #   render Carbon::DropdownComponent.new(title_text: "Color") do |dd|
  #     dd.with_item(value: "red", text: "Red")
  #   end
  #
  # @see https://carbondesignsystem.com/components/dropdown/usage/
  class DropdownComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md
    DIRECTIONS = %i[top bottom].freeze
    DEFAULT_DIRECTION = :bottom
    TYPES = ['', 'inline'].freeze

    renders_many :items, 'Carbon::DropdownComponent::ItemComponent'

    # @return [String] label text (deprecated, use title_text)
    attr_reader :label_text
    # @return [String] title text for the label above dropdown
    attr_reader :title_text
    # @return [String] placeholder text in trigger button
    attr_reader :label
    # @return [Symbol] dropdown size
    attr_reader :size
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether read-only
    attr_reader :read_only
    # @return [Boolean] whether the label is hidden
    attr_reader :hide_label
    # @return [Boolean] whether required
    attr_reader :required
    # @return [Boolean] controlled open state
    attr_reader :open
    # @return [String] selected value
    attr_reader :value
    # @return [String] name for FormData
    attr_reader :name
    # @return [String] aria-label for screen readers
    attr_reader :aria_label
    # @return [Symbol] menu direction
    attr_reader :direction
    # @return [Boolean] enable Floating UI autoalign
    attr_reader :autoalign
    # @return [String] type ('', 'inline')
    attr_reader :type
    # @return [String] toggle label when closed
    attr_reader :toggle_label_closed
    # @return [String] toggle label when open
    attr_reader :toggle_label_open
    # @return [String] custom validity message
    attr_reader :validity_message
    # @return [String] custom required validity message
    attr_reader :required_validity_message

    # @param title_text [String] label text above dropdown
    # @param label_text [String] deprecated alias for title_text
    # @param label [String] placeholder text in trigger button when nothing selected
    # @param size [Symbol] dropdown size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the dropdown
    # @param read_only [Boolean] prevents interaction but shows as enabled
    # @param invalid [Boolean] marks as invalid
    # @param invalid_text [String, nil] validation error message
    # @param warn [Boolean] marks as warning
    # @param warn_text [String, nil] warning message
    # @param helper_text [String, nil] helper text
    # @param hide_label [Boolean] visually hides the label
    # @param required [Boolean] marks field as required for form validation
    # @param open [Boolean] controlled open state
    # @param value [String, nil] selected value
    # @param name [String, nil] name for FormData
    # @param aria_label [String, nil] aria-label for screen readers
    # @param direction [Symbol] menu direction (:top, :bottom)
    # @param autoalign [Boolean] enable Floating UI autoalign
    # @param type [String] type ('', 'inline')
    # @param toggle_label_closed [String, nil] aria-label for closed state
    # @param toggle_label_open [String, nil] aria-label for open state
    # @param validity_message [String, nil] custom validity message
    # @param required_validity_message [String, nil] custom required validity message
    # @param system_arguments [Hash] additional HTML attributes
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def initialize(
      title_text: nil,
      label_text: nil,
      label: nil,
      size: DEFAULT_SIZE,
      disabled: false,
      read_only: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      hide_label: false,
      required: false,
      open: false,
      value: nil,
      name: nil,
      aria_label: nil,
      direction: DEFAULT_DIRECTION,
      autoalign: false,
      type: '',
      toggle_label_closed: nil,
      toggle_label_open: nil,
      validity_message: nil,
      required_validity_message: nil,
      **system_arguments
    )
      # Support both title_text and label_text (label_text is deprecated but kept for backwards compatibility)
      @title_text = title_text || label_text || 'Label'
      @label_text = @title_text # Keep for backwards compatibility
      @label = label || 'Choose item'
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @read_only = read_only
      @hide_label = hide_label
      @required = required
      @open = open
      @value = value
      @name = name
      @aria_label = aria_label
      @direction = validate_argument(:direction, direction, DIRECTIONS, DEFAULT_DIRECTION)
      @autoalign = autoalign
      @type = type
      @toggle_label_closed = toggle_label_closed
      @toggle_label_open = toggle_label_open
      @validity_message = validity_message
      @required_validity_message = required_validity_message
      @system_arguments = system_arguments
      @menu_id = "dropdown-menu-#{SecureRandom.hex(4)}"
      @label_id = "dropdown-label-#{SecureRandom.hex(4)}"
      @trigger_id = "dropdown-trigger-#{SecureRandom.hex(4)}"
      initialize_form_field(invalid: invalid, invalid_text: invalid_text, warn: warn,
                            warn_text: warn_text, helper_text: helper_text)
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # @return [ItemComponent, nil] the currently selected item
    def selected_item
      # First check if value is provided and find by value
      if @value.present?
        items.find { |item| item.value == @value }
      else
        # Fall back to finding selected item
        items.find(&:selected)
      end
    end

    # @return [String] text shown in the trigger button
    def display_text
      selected_item&.text || @label
    end

    # @return [Integer] count of selected items
    def selected_items_count
      selected_item ? 1 : 0
    end

    # @return [String] aria-label for the trigger based on state
    def trigger_aria_label
      if @toggle_label_closed.present? && @toggle_label_open.present?
        @open ? @toggle_label_open : @toggle_label_closed
      elsif @aria_label.present?
        @aria_label
      end
    end

    # @return [String, nil] ID of the currently highlighted item for aria-activedescendant
    def active_descendant_id
      # This will be managed by Stimulus controller
      nil
    end

    private

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def css_classes
      classes = ['cds--dropdown', "cds--dropdown--#{@size}", 'cds--list-box', "cds--list-box--#{@size}"]

      # State modifiers
      classes << 'cds--dropdown--invalid' if @invalid
      classes << 'cds--dropdown--warning' if @warn
      classes << 'cds--dropdown--disabled' if @disabled
      classes << 'cds--list-box--disabled' if @disabled
      classes << 'cds--list-box--expanded' if @open
      classes << 'cds--dropdown--selected' if selected_items_count.positive?

      # Type variants
      if @type == 'inline'
        classes << 'cds--dropdown--inline'
        classes << 'cds--list-box--inline'
      end

      # Autoalign
      classes << 'cds--autoalign' if @autoalign

      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def wrapper_classes
      classes = ['cds--dropdown__wrapper', 'cds--list-box__wrapper']
      # Add decorator class for AI label support (when AI label slot is added in future)
      # classes << 'cds--list-box__wrapper--decorator' if ai_label.present?
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.except(:class).dup
      attrs[:class] = css_classes
      attrs['data-controller'] = 'carbon--dropdown'
      attrs['data-carbon--dropdown-read-only-value'] = @read_only.to_s
      attrs['data-carbon--dropdown-direction-value'] = @direction.to_s
      attrs
    end

    def trigger_attributes
      attrs = base_trigger_attributes
      apply_trigger_aria_labeling(attrs)

      # aria-activedescendant will be managed by Stimulus
      attrs['data-carbon--dropdown-target'] = 'trigger'
      attrs['data-action'] = 'click->carbon--dropdown#toggle keydown->carbon--dropdown#handleTriggerKeydown'
      attrs[:disabled] = true if @disabled
      if @required
        attrs[:required] = true
        attrs['aria-required'] = 'true'
      end

      attrs
    end

    def base_trigger_attributes
      {
        id: @trigger_id,
        type: 'button',
        class: 'cds--list-box__field',
        role: 'combobox',
        'aria-expanded' => @open.to_s,
        'aria-haspopup' => 'listbox',
        'aria-controls' => @menu_id,
        tabindex: '0'
      }
    end

    def apply_trigger_aria_labeling(attrs)
      if trigger_aria_label.present?
        attrs['aria-label'] = trigger_aria_label
      elsif !@hide_label
        attrs['aria-labelledby'] = @label_id
      end
    end

    def menu_attributes
      attrs = {}
      attrs[:id] = @menu_id
      attrs[:class] = 'cds--list-box__menu'
      attrs[:role] = 'listbox'
      attrs[:tabindex] = '-1'
      attrs['data-carbon--dropdown-target'] = 'menu'

      # ARIA labeling for menu
      if @aria_label.present?
        attrs['aria-label'] = @aria_label
      elsif !@hide_label
        attrs['aria-labelledby'] = @label_id
      end

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

      # Check if this item is selected based on parent's value or own selected state
      # @param parent_value [String, nil] the value from the parent dropdown
      # @return [Boolean]
      def selected_for_value?(parent_value = nil)
        if parent_value.present?
          @value == parent_value
        else
          @selected
        end
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
