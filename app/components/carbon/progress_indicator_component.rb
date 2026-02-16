# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Progress Indicator with steps.
  #
  # @example Basic usage
  #   render Carbon::ProgressIndicatorComponent.new(current_index: 1) do |pi|
  #     pi.with_step(label: "Step 1")
  #     pi.with_step(label: "Step 2")
  #   end
  #
  # @see https://carbondesignsystem.com/components/progress-indicator/usage/
  class ProgressIndicatorComponent < BaseComponent
    renders_many :steps, 'StepComponent'

    # @param vertical [Boolean] renders steps vertically
    # @param current_index [Integer] zero-based index of the current step
    # @param space_equally [Boolean] apply equal spacing to steps
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(vertical: false, current_index: 0, space_equally: false, **system_arguments)
      @vertical = vertical
      @current_index = current_index
      @space_equally = space_equally
      @system_arguments = system_arguments
    end

    # A single step within a ProgressIndicator.
    class StepComponent < BaseComponent
      STATES = %i[complete current incomplete invalid].freeze

      # @param label [String] step label
      # @param secondary_label [String, nil] secondary label text
      # @param state [Symbol, nil] step state (:complete, :current, :incomplete, :invalid)
      # @param index [Integer, nil] step index (set automatically)
      # @param disabled [Boolean] whether the step is disabled
      # @param invalid [Boolean] whether the step is invalid (shows warning icon)
      # @param description [String, nil] accessibility text for icon (defaults to state name)
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(label:, secondary_label: nil, state: nil, index: nil, disabled: false, invalid: false,
                     description: nil, **system_arguments)
        @label = label
        @secondary_label = secondary_label
        @state = state
        @index = index
        @disabled = disabled
        @invalid = invalid
        @description = description
        @system_arguments = system_arguments
      end

      # @return [ProgressIndicatorComponent] parent component reference
      attr_accessor :parent

      # @param idx [Integer] step index
      # @return [void]
      def index=(idx)
        @index = idx
        # Set state based on parent's current_index if not explicitly set and we now have an index
        @state ||= determine_state
        # Override state to invalid if invalid flag is set
        @state = :invalid if @invalid && @state != :invalid
        @state = validate_argument('state', @state, STATES, :incomplete) if @state
      end

      private

      attr_reader :label, :secondary_label, :state, :index, :disabled, :invalid, :description, :system_arguments

      def css_classes
        classes = [carbon_class('progress-step')]
        classes << carbon_class('progress-step', nil, state.to_s.tr('_', '-')) if state
        classes << carbon_class('progress-step', nil, 'disabled') if disabled
        classes << system_arguments[:class] if system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = system_arguments.dup
        attrs.delete(:class)
        attrs
      end

      def button_attributes
        attrs = {}
        attrs[:type] = 'button'
        attrs[:title] = label
        attrs[:'aria-disabled'] = 'true' if disabled
        attrs[:disabled] = true if disabled
        attrs[:tabindex] = disabled ? -1 : 0
        attrs[:'aria-current'] = 'step' if state == :current
        attrs
      end

      def assistive_text
        return description if description

        case state
        when :complete
          'Complete'
        when :current
          'Current'
        when :invalid
          'Invalid'
        else
          'Incomplete'
        end
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
        when :invalid
          invalid_icon
        else
          incomplete_icon
        end
      end

      def icon_title
        description || assistive_text
      end

      # rubocop:disable Rails/OutputSafety
      def checkmark_icon
        <<~SVG.html_safe
          <svg class="cds--progress__icon">
            <title>#{icon_title}</title>
            <circle cx="12" cy="12" r="12" fill="currentColor"/>
            <path d="M10 13.5 L 7 10.5 L 8 9.5 L 10 11.5 L 15 6.5 L 16 7.5 Z" fill="white" stroke="white" stroke-width="1"/>
          </svg>
        SVG
      end

      def current_icon
        <<~SVG.html_safe
          <svg class="cds--progress__icon">
            <title>#{icon_title}</title>
            <circle cx="12" cy="12" r="6" fill="currentColor"/>
          </svg>
        SVG
      end

      def incomplete_icon
        <<~SVG.html_safe
          <svg class="cds--progress__icon">
            <title>#{icon_title}</title>
            <circle cx="12" cy="12" r="6" fill="none" stroke="currentColor" stroke-width="1"/>
          </svg>
        SVG
      end

      def invalid_icon
        # Warning icon (triangle with exclamation mark)
        <<~SVG.html_safe
          <svg class="cds--progress__icon">
            <title>#{icon_title}</title>
            <path d="M12,2 L22,20 L2,20 Z M11,10 L11,14 L13,14 L13,10 Z M11,16 L11,18 L13,18 L13,16 Z" fill="currentColor"/>
          </svg>
        SVG
      end
      # rubocop:enable Rails/OutputSafety

      def validate_argument(name, value, allowed, _default)
        value = value.to_sym if value.is_a?(String)
        return value if allowed.include?(value)

        raise ArgumentError,
              "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
      end
    end

    # @return [Integer] zero-based index of the current step
    attr_reader :current_index

    private

    attr_reader :vertical, :space_equally, :system_arguments

    def css_classes
      classes = [carbon_class('progress')]
      classes << carbon_class('progress', nil, 'vertical') if vertical
      classes << carbon_class('progress', nil, 'space-equal') if space_equally && !vertical
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
