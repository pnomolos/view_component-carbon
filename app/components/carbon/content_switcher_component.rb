# frozen_string_literal: true

module Carbon
  class ContentSwitcherComponent < Carbon::BaseComponent
    SIZES = %i[sm md lg].freeze
    DEFAULT_SIZE = :md

    renders_many :options, 'Carbon::ContentSwitcherComponent::OptionComponent'

    attr_reader :size

    def initialize(size: DEFAULT_SIZE, **system_arguments)
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = ['cds--content-switcher']
      classes << "cds--content-switcher--#{@size}" if @size != DEFAULT_SIZE
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs['data-controller'] = 'carbon--content-switcher'
      attrs[:role] = 'tablist'
      attrs
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    class OptionComponent < Carbon::BaseComponent
      attr_reader :label, :selected

      def initialize(label:, selected: false, **system_arguments)
        @label = label
        @selected = selected
        @system_arguments = system_arguments
      end

      def css_classes
        classes = ['cds--content-switcher-btn']
        classes << 'cds--content-switcher--selected' if @selected
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:type] = 'button'
        attrs[:role] = 'tab'
        attrs['aria-selected'] = @selected
        attrs['data-action'] = 'click->carbon--content-switcher#select'
        attrs['data-carbon--content-switcher-target'] = 'option'
        attrs[:tabindex] = @selected ? '0' : '-1'
        attrs
      end
    end
  end
end
