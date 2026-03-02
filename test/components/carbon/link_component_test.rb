# frozen_string_literal: true

require 'test_helper'

module Carbon
  class LinkComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default link' do
      render_inline(Carbon::LinkComponent.new(href: '/test')) { 'Click me' }

      assert_selector "a.cds--link.cds--link--lg[href='/test']", text: 'Click me'
    end

    test 'renders content inside link' do
      render_inline(Carbon::LinkComponent.new(href: '/test')) { 'Link text' }

      assert_selector 'a.cds--link', text: 'Link text'
    end

    # -- Sizes --

    test 'renders sm size' do
      render_inline(Carbon::LinkComponent.new(href: '/test', size: :sm)) { 'Small' }

      assert_selector 'a.cds--link--sm'
    end

    test 'renders md size' do
      render_inline(Carbon::LinkComponent.new(href: '/test', size: :md)) { 'Medium' }

      assert_selector 'a.cds--link--md'
    end

    test 'renders lg size (default)' do
      render_inline(Carbon::LinkComponent.new(href: '/test')) { 'Large' }

      assert_selector 'a.cds--link--lg'
    end

    # -- Disabled --

    test 'renders disabled link as span with role=button and aria-disabled' do
      render_inline(Carbon::LinkComponent.new(href: '/test', disabled: true)) { 'Disabled' }

      assert_selector "span.cds--link--disabled[role='button'][aria-disabled='true']"
      assert_no_selector 'a'
      assert_no_selector 'span[href]'
    end

    test 'disabled link has no href attribute' do
      render_inline(Carbon::LinkComponent.new(href: '/test', disabled: true)) { 'Disabled' }

      assert_selector 'span.cds--link--disabled'
      assert_no_selector '[href]'
    end

    # -- Inline --

    test 'renders inline link with CSS class' do
      render_inline(Carbon::LinkComponent.new(href: '/test', inline: true)) { 'Inline' }

      assert_selector 'a.cds--link--inline'
    end

    test 'renders inline link with text wrapped in span' do
      render_inline(Carbon::LinkComponent.new(href: '/test', inline: true)) { 'Inline Text' }

      assert_selector 'a.cds--link--inline span.cds--link__text', text: 'Inline Text'
    end

    # -- Visited --

    test 'renders visited link with CSS class' do
      render_inline(Carbon::LinkComponent.new(href: '/test', visited: true)) { 'Visited' }

      assert_selector 'a.cds--link--visited'
    end

    # -- Icon --

    test 'renders with icon slot' do
      render_inline(Carbon::LinkComponent.new(href: '/test')) do |c|
        c.with_icon { '<svg>icon</svg>'.html_safe }
        'With Icon'
      end

      assert_selector '.cds--link__icon svg'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::LinkComponent.new(href: '/test', id: 'my-link', data: { testid: 'link-1' })) { 'Test' }

      assert_selector "a#my-link[data-testid='link-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::LinkComponent.new(href: '/test', class: 'my-custom-class')) { 'Custom' }

      assert_selector 'a.cds--link.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::LinkComponent.new(href: '/test', size: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for size' do
      render_inline(Carbon::LinkComponent.new(href: '/test', size: 'sm')) { 'String Size' }

      assert_selector 'a.cds--link--sm'
    end

    # -- Combined variants --

    test 'renders inline and visited together' do
      render_inline(Carbon::LinkComponent.new(href: '/test', inline: true, visited: true)) { 'Combined' }

      assert_selector 'a.cds--link--inline.cds--link--visited'
    end

    test 'renders inline variant' do
      render_inline(Carbon::LinkComponent.new(href: '#', inline: true)) { 'Link' }

      assert_selector '.cds--link--inline'
    end

    test 'renders disabled inline link' do
      render_inline(Carbon::LinkComponent.new(href: '/test', disabled: true, inline: true)) { 'Disabled Inline' }

      assert_selector 'span.cds--link--disabled.cds--link--inline[role="button"]'
      assert_no_selector '[href]'
    end
  end
end
