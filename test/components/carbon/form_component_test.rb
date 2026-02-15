# frozen_string_literal: true

require 'test_helper'

module Carbon
  class FormComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders a form element with cds--form class' do
      render_inline(Carbon::FormComponent.new) { 'Form content' }

      assert_selector 'form.cds--form', text: 'Form content'
    end

    test 'renders content inside the form' do
      render_inline(Carbon::FormComponent.new) do
        '<input type="text" name="test">'.html_safe
      end

      assert_selector 'form.cds--form input[type="text"][name="test"]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::FormComponent.new(
          id: 'my-form',
          action: '/submit',
          method: 'post',
          data: { testid: 'form-1' }
        )
      ) { 'Content' }

      assert_selector 'form#my-form[action="/submit"][method="post"][data-testid="form-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::FormComponent.new(class: 'my-custom-class')) { 'Content' }

      assert_selector 'form.cds--form.my-custom-class'
    end

    test 'supports aria attributes' do
      render_inline(Carbon::FormComponent.new(aria: { label: 'Registration form' })) { 'Content' }

      assert_selector 'form[aria-label="Registration form"]'
    end
  end
end
