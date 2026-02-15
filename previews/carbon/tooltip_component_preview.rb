# frozen_string_literal: true

module Carbon
  class TooltipComponentPreview < ViewComponent::Preview
    # Default tooltip
    # --------------
    # Tooltip with bottom alignment (default)
    def default
      render(Carbon::TooltipComponent.new(label: 'This is a helpful tooltip')) do
        'Hover or focus me'
      end
    end

    # With description
    # ---------------
    # Tooltip with additional description text
    def with_description
      render(Carbon::TooltipComponent.new(
               label: 'Helpful label',
               description: 'Additional detailed information about this element.'
             )) do
        'Hover for more info'
      end
    end

    # Top aligned
    # ----------
    def top_aligned
      render(Carbon::TooltipComponent.new(label: 'Top aligned tooltip', align: :top)) do
        'Hover me'
      end
    end

    # Left aligned
    # -----------
    def left_aligned
      render(Carbon::TooltipComponent.new(label: 'Left aligned tooltip', align: :left)) do
        'Hover me'
      end
    end

    # Right aligned
    # ------------
    def right_aligned
      render(Carbon::TooltipComponent.new(label: 'Right aligned tooltip', align: :right)) do
        'Hover me'
      end
    end
  end
end
