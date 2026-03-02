# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ProgressIndicatorComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders progress indicator with steps' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
        c.with_step(label: 'Step 3')
      end

      assert_selector 'ul.cds--progress'
      assert_selector '.cds--progress-step', count: 3
    end

    test 'renders horizontal progress indicator by default' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'ul.cds--progress'
      assert_no_selector 'ul.cds--progress--vertical'
    end

    # -- Vertical variant --

    test 'renders vertical progress indicator when vertical is true' do
      render_inline(Carbon::ProgressIndicatorComponent.new(vertical: true)) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'ul.cds--progress.cds--progress--vertical'
    end

    # -- Current index --

    test 'sets current step based on current_index' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 1)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
        c.with_step(label: 'Step 3')
      end

      assert_selector '.cds--progress-step--complete', count: 1
      assert_selector '.cds--progress-step--current', count: 1
      assert_selector '.cds--progress-step--incomplete', count: 1
    end

    test 'first step is current when current_index is 0' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
      end

      steps = page.all('.cds--progress-step')

      assert_includes steps[0][:class], 'cds--progress-step--current'
      assert_includes steps[1][:class], 'cds--progress-step--incomplete'
    end

    # -- Steps --

    test 'renders step with label' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'First step')
      end

      assert_selector '.cds--progress-label', text: 'First step'
    end

    test 'renders step with secondary label' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', secondary_label: 'Optional')
      end

      assert_selector '.cds--progress-label', text: 'Step 1'
      assert_selector '.cds--progress-optional', text: 'Optional'
    end

    test 'does not render secondary label when not provided' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_no_selector '.cds--progress-optional'
    end

    test 'renders step with progress line' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector '.cds--progress-line'
    end

    # -- Step states --

    test 'renders complete state' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 2)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
        c.with_step(label: 'Step 3')
      end

      assert_selector '.cds--progress-step--complete', count: 2
    end

    test 'renders current state with aria-current' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 1)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
        c.with_step(label: 'Step 3')
      end

      assert_selector ".cds--progress-step--current button[aria-current='step']"
    end

    test 'renders incomplete state' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
      end

      assert_selector '.cds--progress-step--incomplete', count: 1
    end

    test 'renders step with explicit state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', state: :complete)
        c.with_step(label: 'Step 2', state: :current)
        c.with_step(label: 'Step 3', state: :incomplete)
      end

      assert_selector '.cds--progress-step--complete', count: 1
      assert_selector '.cds--progress-step--current', count: 1
      assert_selector '.cds--progress-step--incomplete', count: 1
    end

    # -- Icons --

    test 'renders icon for each step' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 1)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
        c.with_step(label: 'Step 3')
      end

      assert_selector '.cds--progress__icon', count: 3
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::ProgressIndicatorComponent.new(
                      id: 'my-progress',
                      data: { testid: 'progress-1' }
                    )) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector "ul.cds--progress#my-progress[data-testid='progress-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::ProgressIndicatorComponent.new(class: 'my-custom-class')) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'ul.cds--progress.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for unknown state' do
      assert_raises(ArgumentError) do
        render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
          c.with_step(label: 'Step', state: :unknown)
        end
      end
    end

    test 'accepts string values for state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step', state: 'complete')
      end

      assert_selector '.cds--progress-step--complete'
    end

    # -- Button wrapper (P0) --

    test 'wraps step content in button with type="button"' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'li.cds--progress-step button.cds--progress-step-button[type="button"]'
    end

    test 'button has title attribute with label' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'button[title="Step 1"]'
    end

    test 'button has tabindex 0 by default' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'button[tabindex="0"]'
    end

    test 'button has aria-current="step" when current' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'button[aria-current="step"]'
    end

    # -- Progress text wrapper (P0) --

    test 'wraps labels in cds--progress-text div' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector 'button .cds--progress-text'
      assert_selector '.cds--progress-text .cds--progress-label', text: 'Step 1'
    end

    test 'progress-text wrapper contains both label and secondary label' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', secondary_label: 'Optional')
      end

      assert_selector '.cds--progress-text .cds--progress-label', text: 'Step 1'
      assert_selector '.cds--progress-text .cds--progress-optional', text: 'Optional'
    end

    # -- Assistive text (P0) --

    test 'renders assistive text span for complete state' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 1)) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector '.cds--assistive-text', text: 'Complete'
    end

    test 'renders assistive text span for current state' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |c|
        c.with_step(label: 'Step 1')
      end

      assert_selector '.cds--assistive-text', text: 'Current'
    end

    test 'renders assistive text span for incomplete state' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
      end

      assert_selector '.cds--progress-step--incomplete .cds--assistive-text', text: 'Incomplete'
    end

    test 'renders assistive text span for invalid state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', invalid: true)
      end

      assert_selector '.cds--assistive-text', text: 'Invalid'
    end

    # -- Icon accessibility (P0/P1) --

    test 'icons contain title element' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 1)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
        c.with_step(label: 'Step 3')
      end

      assert_selector 'svg.cds--progress__icon title', text: 'Complete', count: 1
      assert_selector 'svg.cds--progress__icon title', text: 'Current', count: 1
      assert_selector 'svg.cds--progress__icon title', text: 'Incomplete', count: 1
    end

    test 'icon title uses custom description when provided' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', description: 'Custom description')
      end

      assert_selector 'svg.cds--progress__icon title', text: 'Custom description'
    end

    # -- Disabled state (P0/P1/P2) --

    test 'applies disabled class when disabled is true' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', disabled: true)
      end

      assert_selector '.cds--progress-step--disabled'
    end

    test 'sets aria-disabled on button when disabled' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', disabled: true)
      end

      assert_selector 'button[aria-disabled="true"]'
    end

    test 'sets disabled attribute on button when disabled' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', disabled: true)
      end

      assert_selector 'button[disabled]'
    end

    test 'sets tabindex -1 when disabled' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', disabled: true)
      end

      assert_selector 'button[tabindex="-1"]'
    end

    # -- Invalid state (P2) --

    test 'renders invalid state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', invalid: true)
      end

      assert_selector '.cds--progress-step--invalid'
    end

    test 'renders warning icon for invalid state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', invalid: true)
      end

      assert_selector 'svg.cds--progress__icon'
      assert_selector 'svg.cds--progress__icon title', text: 'Invalid'
    end

    test 'invalid flag overrides computed state' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |c|
        c.with_step(label: 'Step 1', invalid: true)
      end

      assert_selector '.cds--progress-step--invalid'
      assert_no_selector '.cds--progress-step--current'
    end

    test 'accepts invalid as explicit state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', state: :invalid)
      end

      assert_selector '.cds--progress-step--invalid'
    end

    # -- Space equally (P1) --

    test 'applies space-equal class when space_equally is true' do
      render_inline(Carbon::ProgressIndicatorComponent.new(space_equally: true)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
      end

      assert_selector 'ul.cds--progress--space-equal'
    end

    test 'does not apply space-equal class when vertical' do
      render_inline(Carbon::ProgressIndicatorComponent.new(space_equally: true, vertical: true)) do |c|
        c.with_step(label: 'Step 1')
        c.with_step(label: 'Step 2')
      end

      assert_selector 'ul.cds--progress--vertical'
      assert_no_selector 'ul.cds--progress--space-equal'
    end

    # -- Description prop (P2) --

    test 'uses description for assistive text when provided' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step 1', description: 'First step completed')
      end

      assert_selector '.cds--assistive-text', text: 'First step completed'
    end

    test 'renders space equally variant' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0, space_equally: true)) do |pi|
        pi.with_step(label: 'Step 1')
      end

      assert_selector '.cds--progress--space-equal'
    end

    test 'renders disabled step' do
      render_inline(Carbon::ProgressIndicatorComponent.new(current_index: 0)) do |pi|
        pi.with_step(label: 'Step 1', disabled: true)
      end

      assert_selector '.cds--progress-step--disabled'
      assert_selector 'button[aria-disabled="true"]'
    end
  end
end
