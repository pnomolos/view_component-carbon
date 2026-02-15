# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Form wrapper.
  #
  # @example Basic usage
  #   render Carbon::FormComponent.new { "form fields here" }
  #
  # @see https://carbondesignsystem.com/components/form/usage/
  class FormComponent < BaseComponent
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string for the form
    def form_classes
      classes = ['cds--form']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the form element
    def form_attributes
      attrs = { class: form_classes }
      attrs.merge!(@system_arguments)
      attrs
    end
  end
end
