# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Search input.
  #
  # @example Basic usage
  #   render Carbon::SearchComponent.new(label_text: "Search", placeholder: "Search...")
  #
  # @see https://carbondesignsystem.com/components/search/usage/
  class SearchComponent < BaseComponent
    SIZES = %i[sm md lg].freeze

    DEFAULT_SIZE = :md

    # @return [Symbol] input size
    attr_reader :size
    # @return [String] placeholder text
    attr_reader :placeholder
    # @return [String] label text
    attr_reader :label_text
    # @return [String, nil] current value
    attr_reader :value
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether expandable
    attr_reader :expandable
    # @return [String] unique element ID
    attr_reader :id
    # @return [String] aria-label text for close button
    attr_reader :close_button_label_text
    # @return [String, nil] input name attribute
    attr_reader :name
    # @return [String] autocomplete attribute value
    attr_reader :autocomplete

    # @param size [Symbol] input size (:sm, :md, :lg)
    # @param placeholder [String] placeholder text
    # @param label_text [String] label text
    # @param value [String, nil] initial value
    # @param disabled [Boolean] disables the input
    # @param expandable [Boolean] enables expandable mode
    # @param close_button_label_text [String] aria-label for close button
    # @param name [String, nil] input name attribute
    # @param autocomplete [String] autocomplete attribute value
    # @param id [String, nil] unique element ID
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      size: DEFAULT_SIZE,
      placeholder: 'Search',
      label_text: 'Search',
      value: nil,
      disabled: false,
      expandable: false,
      close_button_label_text: 'Clear search input',
      name: nil,
      autocomplete: 'off',
      id: nil,
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @placeholder = placeholder
      @label_text = label_text
      @value = value
      @disabled = disabled
      @expandable = expandable
      @close_button_label_text = close_button_label_text
      @name = name
      @autocomplete = autocomplete
      @id = id || "search-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--search', "cds--search--#{@size}"]
      classes << 'cds--search--expandable' if @expandable
      classes << 'cds--search--disabled' if @disabled
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the search element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:role] = 'search'
      attrs[:aria] = { label: @placeholder }.merge(attrs.fetch(:aria, {}))
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--search'
      attrs
    end

    # @return [String] SVG markup for the search icon
    def search_icon
      '<svg class="cds--search-magnifier-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" ' \
      'width="16" height="16" fill="currentColor">' \
      '<path d="M29 27.586l-7.552-7.552a11.018 11.018 0 1 0-1.414 1.414L27.586 29zM4 13a9 9 0 1 1 9 9 9.01 9.01 0 ' \
      '0 1-9-9z"/></svg>'.html_safe
    end

    # @return [String] SVG markup for the close icon
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
