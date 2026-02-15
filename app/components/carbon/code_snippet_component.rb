# frozen_string_literal: true

module Carbon
  class CodeSnippetComponent < BaseComponent
    TYPES = %i[single multi inline].freeze

    DEFAULT_TYPE = :single

    attr_reader :type, :code, :show_more_text, :show_less_text, :max_collapsed_lines, :hide_copy_button

    def initialize(
      type: DEFAULT_TYPE,
      code: nil,
      show_more_text: 'Show more',
      show_less_text: 'Show less',
      max_collapsed_lines: 15,
      hide_copy_button: false,
      **system_arguments
    )
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @code = code
      @show_more_text = show_more_text
      @show_less_text = show_less_text
      @max_collapsed_lines = max_collapsed_lines
      @hide_copy_button = hide_copy_button
      @system_arguments = system_arguments
    end

    def before_render
      @code = content if @code.nil? && content.present?
    end

    def tag_name
      @type == :inline ? :span : :div
    end

    def css_classes
      classes = ['cds--snippet', "cds--snippet--#{@type}"]
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--code-snippet'
      attrs
    end

    def copy_icon
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor">' \
      '<path d="M28 10v18H10V10h18m0-2H10a2 2 0 0 0-2 2v18a2 2 0 0 0 2 2h18a2 2 0 0 0 2-2V10a2 2 0 0 0-2-2z"/>' \
      '<path d="M4 18H2V4a2 2 0 0 1 2-2h14v2H4z"/></svg>'.html_safe
    end

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
