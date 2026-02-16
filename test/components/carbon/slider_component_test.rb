# frozen_string_literal: true

require 'test_helper'

module Carbon
  # rubocop:disable Metrics/ClassLength
  class SliderComponentTest < CarbonViewComponents::TestCase
    test 'renders default slider' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider-container'
      assert_selector '.cds--slider[role="presentation"]'
    end

    test 'renders custom slider thumb instead of native range input' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_no_selector 'input[type="range"]'
      assert_selector '.cds--slider__thumb[role="slider"]'
    end

    test 'renders thumb with aria attributes' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 75, min: 0, max: 100))

      assert_selector '.cds--slider__thumb[aria-valuenow="75"][aria-valuemin="0"][aria-valuemax="100"]'
    end

    test 'renders thumb wrapper with inline style for position' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, min: 0, max: 100))

      assert_selector '.cds--slider__thumb-wrapper[style*="50"]'
    end

    test 'renders track and filled track' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider__track'
      assert_selector '.cds--slider__filled-track'
    end

    test 'renders filled track with transform style' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, min: 0, max: 100))

      assert_selector '.cds--slider__filled-track[style*="scaleX(0.5)"]'
    end

    test 'renders with name attribute on number input' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--slider-text-input[name="volume"]'
    end

    test 'renders with value' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 75))

      assert_selector '.cds--slider__thumb[aria-valuenow="75"]'
    end

    test 'renders with min and max' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, min: 0, max: 100))

      assert_selector '.cds--slider__thumb[aria-valuemin="0"][aria-valuemax="100"]'
    end

    test 'renders with custom min and max' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 5, min: 1, max: 10))

      assert_selector '.cds--slider__thumb[aria-valuemin="1"][aria-valuemax="10"]'
    end

    test 'renders with step on number input' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, step: 5))

      assert_selector 'input.cds--slider-text-input[step="5"]'
    end

    test 'renders with label text' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, label_text: 'Volume'))

      assert_selector 'label.cds--label', text: 'Volume'
    end

    test 'renders without label when label_text not provided' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_no_selector 'label.cds--label'
    end

    test 'renders range labels' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, min: 0, max: 100))

      assert_selector '.cds--slider__range-label', text: '0'
      assert_selector '.cds--slider__range-label', text: '100'
    end

    test 'renders number input' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--text-input.cds--slider-text-input[type="number"]'
    end

    test 'number input has same value as slider' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--slider-text-input[value="50"]'
    end

    test 'number input has same min, max, step' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 5, min: 1, max: 10, step: 2))

      assert_selector 'input.cds--slider-text-input[min="1"][max="10"][step="2"]'
    end

    test 'renders number input wrapper' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--text-input-wrapper.cds--slider-text-input__wrapper'
    end

    test 'renders disabled slider' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, disabled: true))

      assert_selector '.cds--slider__thumb[aria-disabled="true"]'
      assert_selector 'input.cds--slider-text-input[disabled]'
    end

    test 'has Stimulus controller' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider-container[data-controller="carbon--slider"]'
    end

    test 'thumb has Stimulus target and keyboard action' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider__thumb[data-carbon--slider-target="thumb"]'
      assert_selector '.cds--slider__thumb[data-action="keydown->carbon--slider#onKeyDown"]'
    end

    test 'number input has Stimulus target and action' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--slider-text-input[data-carbon--slider-target="numberInput"]'
      assert_selector 'input.cds--slider-text-input[data-action="change->carbon--slider#onNumberChange"]'
    end

    test 'slider track has mousedown action' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider[data-action="mousedown->carbon--slider#onTrackMouseDown"]'
    end

    test 'renders with custom id' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, id: 'my-slider'))

      assert_selector '.cds--slider__thumb#my-slider'
    end

    test 'label for attribute matches thumb id' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, id: 'my-slider', label_text: 'Volume'))

      assert_selector 'label[for="my-slider"]'
      assert_selector '.cds--slider__thumb#my-slider'
    end

    test 'thumb aria-labelledby points to label' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, id: 'my-slider', label_text: 'Volume'))

      assert_selector '.cds--slider__thumb[aria-labelledby="my-slider-label"]'
      assert_selector 'label#my-slider-label'
    end

    test 'passes through system arguments' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, data: { testid: 'slider-1' }))

      assert_selector ".cds--form-item[data-testid='slider-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, class: 'custom-class'))

      assert_selector '.cds--form-item.custom-class'
    end

    # P0 Tests: Accessibility

    test 'renders aria-valuetext attribute' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 75, min: 0, max: 100))

      assert_selector '.cds--slider__thumb[aria-valuetext="75"]'
    end

    test 'sets tabindex to -1 when readonly' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, readonly: true))

      assert_selector '.cds--slider__thumb[tabindex="-1"]'
    end

    test 'sets tabindex to 0 when not readonly' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, readonly: false))

      assert_selector '.cds--slider__thumb[tabindex="0"]'
    end

    # P1 Tests: Correctness

    test 'adds cds--slider--disabled class when disabled' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, disabled: true))

      assert_selector '.cds--slider.cds--slider--disabled'
    end

    test 'adds cds--slider--readonly class when readonly' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, readonly: true))

      assert_selector '.cds--slider.cds--slider--readonly'
    end

    test 'adds cds--label--disabled class to label when disabled' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, label_text: 'Volume', disabled: true))

      assert_selector 'label.cds--label.cds--label--disabled'
    end

    test 'wraps filled track in container' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds-ce--slider__filled-track-container > .cds--slider__filled-track'
    end

    test 'uses div for thumb wrapper instead of span' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'div.cds--slider__thumb-wrapper'
      assert_no_selector 'span.cds--slider__thumb-wrapper'
    end

    # P2 Tests: Missing Features

    test 'supports readonly prop' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, readonly: true))

      assert_selector 'input.cds--slider-text-input[readonly]'
    end

    test 'supports required prop' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, required: true))

      assert_selector 'input.cds--slider-text-input[required]'
    end

    test 'supports invalid prop with invalid_text' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, invalid: true,
                                                invalid_text: 'Invalid value'))

      assert_selector '.cds--slider__validation-msg.cds--slider__validation-msg--invalid', text: 'Invalid value'
    end

    test 'supports warn prop with warn_text' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, warn: true, warn_text: 'Warning message'))

      assert_selector '.cds--slider__validation-msg', text: 'Warning message'
    end

    test 'does not show validation message when invalid but no text' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, invalid: true))

      assert_no_selector '.cds--slider__validation-msg'
    end

    test 'does not show validation message when warn but no text' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, warn: true))

      assert_no_selector '.cds--slider__validation-msg'
    end

    test 'shows invalid message over warn message when both present' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, invalid: true, warn: true,
                                                invalid_text: 'Error', warn_text: 'Warning'))

      assert_selector '.cds--slider__validation-msg', text: 'Error'
      assert_no_selector '.cds--slider__validation-msg', text: 'Warning'
    end

    test 'supports min_label prop' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, min: 0, min_label: 'Quiet'))

      assert_selector '.cds--slider__range-label', text: 'Quiet'
    end

    test 'supports max_label prop' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, max: 100, max_label: 'Loud'))

      assert_selector '.cds--slider__range-label', text: 'Loud'
    end

    test 'supports hide_label prop' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, label_text: 'Volume', hide_label: true))

      assert_selector 'label.cds--label.cds--visually-hidden'
    end

    test 'supports hide_text_input prop' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, hide_text_input: true))

      assert_no_selector '.cds--slider-text-input__wrapper'
      assert_no_selector 'input.cds--slider-text-input'
    end

    test 'shows text input by default' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider-text-input__wrapper'
      assert_selector 'input.cds--slider-text-input'
    end

    test 'supports step_multiplier prop in data attributes' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, step_multiplier: 8))

      assert_selector '.cds--slider-container[data-carbon--slider-step-multiplier-value="8"]'
    end

    test 'uses default step_multiplier of 4' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider-container[data-carbon--slider-step-multiplier-value="4"]'
    end

    # Additional Tests

    test 'validation message has correct CSS classes for invalid state' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, invalid: true,
                                                invalid_text: 'Error'))

      assert_selector '.cds--form-requirement.cds--slider__validation-msg.cds--slider__validation-msg--invalid'
    end

    test 'validation message has correct CSS classes for warn state' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, warn: true, warn_text: 'Warning'))

      assert_selector '.cds--form-requirement.cds--slider__validation-msg'
      assert_no_selector '.cds--slider__validation-msg--invalid'
    end

    test 'renders custom min and max labels' do
      render_inline(Carbon::SliderComponent.new(name: 'vol', label_text: 'Val', min: 0, max: 100, value: 50,
                                                min_label: 'Low', max_label: 'High'))

      assert_selector '.cds--slider__range-label', text: 'Low'
      assert_selector '.cds--slider__range-label', text: 'High'
    end

    test 'renders aria-valuetext when provided' do
      render_inline(Carbon::SliderComponent.new(name: 'vol', label_text: 'Val', min: 0, max: 100, value: 50,
                                                aria_value_text: '50 degrees'))

      assert_selector '[aria-valuetext="50 degrees"]'
    end

    test 'hides text input when hide_text_input is true' do
      render_inline(Carbon::SliderComponent.new(name: 'vol', label_text: 'Val', min: 0, max: 100, value: 50,
                                                hide_text_input: true))

      assert_no_selector 'input[type="number"]'
    end
  end
  # rubocop:enable Metrics/ClassLength
end
