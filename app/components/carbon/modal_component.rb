# frozen_string_literal: true

module Carbon
  class ModalComponent < BaseComponent
    SIZES = %i[xs sm md lg].freeze

    DEFAULT_SIZE = :md

    renders_one :header, 'HeaderComponent'
    renders_one :body, 'BodyComponent'
    renders_one :footer, 'FooterComponent'

    attr_reader :size, :danger, :open, :prevent_close_on_click_outside

    def initialize(
      open: false,
      size: DEFAULT_SIZE,
      danger: false,
      prevent_close_on_click_outside: false,
      aria_label: nil,
      **system_arguments
    )
      @open = open
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @danger = danger
      @prevent_close_on_click_outside = prevent_close_on_click_outside
      @aria_label = aria_label
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
      attrs
    end

    def container_attributes
      attrs = {}
      attrs[:class] = container_classes
      attrs[:role] = 'dialog'
      attrs[:'aria-modal'] = 'true'
      attrs[:'aria-label'] = @aria_label if @aria_label
      attrs[:'data-carbon--modal-target'] = 'container'
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    class HeaderComponent < BaseComponent
      attr_reader :title, :subtitle, :label

      def initialize(title:, subtitle: nil, label: nil, **system_arguments)
        @title = title
        @subtitle = subtitle
        @label = label
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
                             'aria-label': 'Close',
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

    class BodyComponent < BaseComponent
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        body_classes = ['cds--modal-content']
        body_classes << @system_arguments.delete(:class) if @system_arguments[:class]
        content_tag(:div, content, class: class_names(body_classes), **@system_arguments)
      end
    end

    class FooterComponent < BaseComponent
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
