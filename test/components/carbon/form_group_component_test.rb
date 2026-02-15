# frozen_string_literal: true

require 'test_helper'

module Carbon
  class FormGroupComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders a fieldset with cds--fieldset class' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Group')) { 'Content' }

      assert_selector 'fieldset.cds--fieldset'
    end

    test 'renders legend text' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Personal info')) { 'Content' }

      assert_selector 'fieldset legend.cds--label', text: 'Personal info'
    end

    test 'legend has id and fieldset references it via aria-labelledby' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Group')) { 'Content' }

      legend = page.find('legend')
      fieldset = page.find('fieldset')

      assert_predicate legend[:id], :present?
      assert_equal legend[:id], fieldset[:'aria-labelledby']
    end

    test 'renders content inside the fieldset' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Group')) do
        '<input type="text">'.html_safe
      end

      assert_selector 'fieldset input[type="text"]'
    end

    # -- Without legend --

    test 'does not render legend when legend_text is nil' do
      render_inline(Carbon::FormGroupComponent.new) { 'Content' }

      assert_no_selector 'legend'
    end

    # -- Invalid state --

    test 'renders invalid fieldset' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Group', invalid: true)) { 'Content' }

      assert_selector 'fieldset.cds--fieldset.cds--fieldset--invalid[data-invalid]'
    end

    test 'does not render invalid class when not invalid' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Group')) { 'Content' }

      assert_no_selector '.cds--fieldset--invalid'
      assert_no_selector '[data-invalid]'
    end

    # -- Message --

    test 'renders message text when message is true and message_text is provided' do
      render_inline(
        Carbon::FormGroupComponent.new(
          legend_text: 'Group',
          message: true,
          message_text: 'Please fill in all fields'
        )
      ) { 'Content' }

      assert_selector '.cds--form-requirement', text: 'Please fill in all fields'
    end

    test 'does not render message when message is false' do
      render_inline(
        Carbon::FormGroupComponent.new(
          legend_text: 'Group',
          message: false,
          message_text: 'Message'
        )
      ) { 'Content' }

      assert_no_selector '.cds--form-requirement'
    end

    test 'does not render message when message_text is nil' do
      render_inline(
        Carbon::FormGroupComponent.new(
          legend_text: 'Group',
          message: true,
          message_text: nil
        )
      ) { 'Content' }

      assert_no_selector '.cds--form-requirement'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(
        Carbon::FormGroupComponent.new(
          legend_text: 'Group',
          data: { testid: 'group-1' }
        )
      ) { 'Content' }

      assert_selector 'fieldset[data-testid="group-1"]'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::FormGroupComponent.new(legend_text: 'Group', class: 'my-custom-class')) { 'Content' }

      assert_selector 'fieldset.cds--fieldset.my-custom-class'
    end
  end
end
