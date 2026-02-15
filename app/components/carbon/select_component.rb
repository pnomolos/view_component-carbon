# frozen_string_literal: true

module Carbon
  class SelectComponent < BaseComponent
    include Carbon::Concerns::FormFieldable

    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :options, 'Carbon::SelectComponent::OptionComponent'
    renders_many :option_groups, lambda { |label:, **system_arguments, &block|
      group = OptionGroupComponent.new(label: label, **system_arguments)
      block&.call(group)
      group
    }

    attr_reader :label_text, :size, :disabled, :inline, :hide_label, :name

    def initialize(
      label_text: 'Label',
      size: DEFAULT_SIZE,
      disabled: false,
      invalid: false,
      invalid_text: nil,
      warn: false,
      warn_text: nil,
      helper_text: nil,
      inline: false,
      hide_label: false,
      name: nil,
      id: nil,
      **system_arguments
    )
      @label_text = label_text
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @inline = inline
      @hide_label = hide_label
      @name = name
      @id = id || "select-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
      initialize_form_field(invalid: invalid, invalid_text: invalid_text, warn: warn,
                            warn_text: warn_text, helper_text: helper_text)
    end

    def select_id
      @id
    end

    private

    def wrapper_classes
      classes = ['cds--select']
      classes << 'cds--select--disabled' if @disabled
      classes << 'cds--select--invalid' if @invalid
      classes << 'cds--select--warning' if @warn
      classes << 'cds--select--inline' if @inline
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def label_classes
      classes = ['cds--label']
      classes << 'cds--visually-hidden' if @hide_label
      classes << 'cds--label--disabled' if @disabled
      class_names(classes)
    end

    def select_classes
      classes = ['cds--select-input']
      classes << "cds--select-input--#{@size}" if @size != DEFAULT_SIZE
      class_names(classes)
    end

    def select_attributes
      attrs = @system_arguments.except(:class).dup
      attrs[:class] = select_classes
      attrs[:id] = @id
      attrs[:name] = @name if @name
      attrs[:disabled] = '' if @disabled
      attrs['aria-invalid'] = 'true' if @invalid
      attrs['aria-describedby'] = aria_describedby_id if aria_describedby_id
      attrs
    end

    def chevron_svg
      '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
        'fill="currentColor" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true" ' \
        'class="cds--select__arrow">' \
        '<path d="M8 11L3 6 3.7 5.3 8 9.6 12.3 5.3 13 6z"></path>' \
        '</svg>'
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    class OptionComponent < BaseComponent
      attr_reader :value, :text, :selected, :disabled

      def initialize(value:, text:, selected: false, disabled: false, **system_arguments)
        @value = value
        @text = text
        @selected = selected
        @disabled = disabled
        @system_arguments = system_arguments
      end

      def call
        # Rendered by parent template
        nil
      end
    end

    class OptionGroupComponent < BaseComponent
      attr_reader :label

      renders_many :options, 'Carbon::SelectComponent::OptionComponent'

      def initialize(label:, **system_arguments)
        @label = label
        @system_arguments = system_arguments
      end

      def call
        # Rendered by parent template
        nil
      end
    end
  end
end
