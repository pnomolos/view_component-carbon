# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Link.
  #
  # @example Basic usage
  #   render Carbon::LinkComponent.new(href: "/page") { "Go to page" }
  #
  # @see https://carbondesignsystem.com/components/link/usage/
  class LinkComponent < BaseComponent
    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :lg

    SIZE_CSS = {
      sm: 'sm',
      md: 'md',
      lg: 'lg'
    }.freeze

    renders_one :icon

    # @return [String, nil] link URL
    attr_reader :href
    # @return [Symbol] link size
    attr_reader :size
    # @return [Boolean] whether the link is disabled
    attr_reader :disabled
    # @return [Boolean] whether the link is inline
    attr_reader :inline
    # @return [Boolean] whether to show visited styling
    attr_reader :visited

    # @param href [String, nil] link URL
    # @param size [Symbol] link size (:sm, :md, :lg)
    # @param disabled [Boolean] disables the link
    # @param inline [Boolean] renders inline link style
    # @param visited [Boolean] shows visited state
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(href: nil, size: DEFAULT_SIZE, disabled: false, inline: false, visited: false, **system_arguments)
      @href = href
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @inline = inline
      @visited = visited
      @system_arguments = system_arguments
    end

    # @return [Symbol] HTML tag to render
    def tag_name
      @disabled ? :span : :a
    end

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--link', "cds--link--#{SIZE_CSS[@size]}"]
      classes << 'cds--link--disabled' if @disabled
      classes << 'cds--link--inline' if @inline
      classes << 'cds--link--visited' if @visited
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the link element
    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:href] = @href unless @disabled
      if @disabled
        attrs[:role] = 'button'
        attrs[:aria] = { disabled: true }.merge(attrs.fetch(:aria, {}))
      end
      attrs
    end

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
