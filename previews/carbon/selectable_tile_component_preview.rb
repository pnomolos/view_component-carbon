# frozen_string_literal: true

module Carbon
  class SelectableTileComponentPreview < ViewComponent::Preview
    # @param selected toggle
    # @param disabled toggle
    def default(selected: false, disabled: false)
      render Carbon::SelectableTileComponent.new(
        selected: selected,
        disabled: disabled,
        name: 'feature',
        value: 'option1'
      ) do
        'Selectable tile content'
      end
    end

    def selected
      render Carbon::SelectableTileComponent.new(selected: true, name: 'feature', value: 'option1') do
        'This tile is selected'
      end
    end

    def disabled
      render Carbon::SelectableTileComponent.new(disabled: true, name: 'feature', value: 'option1') do
        'This tile is disabled'
      end
    end

    # @label Multiple Selectable
    def multiple_selectable
      render_with_template(template: 'carbon/selectable_tile_component_preview/multiple_selectable')
    end
  end
end
