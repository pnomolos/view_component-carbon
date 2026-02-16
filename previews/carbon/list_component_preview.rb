# frozen_string_literal: true

module Carbon
  class ListComponentPreview < ViewComponent::Preview
    # @param ordered toggle
    # @param nested toggle
    def default(ordered: false, nested: false)
      render Carbon::ListComponent.new(ordered: ordered, nested: nested) do |c|
        c.with_item { 'First item' }
        c.with_item { 'Second item' }
        c.with_item { 'Third item' }
      end
    end

    def unordered
      render Carbon::ListComponent.new do |c|
        c.with_item { 'Apples' }
        c.with_item { 'Bananas' }
        c.with_item { 'Oranges' }
      end
    end

    def ordered
      render Carbon::ListComponent.new(ordered: true) do |c|
        c.with_item { 'First step' }
        c.with_item { 'Second step' }
        c.with_item { 'Third step' }
      end
    end

    def nested_list
      render Carbon::ListComponent.new do |c|
        c.with_item { 'Parent item 1' }
        c.with_item do
          tag.div do
            concat tag.span('Parent item 2')
            concat render(Carbon::ListComponent.new(nested: true)) do |nested|
              nested.with_item { 'Nested item 1' }
              nested.with_item { 'Nested item 2' }
            end
          end
        end
        c.with_item { 'Parent item 3' }
      end
    end

    def long_list
      render Carbon::ListComponent.new do |c|
        10.times do |i|
          c.with_item { "List item #{i + 1}" }
        end
      end
    end
  end
end
