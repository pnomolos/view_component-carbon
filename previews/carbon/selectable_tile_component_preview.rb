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

    def multiple_selectable
      content_tag :div, style: 'display: flex; gap: 1rem;' do
        safe_join([
                    render(Carbon::SelectableTileComponent.new(
                             name: 'features', value: 'a', selected: true
                           )) { 'Feature A' },
                    render(Carbon::SelectableTileComponent.new(
                             name: 'features', value: 'b'
                           )) { 'Feature B' },
                    render(Carbon::SelectableTileComponent.new(
                             name: 'features', value: 'c', disabled: true
                           )) { 'Feature C' }
                  ])
      end
    end
  end
end
