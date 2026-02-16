# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Button.
  #
  # @example Basic usage
  #   render Carbon::ButtonComponent.new(kind: :primary) { "Click me" }
  #
  # @see https://carbondesignsystem.com/components/button/usage/
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

    # @return [Symbol] button variant
    attr_reader :kind
    # @return [Symbol] button size
    attr_reader :size
    # @return [Boolean] whether the button is disabled
    attr_reader :disabled
    # @return [Boolean] whether the button shows only an icon
    attr_reader :icon_only
    # @return [String, nil] link URL (renders as anchor when set)
    attr_reader :href
    # @return [Symbol] HTML button type
    attr_reader :type

    # @param kind [Symbol] button variant
    #   (:primary, :secondary, :tertiary, :ghost, :danger, :danger_tertiary, :danger_ghost)
    # @param size [Symbol] button size (:sm, :md, :lg, :xl, :"2xl")
    # @param disabled [Boolean] whether the button is disabled
    # @param icon_only [Boolean] renders an icon-only button
    # @param href [String, nil] renders as a link when provided
    # @param type [Symbol] HTML button type (:button, :submit, :reset)
    # @param icon_description [String, nil] accessible label for icon-only buttons
    # @param system_arguments [Hash] additional HTML attributes
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

    # @return [Symbol] the HTML tag to render (:a or :button)
    def tag_name
      href ? :a : :button
    end

    # @return [String] CSS class string for the button
    def css_classes
      classes = ['cds--btn', "cds--btn--#{KIND_CSS[@kind]}", "cds--btn--#{SIZE_CSS[@size]}"]
      classes << 'cds--btn--disabled' if @disabled
      classes << 'cds--btn--icon-only' if @icon_only
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the button element
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
