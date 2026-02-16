# frozen_string_literal: true

module Carbon
  class ExpandableTileComponentPreview < ViewComponent::Preview
    # @param expanded toggle
    def default(expanded: false)
      render Carbon::ExpandableTileComponent.new(expanded: expanded) do |c|
        c.with_above_the_fold do
          'Above the fold content. Always visible.'
        end
        c.with_below_the_fold do
          'Below the fold content. Only visible when expanded.'
        end
      end
    end

    def expanded
      render Carbon::ExpandableTileComponent.new(expanded: true) do |c|
        c.with_above_the_fold { 'Summary information' }
        c.with_below_the_fold { 'Detailed information shown when expanded.' }
      end
    end

    def custom_labels
      render Carbon::ExpandableTileComponent.new(
        tile_collapsed_icon_text: 'Show more',
        tile_expanded_icon_text: 'Show less'
      ) do |c|
        c.with_above_the_fold { 'Click chevron to expand' }
        c.with_below_the_fold { 'Additional details here.' }
      end
    end
  end
end
