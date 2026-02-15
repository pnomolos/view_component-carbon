# frozen_string_literal: true

module Carbon
  class SearchComponent < BaseComponent
    SIZES = %i[sm md lg].freeze

    DEFAULT_SIZE = :md

    attr_reader :size, :placeholder, :label_text, :value, :disabled, :expandable, :id

    def initialize(
      size: DEFAULT_SIZE,
      placeholder: 'Search',
      label_text: 'Search',
      value: nil,
      disabled: false,
      expandable: false,
      id: nil,
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @placeholder = placeholder
      @label_text = label_text
      @value = value
      @disabled = disabled
      @expandable = expandable
      @id = id || "search-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    def css_classes
      classes = ['cds--search', "cds--search--#{@size}"]
      classes << 'cds--search--expandable' if @expandable
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'search'
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--search'
      attrs
    end

    def search_icon
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor">' \
      '<path d="M29 27.586l-7.552-7.552a11.018 11.018 0 1 0-1.414 1.414L27.586 29zM4 13a9 9 0 1 1 9 9 9.01 9.01 0 ' \
      '0 1-9-9z"/></svg>'.html_safe
    end

    def close_icon
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor">' \
      '<path d="M24 9.4L22.6 8 16 14.6 9.4 8 8 9.4l6.6 6.6L8 22.6 9.4 24l6.6-6.6 6.6 6.6 1.4-1.4-6.6-6.6L24 9.4z"/>' \
      '</svg>'.html_safe
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
