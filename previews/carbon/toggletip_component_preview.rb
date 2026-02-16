# frozen_string_literal: true

module Carbon
  class ToggletipComponentPreview < ViewComponent::Preview
    # Default toggletip
    # ----------------
    # Toggletip with bottom alignment (default)
    def default
      render(Carbon::ToggletipComponent.new) do |c|
        c.with_body do
          'This is additional information that appears when you click the info icon.'
        end
      end
    end

    # With rich content
    # ----------------
    # Toggletip with formatted content
    def with_rich_content
      render(Carbon::ToggletipComponent.new) do |c|
        c.with_body do
          tag.div do
            tag.p('This toggletip contains multiple paragraphs.', class: 'mb-2') +
              tag.p('Click outside or press Escape to close.')
          end
        end
      end
    end

    # Top aligned
    # ----------
    def top_aligned
      render(Carbon::ToggletipComponent.new(align: :top)) do |c|
        c.with_body { 'Top aligned toggletip content' }
      end
    end

    # Left aligned
    # -----------
    def left_aligned
      render(Carbon::ToggletipComponent.new(align: :left)) do |c|
        c.with_body { 'Left aligned toggletip content' }
      end
    end

    # Right aligned
    # ------------
    def right_aligned
      render(Carbon::ToggletipComponent.new(align: :right)) do |c|
        c.with_body { 'Right aligned toggletip content' }
      end
    end
  end
end
