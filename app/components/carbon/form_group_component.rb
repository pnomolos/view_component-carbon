# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Form Group (fieldset).
  #
  # @example Basic usage
  #   render Carbon::FormGroupComponent.new(legend_text: "Settings") { "fields" }
  #
  # @see https://carbondesignsystem.com/components/form/usage/
  class FormGroupComponent < BaseComponent
    # @return [String, nil] legend text
    attr_reader :legend_text
    # @return [Boolean] whether to show a message
    attr_reader :message
    # @return [String, nil] message text
    attr_reader :message_text
    # @return [Boolean] whether in invalid state
    attr_reader :invalid

    # @param legend_text [String, nil] fieldset legend text
    # @param message [Boolean] shows a message below the group
    # @param message_text [String, nil] message text content
    # @param invalid [Boolean] marks the group as invalid
    # @param system_arguments [Hash] additional HTML attributes
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

    # @return [String] CSS class string for the fieldset
    def fieldset_classes
      classes = ['cds--fieldset']
      classes << 'cds--fieldset--invalid' if @invalid
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the fieldset
    def fieldset_attributes
      attrs = { class: fieldset_classes }
      attrs[:'data-invalid'] = '' if @invalid
      attrs.merge!(@system_arguments)
      attrs
    end

    # @return [String] unique legend element ID
    def legend_id
      @legend_id ||= "legend-#{SecureRandom.hex(4)}"
    end
  end
end
