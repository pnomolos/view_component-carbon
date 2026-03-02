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
    KINDS = %i[primary secondary tertiary ghost].freeze
    DEFAULT_KIND = :primary

    renders_many :items, lambda { |**kwargs|
      ItemComponent.new(size: @size, **kwargs)
    }

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
    # @return [String, nil] name for form submission
    attr_reader :name
    # @return [Integer, nil] maximum file size in bytes
    attr_reader :max_file_size

    # @param label_title [String] title for the uploader
    # @param label_description [String, nil] description text
    # @param button_label [String] label on the upload button
    # @param accept [Array<String>, nil] accepted file types
    # @param multiple [Boolean] allows multiple file selection
    # @param disabled [Boolean] disables the uploader
    # @param size [Symbol] button size (:sm, :md, :lg)
    # @param kind [Symbol] button kind (:primary, :secondary, :tertiary, :ghost)
    # @param drop_container [Boolean] renders as a drop container
    # @param id [String, nil] unique element ID
    # @param name [String, nil] name for form submission
    # @param max_file_size [Integer, nil] maximum file size in bytes
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
      name: nil,
      max_file_size: nil,
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
      @name = name
      @max_file_size = max_file_size
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
      classes = ['cds--btn', "cds--btn--#{@kind}", "cds--btn--#{@size}"]
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
        name: @name,
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
      data['carbon--file-uploader-max-file-size-value'] = @max_file_size if @max_file_size
      data
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # Renders a single file item within a Carbon File Uploader.
    #
    # @example Basic usage
    #   render Carbon::FileUploaderComponent.new do |uploader|
    #     uploader.with_item(name: "report.pdf")
    #   end
    #
    # @example With error state
    #   render Carbon::FileUploaderComponent.new do |uploader|
    #     uploader.with_item(name: "large.zip", invalid: true, error_subject: "File too large")
    #   end
    class ItemComponent < BaseComponent
      STATES = %i[uploading edit complete].freeze
      # NOTE: Upstream Carbon defaults to :uploading, but :edit is more practical
      # for server-rendered items since they are typically already uploaded and
      # the user needs the ability to remove them rather than see a loading state.
      DEFAULT_STATE = :edit
      SIZES = %i[sm md lg].freeze
      DEFAULT_SIZE = :md
      DEFAULT_ICON_DESCRIPTIONS = {
        uploading: 'Loading',
        edit: 'Remove file',
        complete: 'Upload complete'
      }.freeze

      # @return [String] file name
      attr_reader :name
      # @return [Symbol] file state (:uploading, :edit, :complete)
      attr_reader :state
      # @return [Boolean] whether the file is in an invalid state
      attr_reader :invalid
      # @return [String, nil] error title text
      attr_reader :error_subject
      # @return [String, nil] error detail text
      attr_reader :error_body
      # @return [String] accessible label for the status icon
      attr_reader :icon_description
      # @return [Symbol] item size (:sm, :md, :lg)
      attr_reader :size
      # @return [String] unique identifier for this file item
      attr_reader :uuid

      # @param name [String] file name (required)
      # @param state [Symbol] file state (:uploading, :edit, :complete)
      # @param invalid [Boolean] marks file as invalid
      # @param error_subject [String, nil] error title text
      # @param error_body [String, nil] error detail text
      # @param icon_description [String, nil] accessible label for the status icon
      # @param size [Symbol] item size (:sm, :md, :lg)
      # @param uuid [String, nil] unique identifier (auto-generated if nil)
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(
        name:,
        state: DEFAULT_STATE,
        invalid: false,
        error_subject: nil,
        error_body: nil,
        icon_description: nil,
        size: DEFAULT_SIZE,
        uuid: nil,
        **system_arguments
      )
        @name = name
        @state = validate_state(state)
        @invalid = invalid
        @error_subject = error_subject
        @error_body = error_body
        @size = validate_size(size)
        @uuid = uuid || "file-#{SecureRandom.hex(4)}"
        @icon_description = icon_description || DEFAULT_ICON_DESCRIPTIONS[@state]
        @system_arguments = system_arguments
      end

      # @return [String] CSS class string for the file item wrapper
      def item_classes
        classes = ['cds--file__selected-file']
        classes << "cds--file__selected-file--#{@size}" if @size != :lg
        classes << 'cds--file__selected-file--invalid' if @invalid
        class_names(*classes)
      end

      private

      def validate_state(value)
        value = value.to_sym if value.is_a?(String)
        return value if STATES.include?(value)

        raise ArgumentError,
              "Invalid state: #{value.inspect}. Must be one of: #{STATES.map(&:inspect).join(', ')}"
      end

      def validate_size(value)
        value = value.to_sym if value.is_a?(String)
        return value if SIZES.include?(value)

        raise ArgumentError,
              "Invalid size: #{value.inspect}. Must be one of: #{SIZES.map(&:inspect).join(', ')}"
      end
    end
  end
end
