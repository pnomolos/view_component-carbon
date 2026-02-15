# frozen_string_literal: true

module Carbon
  class ToggleComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md] }
    # @param toggled toggle
    # @param disabled toggle
    # @param label_text text
    def default(size: :md, toggled: false, disabled: false, label_text: 'Toggle label')
      render Carbon::ToggleComponent.new(
        size: size.to_sym,
        toggled: toggled,
        disabled: disabled,
        label_text: label_text
      )
    end

    def small_size
      render Carbon::ToggleComponent.new(size: :sm, label_text: 'Small toggle')
    end

    def toggled_state
      render Carbon::ToggleComponent.new(toggled: true, label_text: 'This toggle is on')
    end

    def disabled_state
      render Carbon::ToggleComponent.new(disabled: true, label_text: 'Disabled toggle')
    end

    def disabled_and_toggled
      render Carbon::ToggleComponent.new(
        disabled: true,
        toggled: true,
        label_text: 'Disabled but toggled on'
      )
    end

    def custom_labels
      render Carbon::ToggleComponent.new(
        label_text: 'Notifications',
        label_a: 'Disabled',
        label_b: 'Enabled'
      )
    end

    def hidden_label
      render Carbon::ToggleComponent.new(
        label_text: 'Hidden label text',
        hide_label: true
      )
    end

    def no_label
      render Carbon::ToggleComponent.new
    end

    def multiple_toggles
      content_tag :div, style: 'display: flex; flex-direction: column; gap: 1rem;' do
        safe_join([
                    render(Carbon::ToggleComponent.new(label_text: 'Enable feature A', toggled: true)),
                    render(Carbon::ToggleComponent.new(label_text: 'Enable feature B')),
                    render(Carbon::ToggleComponent.new(label_text: 'Enable feature C', disabled: true))
                  ])
      end
    end
  end
end
