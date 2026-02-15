# frozen_string_literal: true

module Carbon
  class ExpandableTileComponent < Carbon::BaseComponent
    renders_one :above_the_fold
    renders_one :below_the_fold

    attr_reader :expanded, :tile_collapsed_icon_text, :tile_expanded_icon_text, :tile_id

    def initialize(
      expanded: false,
      tile_collapsed_icon_text: 'Interact to expand tile',
      tile_expanded_icon_text: 'Interact to collapse tile',
      id: nil,
      **system_arguments
    )
      @expanded = expanded
      @tile_collapsed_icon_text = tile_collapsed_icon_text
      @tile_expanded_icon_text = tile_expanded_icon_text
      @tile_id = id || "expandable-tile-#{SecureRandom.hex(4)}"
      @system_arguments = system_arguments
    end

    private

    def css_classes
      classes = %w[cds--tile cds--tile--expandable]
      classes << 'cds--tile--is-expanded' if @expanded
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:id] = @tile_id
      attrs['data-controller'] = 'carbon--expandable-tile'
      attrs['data-carbon--expandable-tile-expanded-value'] = @expanded.to_s
      attrs['data-carbon--expandable-tile-collapsed-text-value'] = @tile_collapsed_icon_text
      attrs['data-carbon--expandable-tile-expanded-text-value'] = @tile_expanded_icon_text
      attrs
    end

    def below_fold_id
      "#{@tile_id}-below"
    end

    def current_aria_label
      @expanded ? @tile_expanded_icon_text : @tile_collapsed_icon_text
    end

    def chevron_svg
      '<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">' \
        '<path d="M8 11L3 6l.7-.7L8 9.6l4.3-4.3.7.7z" fill="currentColor"/></svg>'
    end
  end
end
