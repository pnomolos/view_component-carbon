# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Code Snippet.
  #
  # @example Basic usage
  #   render Carbon::CodeSnippetComponent.new(type: :single, code: "npm install")
  #
  # @see https://carbondesignsystem.com/components/code-snippet/usage/
  class CodeSnippetComponent < BaseComponent
    TYPES = %i[single multi inline].freeze

    DEFAULT_TYPE = :single

    # @return [Symbol] snippet type
    attr_reader :type
    # @return [String, nil] code content
    attr_reader :code
    # @return [String] text for the "show more" toggle
    attr_reader :show_more_text
    # @return [String] text for the "show less" toggle
    attr_reader :show_less_text
    # @return [Integer] max lines when collapsed
    attr_reader :max_collapsed_lines
    # @return [Boolean] whether to hide the copy button
    attr_reader :hide_copy_button
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [Boolean] whether to wrap text
    attr_reader :wrap_text

    # @param type [Symbol] snippet type (:single, :multi, :inline)
    # @param code [String, nil] code content to display
    # @param show_more_text [String] label for show more button
    # @param show_less_text [String] label for show less button
    # @param max_collapsed_lines [Integer] max visible lines when collapsed
    # @param hide_copy_button [Boolean] hides the copy button
    # @param disabled [Boolean] disables the copy button and applies disabled styling
    # @param wrap_text [Boolean] allows code text to wrap instead of scrolling
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      type: DEFAULT_TYPE,
      code: nil,
      show_more_text: 'Show more',
      show_less_text: 'Show less',
      max_collapsed_lines: 15,
      hide_copy_button: false,
      disabled: false,
      wrap_text: false,
      **system_arguments
    )
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @code = code
      @show_more_text = show_more_text
      @show_less_text = show_less_text
      @max_collapsed_lines = max_collapsed_lines
      @hide_copy_button = hide_copy_button
      @disabled = disabled
      @wrap_text = wrap_text
      @system_arguments = system_arguments
    end

    # Sets code from block content if not provided via parameter.
    # @return [void]
    def before_render
      @code = content if @code.nil? && content.present?
    end

    # @return [Symbol] HTML tag (:span for inline, :div otherwise)
    def tag_name
      @type == :inline ? :span : :div
    end

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--snippet', "cds--snippet--#{@type}"]
      classes << 'cds--snippet--disabled' if @disabled
      classes << 'cds--snippet--wraptext' if @wrap_text
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the snippet element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--code-snippet'
      attrs
    end

    # @return [String] SVG markup for the copy icon
    def copy_icon
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor">' \
      '<path d="M28 10v18H10V10h18m0-2H10a2 2 0 0 0-2 2v18a2 2 0 0 0 2 2h18a2 2 0 0 0 2-2V10a2 2 0 0 0-2-2z"/>' \
      '<path d="M4 18H2V4a2 2 0 0 1 2-2h14v2H4z"/></svg>'.html_safe
    end

    # @return [String] SVG markup for the chevron icon
    def chevron_icon
      '<svg class="cds--icon-chevron--down cds--snippet__icon" xmlns="http://www.w3.org/2000/svg" ' \
      'viewBox="0 0 16 16" width="16" height="16" fill="currentColor">' \
      '<path d="M8 11L3 6 3.7 5.3 8 9.6 12.3 5.3 13 6z"/></svg>'.html_safe
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
