# frozen_string_literal: true

module Carbon
  class InlineLoadingComponentPreview < ViewComponent::Preview
    # @param status select { choices: [active, finished, error, inactive] }
    # @param description text
    def default(status: :active, description: 'Loading data...')
      render Carbon::InlineLoadingComponent.new(status: status.to_sym, description: description)
    end

    def active
      render Carbon::InlineLoadingComponent.new(status: :active, description: 'Loading data...')
    end

    def finished
      render Carbon::InlineLoadingComponent.new(status: :finished, description: 'Data loaded')
    end

    def error
      render Carbon::InlineLoadingComponent.new(status: :error, description: 'Failed to load data')
    end

    def inactive
      render Carbon::InlineLoadingComponent.new(status: :inactive)
    end

    def without_description
      render Carbon::InlineLoadingComponent.new(status: :active)
    end
  end
end
