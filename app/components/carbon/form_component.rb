# frozen_string_literal: true

module Carbon
  class FormComponent < BaseComponent
    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    def form_classes
      classes = ['cds--form']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def form_attributes
      attrs = { class: form_classes }
      attrs.merge!(@system_arguments)
      attrs
    end
  end
end
