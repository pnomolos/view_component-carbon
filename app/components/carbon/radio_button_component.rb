# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Radio Button.
  #
  # @example Basic usage
  #   render Carbon::RadioButtonComponent.new(name: "color", value: "red", label_text: "Red")
  #
  # @see https://carbondesignsystem.com/components/radio-button/usage/
  class RadioButtonComponent < BaseComponent
    # @return [String] input name attribute
    attr_reader :name
    # @return [String] input value
    attr_reader :value
    # @return [Boolean] whether checked
    attr_reader :checked
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [String] label text
    attr_reader :label_text
    # @return [String] unique element ID
    attr_reader :id

    # @param name [String] input name attribute
    # @param value [String] input value
    # @param label_text [String] label text
    # @param checked [Boolean] initial checked state
    # @param disabled [Boolean] disables the radio button
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      name:,
      value:,
      label_text:,
      checked: false,
      disabled: false,
      id: nil,
      **system_arguments
    )
      @name = name
      @value = value
      @label_text = label_text
      @checked = checked
      @disabled = disabled
      @id = id || "radio-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string for the wrapper
    def wrapper_classes
      classes = ['cds--radio-button-wrapper']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the radio input
    def radio_attributes
      attrs = {
        type: 'radio',
        class: 'cds--radio-button',
        id: @id,
        name: @name,
        value: @value
      }
      attrs[:checked] = '' if @checked
      attrs[:disabled] = '' if @disabled
      attrs.merge!(@system_arguments)
      attrs.compact
    end
  end
end
