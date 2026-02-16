# frozen_string_literal: true

module Carbon
  class TabsComponentPreview < ViewComponent::Preview
    # @param type select { choices: [default, contained] }
    def default(type: :default)
      render Carbon::TabsComponent.new(type: type.to_sym) do |c|
        c.with_tab(label: 'Tab 1', selected: true) do
          'Content for the first tab. This is currently selected.'
        end
        c.with_tab(label: 'Tab 2') do
          'Content for the second tab.'
        end
        c.with_tab(label: 'Tab 3') do
          'Content for the third tab.'
        end
      end
    end

    def contained_type
      render Carbon::TabsComponent.new(type: :contained) do |c|
        c.with_tab(label: 'Overview', selected: true) do
          '<h3>Overview</h3><p>This is the overview tab content.</p>'.html_safe
        end
        c.with_tab(label: 'Details') do
          '<h3>Details</h3><p>This is the details tab content.</p>'.html_safe
        end
        c.with_tab(label: 'Settings') do
          '<h3>Settings</h3><p>This is the settings tab content.</p>'.html_safe
        end
      end
    end

    def with_disabled_tab
      render Carbon::TabsComponent.new do |c|
        c.with_tab(label: 'Active Tab', selected: true) do
          'This tab is active and can be selected.'
        end
        c.with_tab(label: 'Disabled Tab', disabled: true) do
          'This tab is disabled and cannot be selected.'
        end
        c.with_tab(label: 'Another Active Tab') do
          'This is another active tab.'
        end
      end
    end

    def many_tabs
      render Carbon::TabsComponent.new do |c|
        6.times do |i|
          c.with_tab(label: "Tab #{i + 1}", selected: i.zero?) do
            "Content for tab #{i + 1}. Click different tabs to see the content switch."
          end
        end
      end
    end
  end
end
