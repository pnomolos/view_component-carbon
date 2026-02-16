# frozen_string_literal: true

module Carbon
  class TagComponentPreview < ViewComponent::Preview
    # @param type select { choices: [read_only, filter, dismissible] }
    # @param color select { choices: [red, magenta, purple, blue, cyan, teal, green, gray, cool_gray] }
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    def default(type: :read_only, color: :gray, size: :md, disabled: false)
      render Carbon::TagComponent.new(
        type: type.to_sym,
        color: color.to_sym,
        size: size.to_sym,
        disabled: disabled
      ) { 'Tag label' }
    end

    def all_colors
      colors = %i[red magenta purple blue cyan teal green gray cool_gray warm_gray high_contrast outline]
      tag.div do
        safe_join(
          colors.map do |color|
            render(Carbon::TagComponent.new(color: color)) { color.to_s.humanize }
          end,
          ' '
        )
      end
    end

    def filter_tags
      tag.div do
        safe_join([
                    render(Carbon::TagComponent.new(type: :filter, color: :blue)) { 'Filter 1' },
                    ' ',
                    render(Carbon::TagComponent.new(type: :filter, color: :purple)) { 'Filter 2' },
                    ' ',
                    render(Carbon::TagComponent.new(type: :filter, color: :red)) { 'Filter 3' }
                  ])
      end
    end

    def dismissible_tags
      tag.div do
        safe_join([
                    render(Carbon::TagComponent.new(type: :dismissible, color: :green)) { 'Success' },
                    ' ',
                    render(Carbon::TagComponent.new(type: :dismissible, color: :red)) { 'Error' }
                  ])
      end
    end
  end
end
