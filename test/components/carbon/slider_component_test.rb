# frozen_string_literal: true

require 'test_helper'

module Carbon
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
  end
end
