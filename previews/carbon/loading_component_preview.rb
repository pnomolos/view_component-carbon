# frozen_string_literal: true

module Carbon
  class LoadingComponentPreview < ViewComponent::Preview
    # @param size select { choices: [small, normal] }
    # @param active toggle
    # @param overlay toggle
    def default(size: :normal, active: true, overlay: false)
      render Carbon::LoadingComponent.new(size: size.to_sym, active: active, overlay: overlay)
    end

    def small
      render Carbon::LoadingComponent.new(size: :small)
    end

    def normal
      render Carbon::LoadingComponent.new(size: :normal)
    end

    def inactive
      render Carbon::LoadingComponent.new(active: false)
    end

    def with_overlay
      render Carbon::LoadingComponent.new(overlay: true)
    end

    def with_overlay_inactive
      render Carbon::LoadingComponent.new(overlay: true, active: false)
    end
  end
end
