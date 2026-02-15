# frozen_string_literal: true

module Carbon
  class SkeletonTextComponentPreview < ViewComponent::Preview
    # @param lines number
    # @param heading toggle
    def default(lines: 3, heading: false)
      render Carbon::SkeletonTextComponent.new(lines: lines, heading: heading)
    end

    def heading
      render Carbon::SkeletonTextComponent.new(heading: true)
    end

    def paragraph
      render Carbon::SkeletonTextComponent.new(lines: 4)
    end

    def single_line
      render Carbon::SkeletonTextComponent.new(lines: 1, paragraph: false, width: '75%')
    end

    def multiple_lines
      render Carbon::SkeletonTextComponent.new(lines: 5)
    end
  end
end
