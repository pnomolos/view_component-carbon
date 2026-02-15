# frozen_string_literal: true

module Carbon
  class RadioTileComponent < Carbon::BaseComponent
    attr_reader :value, :checked, :disabled, :input_id, :name

    def initialize(value:, checked: false, disabled: false, id: nil, name: nil, **system_arguments)
      @value = value
      @checked = checked
      @disabled = disabled
      @input_id = id || "radio-tile-#{SecureRandom.hex(4)}"
      @name = name
      @system_arguments = system_arguments
    end

    private

    def label_css_classes
      classes = %w[cds--tile cds--tile--selectable]
      classes << 'cds--tile--is-selected' if @checked
      classes << 'cds--tile--disabled' if @disabled
      class_names(classes)
    end

    def checkmark_svg
      '<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">' \
        '<path d="M8 1C4.1 1 1 4.1 1 8s3.1 7 7 7 7-3.1 7-7-3.1-7-7-7zm3.7 5.3l-4.2 4.2c-.2.2-.5.2-.7 ' \
        '0L4.3 8c-.2-.2-.2-.5 0-.7.2-.2.5-.2.7 0L7.1 9.4l3.8-3.8c.2-.2.5-.2.7 0 .2.2.2.5 0 .7z" ' \
        'fill="currentColor"/></svg>'
    end
  end
end
