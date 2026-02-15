# frozen_string_literal: true

module Carbon
  class ButtonComponentPreview < ViewComponent::Preview
    # @param kind select { choices: [primary, secondary, tertiary, ghost, danger, danger_tertiary, danger_ghost] }
    # @param size select { choices: [sm, md, lg, xl, 2xl] }
    # @param disabled toggle
    # @param label text
    def default(kind: :primary, size: :lg, disabled: false, label: "Button")
      render Carbon::ButtonComponent.new(kind: kind.to_sym, size: size.to_sym, disabled: disabled) do
        label
      end
    end

    def all_kinds
      render_with_template
    end

    # @param size select { choices: [sm, md, lg, xl, 2xl] }
    def sizes(size: :lg)
      render Carbon::ButtonComponent.new(size: size.to_sym) do
        "Size: #{size}"
      end
    end

    def as_link
      render Carbon::ButtonComponent.new(href: "#", kind: :primary) do
        "Link Button"
      end
    end

    def icon_only
      render Carbon::ButtonComponent.new(icon_only: true, icon_description: "Add") do |c|
        c.with_icon do
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor"><path d="M17 15V7h-2v8H7v2h8v8h2v-8h8v-2z"/></svg>'.html_safe
        end
      end
    end

    def with_icon
      render Carbon::ButtonComponent.new(kind: :primary) do |c|
        c.with_icon do
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="16" height="16" fill="currentColor"><path d="M17 15V7h-2v8H7v2h8v8h2v-8h8v-2z"/></svg>'.html_safe
        end
        "Add item"
      end
    end

    def disabled
      render Carbon::ButtonComponent.new(disabled: true) do
        "Disabled"
      end
    end
  end
end
