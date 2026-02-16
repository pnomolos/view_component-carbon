# frozen_string_literal: true

module Carbon
  class SliderComponentPreview < ViewComponent::Preview
    # Default slider
    # -------------
    # Slider with default range 0-100
    def default
      render(Carbon::SliderComponent.new(
               name: 'volume',
               value: 50,
               label_text: 'Volume'
             ))
    end

    # Custom range
    # -----------
    # Slider with custom min, max, and step
    def custom_range
      render(Carbon::SliderComponent.new(
               name: 'temperature',
               value: 72,
               min: 60,
               max: 80,
               step: 2,
               label_text: 'Temperature (°F)'
             ))
    end

    # Without label
    # ------------
    # Slider without label text
    def without_label
      render(Carbon::SliderComponent.new(
               name: 'opacity',
               value: 75,
               min: 0,
               max: 100
             ))
    end

    # Disabled
    # -------
    # Disabled slider
    def disabled
      render(Carbon::SliderComponent.new(
               name: 'volume',
               value: 50,
               label_text: 'Volume (disabled)',
               disabled: true
             ))
    end

    # Small step
    # ---------
    # Slider with small step value for precision
    def small_step
      render(Carbon::SliderComponent.new(
               name: 'zoom',
               value: 1.5,
               min: 0.5,
               max: 3.0,
               step: 0.1,
               label_text: 'Zoom level'
             ))
    end
  end
end
