# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Modal dialog.
  #
  # @example Basic usage
  #   render Carbon::ModalComponent.new(open: true) do |modal|
  #     modal.with_header(title: "Confirm")
  #     modal.with_body { "Are you sure?" }
  #   end
  #
  # @see https://carbondesignsystem.com/components/modal/usage/
  class ModalComponent < BaseComponent
    SIZES = %i[xs sm md lg].freeze

    DEFAULT_SIZE = :md

    renders_one :header, 'HeaderComponent'
    renders_one :body, 'BodyComponent'
    renders_one :footer, 'FooterComponent'

    # @return [Symbol] modal size
    attr_reader :size
    # @return [Boolean] whether this is a danger modal
    attr_reader :danger
    # @return [Boolean] whether the modal is open
    attr_reader :open
    # @return [Boolean] prevents closing when clicking outside
    attr_reader :prevent_close_on_click_outside
    # @return [String] accessible label for close button
    attr_reader :close_button_label

    # @param open [Boolean] initial open state
    # @param size [Symbol] modal size (:xs, :sm, :md, :lg)
    # @param danger [Boolean] applies danger styling
    # @param alert [Boolean] changes role to "alert" for urgent messages
    # @param prevent_close_on_click_outside [Boolean] prevents closing on overlay click
    # @param prevent_close [Boolean] prevents closing via Escape or backdrop click
    # @param should_submit_on_enter [Boolean] pressing Enter clicks primary button
    # @param full_width [Boolean] makes modal container full width
    # @param has_scrolling_content [Boolean] shows overflow indicator
    # @param container_class [String] additional classes for modal container
    # @param aria_label [String, nil] accessible label (computed from header if not provided)
    # @param close_button_label [String] accessible label for close button
    # @param loading_status [String] loading state: inactive, active, finished, error
    # @param loading_description [String] loading message text
    # @param loading_icon_description [String] loading icon accessible label
    # @param loading_success_delay [Integer] delay in ms before hiding success state
    # @param system_arguments [Hash] additional HTML attributes
    def initialize( # rubocop:disable Metrics/AbcSize

      open: false,
      size: DEFAULT_SIZE,
      danger: false,
      alert: false,
      prevent_close_on_click_outside: false,
      prevent_close: false,
      should_submit_on_enter: false,
      full_width: false,
      has_scrolling_content: false,
      container_class: '',
      aria_label: nil,
      close_button_label: 'Close',
      loading_status: 'inactive',
      loading_description: '',
      loading_icon_description: 'Loading',
      loading_success_delay: 1500,
      **system_arguments
    )
      @open = open
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @danger = danger
      @alert = alert
      @prevent_close_on_click_outside = prevent_close_on_click_outside
      @prevent_close = prevent_close
      @should_submit_on_enter = should_submit_on_enter
      @full_width = full_width
      @has_scrolling_content = has_scrolling_content
      @container_class = container_class
      @aria_label = aria_label
      @close_button_label = close_button_label
      @loading_status = loading_status
      @loading_description = loading_description
      @loading_icon_description = loading_icon_description
      @loading_success_delay = loading_success_delay
      @system_arguments = system_arguments
    end

    private

    def modal_id
      @modal_id ||= "modal-#{SecureRandom.hex(8)}"
    end

    def css_classes
      classes = ['cds--modal']
      classes << 'cds--modal--open' if @open
      classes << 'cds--modal--danger' if @danger
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(classes)
    end

    def container_classes
      classes = ['cds--modal-container']
      classes << "cds--modal-container--#{@size}" if @size != DEFAULT_SIZE
      classes << 'cds--modal-container--full-width' if @full_width
      classes.concat(@container_class.split) if @container_class.present?
      class_names(classes)
    end

    def html_attributes # rubocop:disable Metrics/AbcSize
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'presentation'
      attrs[:id] = modal_id
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--modal'
      attrs[:data][:'carbon--modal-open-value'] = @open.to_s
      attrs[:data][:'carbon--modal-prevent-close-on-click-outside-value'] = @prevent_close_on_click_outside.to_s
      attrs[:data][:'carbon--modal-prevent-close-value'] = @prevent_close.to_s
      attrs[:data][:'carbon--modal-should-submit-on-enter-value'] = @should_submit_on_enter.to_s
      attrs[:data][:'carbon--modal-loading-status-value'] = @loading_status
      attrs[:data][:'carbon--modal-loading-description-value'] = @loading_description
      attrs[:data][:'carbon--modal-loading-icon-description-value'] = @loading_icon_description
      attrs[:data][:'carbon--modal-loading-success-delay-value'] = @loading_success_delay
      attrs
    end

    def container_attributes
      attrs = {}
      attrs[:class] = container_classes
      attrs[:role] = @alert ? 'alert' : 'dialog'
      attrs[:'aria-modal'] = 'true'
      attrs[:'aria-label'] = computed_aria_label
      attrs[:'data-carbon--modal-target'] = 'container'
      attrs
    end

    def computed_aria_label # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      # Priority: modal-label → explicit aria-label → modal-heading
      return header.label if header? && header.respond_to?(:label) && header.label.present?
      return @aria_label if @aria_label.present?
      return header.title if header? && header.respond_to?(:title) && header.title.present?

      ''
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # Modal header with title, subtitle, and close button.
    class HeaderComponent < BaseComponent
      # @return [String] modal title
      attr_reader :title
      # @return [String, nil] modal subtitle
      attr_reader :subtitle
      # @return [String, nil] modal label above the title
      attr_reader :label
      # @return [String] close button accessible label
      attr_reader :close_button_label

      # @param title [String] modal heading text
      # @param subtitle [String, nil] description text below the title
      # @param label [String, nil] label above the title
      # @param close_button_label [String] accessible label for close button
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(title:, subtitle: nil, label: nil, close_button_label: 'Close', **system_arguments)
        @title = title
        @subtitle = subtitle
        @label = label
        @close_button_label = close_button_label
        @system_arguments = system_arguments
      end

      def call
        content_tag(:div, class: 'cds--modal-header') do
          parts = []
          parts << content_tag(:p, @label, class: 'cds--modal-header__label') if @label
          parts << content_tag(:p, @title, class: 'cds--modal-header__heading')
          parts << content_tag(:p, @subtitle, class: 'cds--modal-header__description') if @subtitle
          parts << close_button_html
          safe_join(parts)
        end
      end

      private

      def close_button_html
        content_tag(:button, class: 'cds--modal-close', type: 'button',
                             'aria-label': @close_button_label,
                             'data-action': 'carbon--modal#close') do
          close_icon_svg
        end
      end

      def close_icon_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="20" height="20" viewBox="0 0 32 32" aria-hidden="true" ' \
        'class="cds--modal-close__icon">' \
        '<path d="M24 9.4L22.6 8 16 14.6 9.4 8 8 9.4 14.6 16 8 22.6 9.4 24 16 17.4 ' \
        '22.6 24 24 22.6 17.4 16 24 9.4z"></path>' \
        '</svg>'.html_safe
      end
    end

    # Modal body content area.
    class BodyComponent < BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        body_classes = ['cds--modal-content']
        body_classes << @system_arguments.delete(:class) if @system_arguments[:class]
        content_tag(:div, content, class: class_names(body_classes), **@system_arguments)
      end
    end

    # Modal footer area for action buttons.
    class FooterComponent < BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        footer_classes = ['cds--modal-footer']
        footer_classes << @system_arguments.delete(:class) if @system_arguments[:class]
        content_tag(:div, content, class: class_names(footer_classes), **@system_arguments)
      end
    end
  end
end
