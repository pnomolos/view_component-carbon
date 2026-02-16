# frozen_string_literal: true

module Carbon
  class ContentSwitcherComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    def default(size: :md)
      render Carbon::ContentSwitcherComponent.new(size: size.to_sym) do |c|
        c.with_option(label: 'First option', selected: true)
        c.with_option(label: 'Second option')
        c.with_option(label: 'Third option')
      end
    end

    def small_size
      render Carbon::ContentSwitcherComponent.new(size: :sm) do |c|
        c.with_option(label: 'Option 1', selected: true)
        c.with_option(label: 'Option 2')
        c.with_option(label: 'Option 3')
      end
    end

    def large_size
      render Carbon::ContentSwitcherComponent.new(size: :lg) do |c|
        c.with_option(label: 'Option 1', selected: true)
        c.with_option(label: 'Option 2')
        c.with_option(label: 'Option 3')
      end
    end

    def two_options
      render Carbon::ContentSwitcherComponent.new do |c|
        c.with_option(label: 'On', selected: true)
        c.with_option(label: 'Off')
      end
    end

    def many_options
      render Carbon::ContentSwitcherComponent.new do |c|
        c.with_option(label: 'Daily', selected: true)
        c.with_option(label: 'Weekly')
        c.with_option(label: 'Monthly')
        c.with_option(label: 'Yearly')
      end
    end

    def view_modes
      render Carbon::ContentSwitcherComponent.new do |c|
        c.with_option(label: 'Grid', selected: true)
        c.with_option(label: 'List')
      end
    end
  end
end
