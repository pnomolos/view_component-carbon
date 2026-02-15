# frozen_string_literal: true

module Carbon
  class ProgressIndicatorComponent < BaseComponent
    renders_many :steps, 'StepComponent'

    def initialize(vertical: false, current_index: 0, **system_arguments)
      @vertical = vertical
      @current_index = current_index
      @system_arguments = system_arguments
    end

    class StepComponent < BaseComponent
      STATES = %i[complete current incomplete].freeze

      def initialize(label:, secondary_label: nil, state: nil, index: nil, **system_arguments)
        @label = label
        @secondary_label = secondary_label
        @state = state
        @index = index
        @system_arguments = system_arguments
      end

      attr_accessor :parent

      def index=(idx)
        @index = idx
        # Set state based on parent's current_index if not explicitly set and we now have an index
        @state ||= determine_state
        @state = validate_argument('state', @state, STATES, :incomplete) if @state
      end

      private

      attr_reader :label, :secondary_label, :state, :index, :system_arguments

      def css_classes
        classes = [carbon_class('progress-step')]
        classes << carbon_class('progress-step', nil, state.to_s.tr('_', '-')) if state
        classes << system_arguments[:class] if system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = system_arguments.dup
        attrs.delete(:class)
        attrs[:'aria-current'] = 'step' if state == :current
        attrs
      end

      def determine_state
        parent_current = parent.current_index
        if index < parent_current
          :complete
        elsif index == parent_current
          :current
        else
          :incomplete
        end
      end

      def icon_svg
        case state
        when :complete
          checkmark_icon
        when :current
          current_icon
        else
          incomplete_icon
        end
      end

      def checkmark_icon
        '<svg class="cds--progress__icon"><circle cx="12" cy="12" r="12" fill="currentColor"/>' \
        '<path d="M10 13.5 L 7 10.5 L 8 9.5 L 10 11.5 L 15 6.5 L 16 7.5 Z" ' \
        'fill="white" stroke="white" stroke-width="1"/></svg>'.html_safe
      end

      def current_icon
        '<svg class="cds--progress__icon"><circle cx="12" cy="12" r="6" fill="currentColor"/></svg>'.html_safe
      end

      def incomplete_icon
        '<svg class="cds--progress__icon"><circle cx="12" cy="12" r="6" fill="none" ' \
        'stroke="currentColor" stroke-width="1"/></svg>'.html_safe
      end

      def validate_argument(name, value, allowed, _default)
        value = value.to_sym if value.is_a?(String)
        return value if allowed.include?(value)

        raise ArgumentError,
              "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
      end
    end

    attr_reader :current_index

    private

    attr_reader :vertical, :system_arguments

    def css_classes
      classes = [carbon_class('progress')]
      classes << carbon_class('progress', nil, 'vertical') if vertical
      classes << system_arguments[:class] if system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = system_arguments.dup
      attrs.delete(:class)
      attrs
    end
  end
end
