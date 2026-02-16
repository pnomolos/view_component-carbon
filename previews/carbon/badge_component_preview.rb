# frozen_string_literal: true

module Carbon
  class BadgeComponentPreview < ViewComponent::Preview
    # @param count number
    # @param color select { choices: [red, blue, green, gray] }
    def default(count: 5, color: :gray)
      render Carbon::BadgeComponent.new(count: count.to_i, color: color.to_sym)
    end

    def dot_only
      render Carbon::BadgeComponent.new(color: :red)
    end

    # rubocop:disable Metrics/AbcSize
    def with_counts
      tag.div do
        safe_join([
                    tag.span('Badge with 1: '),
                    render(Carbon::BadgeComponent.new(count: 1, color: :blue)),
                    tag.br,
                    tag.span('Badge with 5: '),
                    render(Carbon::BadgeComponent.new(count: 5, color: :green)),
                    tag.br,
                    tag.span('Badge with 10: '),
                    render(Carbon::BadgeComponent.new(count: 10, color: :red))
                  ])
      end
    end
    # rubocop:enable Metrics/AbcSize

    def all_colors
      colors = %i[red blue green gray]
      tag.div do
        safe_join(
          colors.map do |color|
            safe_join([
                        tag.span("#{color.to_s.humanize}: "),
                        render(Carbon::BadgeComponent.new(count: 3, color: color)),
                        tag.br
                      ])
          end
        )
      end
    end
  end
end
