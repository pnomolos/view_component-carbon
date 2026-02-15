# frozen_string_literal: true

module Carbon
  class LinkComponent < BaseComponent
    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :lg

    SIZE_CSS = {
      sm: 'sm',
      md: 'md',
      lg: 'lg'
    }.freeze

    renders_one :icon

    attr_reader :href, :size, :disabled, :inline, :visited

    def initialize(href: nil, size: DEFAULT_SIZE, disabled: false, inline: false, visited: false, **system_arguments)
      @href = href
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @disabled = disabled
      @inline = inline
      @visited = visited
      @system_arguments = system_arguments
    end

    def css_classes
      classes = ['cds--link', "cds--link--#{SIZE_CSS[@size]}"]
      classes << 'cds--link--disabled' if @disabled
      classes << 'cds--link--inline' if @inline
      classes << 'cds--link--visited' if @visited
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:href] = @href unless @disabled
      attrs[:aria] = { disabled: true }.merge(attrs.fetch(:aria, {})) if @disabled
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
