# frozen_string_literal: true

module Carbon
  class FormGroupComponent < BaseComponent
    attr_reader :legend_text, :message, :message_text, :invalid

    def initialize(
      legend_text: nil,
      message: false,
      message_text: nil,
      invalid: false,
      **system_arguments
    )
      @legend_text = legend_text
      @message = message
      @message_text = message_text
      @invalid = invalid
      @system_arguments = system_arguments
    end

    def fieldset_classes
      classes = ['cds--fieldset']
      classes << 'cds--fieldset--invalid' if @invalid
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def fieldset_attributes
      attrs = { class: fieldset_classes }
      attrs[:'data-invalid'] = '' if @invalid
      attrs.merge!(@system_arguments)
      attrs
    end

    def legend_id
      @legend_id ||= "legend-#{SecureRandom.hex(4)}"
    end
  end
end
