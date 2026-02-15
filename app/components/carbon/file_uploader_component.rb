# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System File Uploader.
  #
  # @example Basic usage
  #   render Carbon::FileUploaderComponent.new(label_title: "Upload")
  #
  # @see https://carbondesignsystem.com/components/file-uploader/usage/
  class FileUploaderComponent < BaseComponent
    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md
    KINDS = %i[primary tertiary].freeze
    DEFAULT_KIND = :primary

    # @return [String] title for the uploader
    attr_reader :label_title
    # @return [String, nil] description text
    attr_reader :label_description
    # @return [String] label on the upload button
    attr_reader :button_label
    # @return [Array<String>, nil] accepted file types
    attr_reader :accept
    # @return [Boolean] whether multiple files can be selected
    attr_reader :multiple
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Symbol] button size
    attr_reader :size
    # @return [Symbol] button kind
    attr_reader :kind
    # @return [Boolean] whether to render as a drop container
    attr_reader :drop_container
    # @return [String] unique element ID
    attr_reader :id

    # @param label_title [String] title for the uploader
    # @param label_description [String, nil] description text
    # @param button_label [String] label on the upload button
    # @param accept [Array<String>, nil] accepted file types
    # @param multiple [Boolean] allows multiple file selection
    # @param disabled [Boolean] disables the uploader
    # @param size [Symbol] button size (:sm, :md, :lg)
    # @param kind [Symbol] button kind (:primary, :tertiary)
    # @param drop_container [Boolean] renders as a drop container
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
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

    # @return [String] CSS class string for the wrapper
    def wrapper_classes
      classes = ['cds--form-item']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [String] CSS class string for the upload button
    def button_classes
      classes = ['cds--btn', "cds--btn--#{@kind}"]
      classes << "cds--btn--#{@size}" unless @size == :lg
      class_names(*classes)
    end

    # @return [String] CSS class string for the drop container
    def drop_container_classes
      classes = ['cds--file__drop-container', 'cds--file-browse-btn']
      classes << 'cds--file-browse-btn--disabled' if @disabled
      class_names(*classes)
    end

    # @return [String] CSS class string for the description
    def description_classes
      classes = ['cds--label-description']
      classes << 'cds--label-description--disabled' if @disabled
      class_names(*classes)
    end

    # @return [String, nil] comma-separated accept string
    def accept_string
      return nil unless @accept

      @accept.join(',')
    end

    # @return [Hash] HTML attributes for the file input
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

    # @return [Hash] Stimulus controller data attributes
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
