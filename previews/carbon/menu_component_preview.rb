# frozen_string_literal: true

module Carbon
  class MenuComponentPreview < ViewComponent::Preview
    # @param size select { choices: [xs, sm, md, lg] }
    # @param open toggle
    def default(size: :md, open: true)
      render Carbon::MenuComponent.new(size: size.to_sym, open: open, label: 'Actions') do |c|
        c.with_item(label: 'Copy', shortcut: 'Ctrl+C')
        c.with_item(label: 'Paste', shortcut: 'Ctrl+V')
        c.with_divider
        c.with_item(label: 'Delete', danger: true)
      end
    end

    def with_disabled_items
      render Carbon::MenuComponent.new(open: true, label: 'Edit') do |c|
        c.with_item(label: 'Cut', shortcut: 'Ctrl+X')
        c.with_item(label: 'Copy', shortcut: 'Ctrl+C')
        c.with_item(label: 'Paste', shortcut: 'Ctrl+V', disabled: true)
        c.with_divider
        c.with_item(label: 'Select All', shortcut: 'Ctrl+A')
      end
    end

    def with_groups
      render Carbon::MenuComponent.new(open: true, label: 'File menu') do |c|
        c.with_group(label: 'File operations') do |group|
          group.with_item(label: 'New File')
          group.with_item(label: 'Open File')
          group.with_item(label: 'Save')
        end
        c.with_divider
        c.with_group(label: 'Edit operations') do |group|
          group.with_item(label: 'Undo', shortcut: 'Ctrl+Z')
          group.with_item(label: 'Redo', shortcut: 'Ctrl+Y')
        end
      end
    end

    def small_size
      render Carbon::MenuComponent.new(size: :sm, open: true, label: 'Small menu') do |c|
        c.with_item(label: 'Option 1')
        c.with_item(label: 'Option 2')
        c.with_item(label: 'Option 3')
      end
    end

    def extra_small_size
      render Carbon::MenuComponent.new(size: :xs, open: true, label: 'Extra small menu') do |c|
        c.with_item(label: 'Option 1')
        c.with_item(label: 'Option 2')
      end
    end
  end
end
