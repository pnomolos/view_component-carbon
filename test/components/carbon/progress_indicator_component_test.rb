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

      assert_selector ".cds--progress-step--current[aria-current='step']"
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

    test 'raises ArgumentError for invalid state' do
      assert_raises(ArgumentError) do
        render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
          c.with_step(label: 'Step', state: :invalid)
        end
      end
    end

    test 'accepts string values for state' do
      render_inline(Carbon::ProgressIndicatorComponent.new) do |c|
        c.with_step(label: 'Step', state: 'complete')
      end

      assert_selector '.cds--progress-step--complete'
    end
  end
end
