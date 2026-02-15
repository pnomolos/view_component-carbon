# frozen_string_literal: true

module Carbon
  class LinkComponentPreview < ViewComponent::Preview
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    # @param inline toggle
    # @param visited toggle
    def default(size: :lg, disabled: false, inline: false, visited: false)
      render Carbon::LinkComponent.new(
        href: '/example',
        size: size.to_sym,
        disabled: disabled,
        inline: inline,
        visited: visited
      ) { 'Link text' }
    end

    def with_icon
      render Carbon::LinkComponent.new(href: '/example') do |c|
        c.with_icon { '<svg width="16" height="16"><circle cx="8" cy="8" r="4" /></svg>'.html_safe }
        'Link with icon'
      end
    end

    def disabled
      render Carbon::LinkComponent.new(href: '/example', disabled: true) { 'Disabled link' }
    end

    def inline
      tag.p do
        'This is some text with an '.html_safe +
          render(Carbon::LinkComponent.new(href: '/example', inline: true) { 'inline link' }) +
          ' in the middle.'.html_safe
      end
    end
  end
end
