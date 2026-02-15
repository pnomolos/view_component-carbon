# frozen_string_literal: true

module Carbon
  class PopoverComponentPreview < ViewComponent::Preview
    # Default popover
    # --------------
    # Popover with bottom alignment and drop shadow
    def default
      render(Carbon::PopoverComponent.new) do |c|
        c.with_body do
          tag.div do
            tag.h4('Popover title', class: 'mb-2') +
              tag.p('This is the popover content that appears when you click the trigger.')
          end
        end
        'Click me'
      end
    end

    # Open by default
    # --------------
    # Popover that is initially open
    def open_by_default
      render(Carbon::PopoverComponent.new(open: true)) do |c|
        c.with_body { 'This popover is open by default' }
        'Trigger'
      end
    end

    # Without caret
    # ------------
    # Popover without the pointing caret
    def without_caret
      render(Carbon::PopoverComponent.new(caret: false)) do |c|
        c.with_body { 'This popover has no caret' }
        'Click me'
      end
    end

    # High contrast
    # ------------
    # Popover with high contrast styling
    def high_contrast
      render(Carbon::PopoverComponent.new(high_contrast: true)) do |c|
        c.with_body { 'High contrast popover content' }
        'Click me'
      end
    end

    # Without drop shadow
    # ------------------
    # Popover without drop shadow
    def without_drop_shadow
      render(Carbon::PopoverComponent.new(drop_shadow: false)) do |c|
        c.with_body { 'This popover has no drop shadow' }
        'Click me'
      end
    end

    # Top aligned
    # ----------
    def top_aligned
      render(Carbon::PopoverComponent.new(align: :top)) do |c|
        c.with_body { 'Top aligned popover content' }
        'Click me'
      end
    end
  end
end
