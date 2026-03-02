# frozen_string_literal: true

require 'test_helper'

module Carbon
  class CodeSnippetComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default code snippet' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'npm install'))

      assert_selector '.cds--snippet.cds--snippet--single'
      assert_selector 'code', text: 'npm install'
    end

    # -- Types --

    test 'renders single type (default)' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :single, code: 'code'))

      assert_selector '.cds--snippet--single'
      assert_selector 'div.cds--snippet'
    end

    test 'renders multi type' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: 'code'))

      assert_selector '.cds--snippet--multi'
      assert_selector 'div.cds--snippet'
    end

    test 'renders inline type' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :inline, code: 'code'))

      assert_selector '.cds--snippet--inline'
      assert_selector 'span.cds--snippet'
    end

    # -- Code content --

    test 'renders code from code parameter' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'console.log("hello")'))

      assert_selector 'code', text: 'console.log("hello")'
    end

    test 'renders code from block content' do
      render_inline(Carbon::CodeSnippetComponent.new) { 'block code' }

      assert_selector 'code', text: 'block code'
    end

    test 'prefers code parameter over block content' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'param code')) { 'block code' }

      assert_selector 'code', text: 'param code'
      assert_no_selector 'code', text: 'block code'
    end

    # -- Copy button --

    test 'renders copy button by default' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code'))

      assert_selector "button.cds--copy-btn[aria-label='Copy to clipboard']"
    end

    test 'hides copy button when hide_copy_button is true' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', hide_copy_button: true))

      assert_no_selector '.cds--copy-btn'
    end

    test 'copy button has stimulus action' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code'))

      assert_selector 'button[data-action="click->carbon--code-snippet#copy"]'
    end

    # -- Multi-line expand/collapse --

    test 'multi type has expand button' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: 'code'))

      assert_selector 'button.cds--btn.cds--btn--ghost.cds--btn--sm.cds--snippet-btn--expand'
      assert_selector 'button.cds--snippet-btn--expand svg.cds--icon-chevron--down.cds--snippet__icon'
    end

    test 'multi type expand button shows default text' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: 'code'))

      assert_selector '.cds--snippet-btn--text', text: 'Show more'
    end

    test 'multi type expand button shows custom text' do
      render_inline(Carbon::CodeSnippetComponent.new(
                      type: :multi,
                      code: 'code',
                      show_more_text: 'Expand',
                      show_less_text: 'Collapse'
                    ))

      assert_selector '.cds--snippet-btn--text', text: 'Expand'
    end

    test 'single type does not have expand button' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :single, code: 'code'))

      assert_no_selector '.cds--snippet-btn--expand'
    end

    test 'inline type does not have expand button' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :inline, code: 'code'))

      assert_no_selector '.cds--snippet-btn--expand'
    end

    # -- Stimulus controller --

    test 'has stimulus controller data attribute' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code'))

      assert_selector '[data-controller="carbon--code-snippet"]'
    end

    # -- Code target --

    test 'has code target for stimulus' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code'))

      assert_selector '[data-carbon--code-snippet-target="code"]'
    end

    # -- Structure for single/multi --

    test 'single type has snippet container with accessibility attributes' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :single, code: 'code'))

      assert_selector '.cds--snippet-container[role="textbox"][tabindex="0"][aria-readonly="true"]'
      assert_selector '.cds--snippet-container pre code'
      assert_no_selector '.cds--snippet-container[aria-multiline]'
    end

    test 'multi type has snippet container with accessibility attributes' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: 'code'))

      assert_selector '.cds--snippet-container[role="textbox"][tabindex="0"]' \
                      '[aria-readonly="true"][aria-multiline="true"]'
      assert_selector '.cds--snippet-container pre code'
    end

    test 'inline type does not have snippet container' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :inline, code: 'code'))

      assert_no_selector '.cds--snippet-container'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::CodeSnippetComponent.new(
                      code: 'code',
                      id: 'my-snippet',
                      data: { testid: 'snippet-1' }
                    ))

      assert_selector ".cds--snippet#my-snippet[data-testid='snippet-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', class: 'my-custom-class'))

      assert_selector '.cds--snippet.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid type' do
      assert_raises(ArgumentError) do
        Carbon::CodeSnippetComponent.new(code: 'code', type: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for type' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', type: 'multi'))

      assert_selector '.cds--snippet--multi'
    end

    # -- Disabled tests --

    test 'renders without disabled class by default' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code'))

      assert_no_selector '.cds--snippet--disabled'
    end

    test 'adds disabled class when disabled is true' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', disabled: true))

      assert_selector '.cds--snippet.cds--snippet--disabled'
    end

    test 'disables copy button when disabled is true' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', disabled: true))

      assert_selector 'button.cds--copy-btn[disabled]'
    end

    test 'does not disable copy button when disabled is false' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', disabled: false))

      assert_no_selector 'button.cds--copy-btn[disabled]'
    end

    test 'disables copy button for inline type when disabled' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :inline, code: 'code', disabled: true))

      assert_selector 'span.cds--snippet button.cds--copy-btn[disabled]'
    end

    test 'disables copy button for multi type when disabled' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, code: 'code', disabled: true))

      assert_selector 'div.cds--snippet button.cds--copy-btn[disabled]'
    end

    # -- Wrap text tests --

    test 'renders without wrap text class by default' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code'))

      assert_no_selector '.cds--snippet--wraptext'
    end

    test 'adds wrap text class when wrap_text is true' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', wrap_text: true))

      assert_selector '.cds--snippet.cds--snippet--wraptext'
    end

    test 'does not add wrap text class when wrap_text is false' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', wrap_text: false))

      assert_no_selector '.cds--snippet--wraptext'
    end

    test 'renders wrap text variant' do
      render_inline(Carbon::CodeSnippetComponent.new(type: :multi, wrap_text: true)) { 'code' }

      assert_selector '.cds--snippet--wraptext'
    end

    test 'combines disabled and wrap_text classes' do
      render_inline(Carbon::CodeSnippetComponent.new(code: 'code', disabled: true, wrap_text: true))

      assert_selector '.cds--snippet.cds--snippet--disabled.cds--snippet--wraptext'
    end
  end
end
