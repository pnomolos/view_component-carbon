# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ProgressBarComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default progress bar' do
      render_inline(Carbon::ProgressBarComponent.new(value: 50))

      assert_selector 'div.cds--progress-bar.cds--progress-bar--big.cds--progress-bar--active'
      assert_selector '.cds--progress-bar__track[role="progressbar"][aria-valuemin="0"][aria-valuemax="100"]'
      assert_selector '.cds--progress-bar__track[aria-valuenow="50"]'
    end

    test 'renders bar with correct transform' do
      render_inline(Carbon::ProgressBarComponent.new(value: 50, max: 100))

      assert_selector '.cds--progress-bar__bar-inner[style*="scaleX(0.5)"]'
    end

    # -- Sizes --

    test 'renders big size by default' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30))

      assert_selector '.cds--progress-bar--big'
    end

    test 'renders small size' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, size: :small))

      assert_selector '.cds--progress-bar--small'
    end

    # -- Statuses --

    test 'renders active status by default' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30))

      assert_selector '.cds--progress-bar--active'
    end

    test 'renders finished status' do
      render_inline(Carbon::ProgressBarComponent.new(value: 100, status: :finished))

      assert_selector '.cds--progress-bar--finished'
    end

    test 'renders error status' do
      render_inline(Carbon::ProgressBarComponent.new(value: 50, status: :error))

      assert_selector '.cds--progress-bar--error'
    end

    # -- Types --

    test 'renders default type' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30))

      assert_selector '.cds--progress-bar'
      assert_no_selector '.cds--progress-bar--inline'
      assert_no_selector '.cds--progress-bar--indeterminate'
    end

    test 'renders inline type' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, type: :inline))

      assert_selector '.cds--progress-bar--inline'
    end

    test 'renders indeterminate type' do
      render_inline(Carbon::ProgressBarComponent.new(type: :indeterminate))

      assert_selector '.cds--progress-bar--indeterminate'
    end

    test 'indeterminate type does not require value' do
      render_inline(Carbon::ProgressBarComponent.new(type: :indeterminate))

      assert_selector '.cds--progress-bar--indeterminate'
    end

    test 'indeterminate type does not render aria-valuenow' do
      render_inline(Carbon::ProgressBarComponent.new(type: :indeterminate, value: 50))

      assert_no_selector '[aria-valuenow]'
    end

    # -- Value and max --

    test 'calculates progress correctly' do
      render_inline(Carbon::ProgressBarComponent.new(value: 25, max: 100))

      assert_selector '.cds--progress-bar__bar-inner[style*="scaleX(0.25)"]'
    end

    test 'handles custom max value' do
      render_inline(Carbon::ProgressBarComponent.new(value: 5, max: 10))

      assert_selector '.cds--progress-bar__track[aria-valuemax="10"]'
      assert_selector '.cds--progress-bar__bar-inner[style*="scaleX(0.5)"]'
    end

    test 'caps progress at 100 percent' do
      render_inline(Carbon::ProgressBarComponent.new(value: 150, max: 100))

      assert_selector '.cds--progress-bar__bar-inner[style*="scaleX(1"]'
    end

    # -- Label --

    test 'renders without label by default' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30))

      assert_no_selector '.cds--progress-bar__label'
    end

    test 'renders with label' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, label: 'Upload progress'))

      assert_selector '.cds--progress-bar__label-text', text: 'Upload progress'
    end

    test 'renders label with value for default type' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, max: 100, label: 'Progress'))

      assert_selector '.cds--progress-bar__label-text', text: 'Progress'
      assert_selector '.cds--progress-bar__value', text: '30/100'
    end

    test 'label sets aria-label on progress track' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, label: 'Upload progress'))

      assert_selector '.cds--progress-bar__track[aria-label="Upload progress"]'
    end

    # -- Helper text --

    test 'renders without helper text by default' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30))

      assert_no_selector '.cds--progress-bar__helper-text'
    end

    test 'renders with helper text' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, helper_text: '30 of 100 MB uploaded'))

      assert_selector '.cds--progress-bar__helper-text', text: '30 of 100 MB uploaded'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, id: 'my-progress', data: { testid: 'progress-1' }))

      assert_selector 'div#my-progress[data-testid="progress-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, class: 'my-custom-class'))

      assert_selector '.cds--progress-bar.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError when value is missing for default type' do
      assert_raises(ArgumentError, match: /value is required/) do
        Carbon::ProgressBarComponent.new(type: :default)
      end
    end

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::ProgressBarComponent.new(value: 30, size: :invalid)
      end
    end

    test 'raises ArgumentError for invalid status' do
      assert_raises(ArgumentError) do
        Carbon::ProgressBarComponent.new(value: 30, status: :invalid)
      end
    end

    test 'raises ArgumentError for invalid type' do
      assert_raises(ArgumentError) do
        Carbon::ProgressBarComponent.new(value: 30, type: :invalid)
      end
    end

    test 'accepts string values for size' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, size: 'small'))

      assert_selector '.cds--progress-bar--small'
    end

    test 'accepts string values for status' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, status: 'finished'))

      assert_selector '.cds--progress-bar--finished'
    end

    test 'accepts string values for type' do
      render_inline(Carbon::ProgressBarComponent.new(value: 30, type: 'inline'))

      assert_selector '.cds--progress-bar--inline'
    end
  end
end
