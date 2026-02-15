# frozen_string_literal: true

module Carbon
  class RadioButtonComponent < BaseComponent
    attr_reader :name, :value, :checked, :disabled, :label_text, :id

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

    def wrapper_classes
      classes = ['cds--radio-button-wrapper']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

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
