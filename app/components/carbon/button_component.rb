# frozen_string_literal: true

module Carbon
  class ButtonComponent < BaseComponent
    KINDS = %i[primary secondary tertiary ghost danger danger_tertiary danger_ghost].freeze
    SIZES = %i[sm md lg xl 2xl].freeze
    TYPES = %i[button submit reset].freeze

    DEFAULT_KIND = :primary
    DEFAULT_SIZE = :lg
    DEFAULT_TYPE = :button

    # Mapping from Ruby symbol to CSS class suffix
    KIND_CSS = {
      primary: 'primary',
      secondary: 'secondary',
      tertiary: 'tertiary',
      ghost: 'ghost',
      danger: 'danger',
      danger_tertiary: 'danger--tertiary',
      danger_ghost: 'danger--ghost'
    }.freeze

    SIZE_CSS = {
      sm: 'sm',
      md: 'md',
      lg: 'lg',
      xl: 'xl',
      '2xl': '2xl'
    }.freeze

    renders_one :icon

    attr_reader :kind, :size, :disabled, :icon_only, :href, :type

    def initialize(kind: DEFAULT_KIND, size: DEFAULT_SIZE, disabled: false, icon_only: false,
                   href: nil, type: DEFAULT_TYPE, icon_description: nil, **system_arguments)
      @kind = validate_argument(:kind, kind, KINDS, DEFAULT_KIND)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @type = validate_argument(:type, type, TYPES, DEFAULT_TYPE)
      @disabled = disabled
      @icon_only = icon_only
      @href = href
      @icon_description = icon_description
      @system_arguments = system_arguments
    end

    def tag_name
      href ? :a : :button
    end

    def css_classes
      classes = ['cds--btn', "cds--btn--#{KIND_CSS[@kind]}", "cds--btn--#{SIZE_CSS[@size]}"]
      classes << 'cds--btn--disabled' if @disabled
      classes << 'cds--btn--icon-only' if @icon_only
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:disabled] = '' if @disabled && !href
      attrs[:aria] = { disabled: true }.merge(attrs.fetch(:aria, {})) if @disabled && href
      attrs[:href] = @href if href
      attrs[:type] = @type.to_s if tag_name == :button
      attrs[:role] = 'button' if href
      attrs[:tabindex] = -1 if @disabled && href
      attrs[:'aria-label'] = @icon_description if @icon_only && @icon_description
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
