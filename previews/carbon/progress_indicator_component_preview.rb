# frozen_string_literal: true

module Carbon
  class ProgressIndicatorComponentPreview < ViewComponent::Preview
    # @param current_index number
    # @param vertical toggle
    def default(current_index: 1, vertical: false)
      render Carbon::ProgressIndicatorComponent.new(current_index: current_index, vertical: vertical) do |c|
        c.with_step(label: 'First step', secondary_label: 'Optional label')
        c.with_step(label: 'Second step', secondary_label: 'Optional label')
        c.with_step(label: 'Third step', secondary_label: 'Optional label')
        c.with_step(label: 'Fourth step', secondary_label: 'Optional label')
      end
    end

    def horizontal
      render Carbon::ProgressIndicatorComponent.new(current_index: 1) do |c|
        c.with_step(label: 'First step')
        c.with_step(label: 'Second step')
        c.with_step(label: 'Third step')
        c.with_step(label: 'Fourth step')
      end
    end

    def vertical
      render Carbon::ProgressIndicatorComponent.new(vertical: true, current_index: 2) do |c|
        c.with_step(label: 'First step', secondary_label: 'Complete')
        c.with_step(label: 'Second step', secondary_label: 'Complete')
        c.with_step(label: 'Third step', secondary_label: 'Current')
        c.with_step(label: 'Fourth step', secondary_label: 'Incomplete')
      end
    end

    def all_complete
      render Carbon::ProgressIndicatorComponent.new(current_index: 4) do |c|
        c.with_step(label: 'First step')
        c.with_step(label: 'Second step')
        c.with_step(label: 'Third step')
        c.with_step(label: 'Fourth step')
      end
    end

    def with_explicit_states
      render Carbon::ProgressIndicatorComponent.new do |c|
        c.with_step(label: 'Complete step', state: :complete)
        c.with_step(label: 'Current step', state: :current)
        c.with_step(label: 'Incomplete step', state: :incomplete)
      end
    end
  end
end
