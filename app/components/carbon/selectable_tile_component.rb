# frozen_string_literal: true

module Carbon
  class SelectableTileComponent < Carbon::BaseComponent
    attr_reader :selected, :disabled, :name, :value, :input_id

    def initialize(selected: false, disabled: false, name: nil, value: nil, id: nil, **system_arguments)
      @selected = selected
      @disabled = disabled
      @name = name
      @value = value
      @input_id = id || "selectable-tile-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    private

    def label_css_classes
      classes = %w[cds--tile cds--tile--selectable]
      classes << 'cds--tile--is-selected' if @selected
      classes << 'cds--tile--disabled' if @disabled
      class_names(classes)
    end

    def wrapper_html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = nil
      attrs['data-controller'] = 'carbon--selectable-tile'
      attrs
    end

    def checkmark_svg
      '<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">' \
        '<path d="M8 1C4.1 1 1 4.1 1 8s3.1 7 7 7 7-3.1 7-7-3.1-7-7-7zm3.7 5.3l-4.2 4.2c-.2.2-.5.2-.7 ' \
        '0L4.3 8c-.2-.2-.2-.5 0-.7.2-.2.5-.2.7 0L7.1 9.4l3.8-3.8c.2-.2.5-.2.7 0 .2.2.2.5 0 .7z" ' \
        'fill="currentColor"/></svg>'
    end
  end
end
