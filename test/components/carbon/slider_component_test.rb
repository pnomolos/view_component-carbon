# frozen_string_literal: true

require 'test_helper'

module Carbon
  class SliderComponentTest < CarbonViewComponents::TestCase
    test 'renders default slider' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider-container'
      assert_selector 'input.cds--slider__input[type="range"]'
    end

    test 'renders with name attribute' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input[name="volume"]'
    end

    test 'renders with value' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 75))

      assert_selector 'input.cds--slider__input[value="75"]'
    end

    test 'renders with min and max' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, min: 0, max: 100))

      assert_selector 'input[min="0"][max="100"]'
    end

    test 'renders with custom min and max' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 5, min: 1, max: 10))

      assert_selector 'input[min="1"][max="10"]'
    end

    test 'renders with step' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, step: 5))

      assert_selector 'input[step="5"]'
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

    test 'number input has same value as range input' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--slider-text-input[value="50"]'
    end

    test 'number input has same min, max, step as range input' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 5, min: 1, max: 10, step: 2))

      assert_selector 'input.cds--slider-text-input[min="1"][max="10"][step="2"]'
    end

    test 'renders disabled slider' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, disabled: true))

      assert_selector 'input.cds--slider__input[disabled]'
      assert_selector 'input.cds--slider-text-input[disabled]'
    end

    test 'has Stimulus controller' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector '.cds--slider-container[data-controller="carbon--slider"]'
    end

    test 'range input has Stimulus target and action' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--slider__input[data-carbon--slider-target="input"]'
      assert_selector 'input.cds--slider__input[data-action="input->carbon--slider#onInput"]'
    end

    test 'number input has Stimulus target and action' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50))

      assert_selector 'input.cds--slider-text-input[data-carbon--slider-target="numberInput"]'
      assert_selector 'input.cds--slider-text-input[data-action="change->carbon--slider#onNumberChange"]'
    end

    test 'renders with custom id' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, id: 'my-slider'))

      assert_selector 'input#my-slider'
    end

    test 'label for attribute matches input id' do
      render_inline(Carbon::SliderComponent.new(name: 'volume', value: 50, id: 'my-slider', label_text: 'Volume'))

      assert_selector 'label[for="my-slider"]'
      assert_selector 'input#my-slider'
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
