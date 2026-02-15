# frozen_string_literal: true

module Carbon
  class ContainedListComponentPreview < ViewComponent::Preview
    # @param kind select { choices: [on_page, disclosed] }
    # @param label text
    def default(kind: :on_page, label: 'List title')
      render Carbon::ContainedListComponent.new(label: label, kind: kind.to_sym) do |c|
        c.with_item { 'List item' }
        c.with_item { 'List item' }
        c.with_item { 'List item' }
        c.with_item { 'List item' }
      end
    end

    def on_page
      render Carbon::ContainedListComponent.new(label: 'On page list', kind: :on_page) do |c|
        c.with_item { 'Item 1' }
        c.with_item { 'Item 2' }
        c.with_item { 'Item 3' }
      end
    end

    def disclosed
      render Carbon::ContainedListComponent.new(label: 'Disclosed list', kind: :disclosed) do |c|
        c.with_item { 'Item 1' }
        c.with_item { 'Item 2' }
        c.with_item { 'Item 3' }
      end
    end

    def with_actions
      render Carbon::ContainedListComponent.new(label: 'List with actions') do |c|
        c.with_item do |item|
          item.with_action { '<button class="cds--btn cds--btn--ghost cds--btn--sm">Delete</button>'.html_safe }
          'Item with delete action'
        end
        c.with_item do |item|
          item.with_action { '<button class="cds--btn cds--btn--ghost cds--btn--sm">Edit</button>'.html_safe }
          'Item with edit action'
        end
      end
    end
  end
end
