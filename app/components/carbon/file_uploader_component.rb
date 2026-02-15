# frozen_string_literal: true

module Carbon
  class FileUploaderComponent < BaseComponent
    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md
    KINDS = %i[primary tertiary].freeze
    DEFAULT_KIND = :primary

    attr_reader :label_title, :label_description, :button_label, :accept, :multiple,
                :disabled, :size, :kind, :drop_container, :id

    def initialize(
      label_title: 'Upload files',
      label_description: nil,
      button_label: 'Add file',
      accept: nil,
      multiple: false,
      disabled: false,
      size: DEFAULT_SIZE,
      kind: DEFAULT_KIND,
      drop_container: false,
      id: nil,
      **system_arguments
    )
      @label_title = label_title
      @label_description = label_description
      @button_label = button_label
      @accept = accept
      @multiple = multiple
      @disabled = disabled
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @kind = validate_argument(:kind, kind, KINDS, DEFAULT_KIND)
      @drop_container = drop_container
      @id = id || "file-uploader-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def button_classes
      classes = ['cds--btn', "cds--btn--#{@kind}"]
      classes << "cds--btn--#{@size}" unless @size == :lg
      class_names(*classes)
    end

    def drop_container_classes
      classes = ['cds--file__drop-container', 'cds--file-browse-btn']
      classes << 'cds--file-browse-btn--disabled' if @disabled
      class_names(*classes)
    end

    def description_classes
      classes = ['cds--label-description']
      classes << 'cds--label-description--disabled' if @disabled
      class_names(*classes)
    end

    def accept_string
      return nil unless @accept

      @accept.join(',')
    end

    def input_attributes
      attrs = {
        type: 'file',
        class: 'cds--visually-hidden',
        id: @id,
        accept: accept_string,
        tabindex: '-1'
      }
      attrs[:multiple] = '' if @multiple
      attrs[:disabled] = '' if @disabled
      attrs[:'data-action'] = 'change->carbon--file-uploader#handleChange'
      attrs[:'data-carbon--file-uploader-target'] = 'input'
      attrs.merge!(@system_arguments)
      attrs.compact
    end

    def controller_data
      data = {
        controller: 'carbon--file-uploader',
        'carbon--file-uploader-size-value': @size.to_s
      }
      data['carbon--file-uploader-drop-container-value'] = true if @drop_container
      data
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
