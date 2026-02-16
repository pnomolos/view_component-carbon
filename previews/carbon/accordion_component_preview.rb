# frozen_string_literal: true

module Carbon
  class AccordionComponentPreview < ViewComponent::Preview
    # @param align select { choices: [start, end] }
    # @param size select { choices: [sm, md, lg] }
    def default(align: :end, size: :md)
      render Carbon::AccordionComponent.new(align: align.to_sym, size: size.to_sym) do |c|
        c.with_item(title: 'Section 1') do
          'Content for section 1. This is the first accordion item.'
        end
        c.with_item(title: 'Section 2', open: true) do
          'Content for section 2. This item is open by default.'
        end
        c.with_item(title: 'Section 3') do
          'Content for section 3. This is the third accordion item.'
        end
      end
    end

    def small_size
      render Carbon::AccordionComponent.new(size: :sm) do |c|
        c.with_item(title: 'Small Item 1') { 'Content 1' }
        c.with_item(title: 'Small Item 2') { 'Content 2' }
      end
    end

    def large_size
      render Carbon::AccordionComponent.new(size: :lg) do |c|
        c.with_item(title: 'Large Item 1') { 'Content 1' }
        c.with_item(title: 'Large Item 2') { 'Content 2' }
      end
    end

    def start_align
      render Carbon::AccordionComponent.new(align: :start) do |c|
        c.with_item(title: 'Start Aligned Item 1') { 'Content 1' }
        c.with_item(title: 'Start Aligned Item 2') { 'Content 2' }
      end
    end

    def multiple_items
      render Carbon::AccordionComponent.new do |c|
        5.times do |i|
          c.with_item(title: "Item #{i + 1}", open: i.zero?) do
            "This is the content for item #{i + 1}. " \
              'You can put any HTML content here including paragraphs, lists, images, etc.'
          end
        end
      end
    end
  end
end
