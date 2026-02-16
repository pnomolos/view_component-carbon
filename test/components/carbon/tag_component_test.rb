# frozen_string_literal: true

require 'test_helper'

module Carbon
  class TagComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default tag' do
      render_inline(Carbon::TagComponent.new) { 'Tag label' }

      assert_selector 'span.cds--tag.cds--tag--md.cds--tag--gray', text: 'Tag label'
    end

    test 'renders content inside cds--tag__label span' do
      render_inline(Carbon::TagComponent.new) { 'Label' }

      assert_selector 'span .cds--tag__label', text: 'Label'
    end

    # -- Types --

    test 'renders read_only type as span' do
      render_inline(Carbon::TagComponent.new(type: :read_only)) { 'Read only' }

      assert_selector 'span.cds--tag'
      assert_no_selector '.cds--tag__close-icon'
    end

    test 'renders filter type as button with close icon' do
      render_inline(Carbon::TagComponent.new(type: :filter)) { 'Filter' }

      assert_selector 'button.cds--tag.cds--tag--filter'
      assert_selector '.cds--tag__close-icon'
    end

    test 'renders dismissible type as button with close icon' do
      render_inline(Carbon::TagComponent.new(type: :dismissible)) { 'Dismissible' }

      assert_selector 'button.cds--tag.cds--tag--dismissible'
      assert_selector '.cds--tag__close-icon'
    end

    # -- Colors --

    test 'renders red color' do
      render_inline(Carbon::TagComponent.new(color: :red)) { 'Red' }

      assert_selector '.cds--tag--red'
    end

    test 'renders magenta color' do
      render_inline(Carbon::TagComponent.new(color: :magenta)) { 'Magenta' }

      assert_selector '.cds--tag--magenta'
    end

    test 'renders purple color' do
      render_inline(Carbon::TagComponent.new(color: :purple)) { 'Purple' }

      assert_selector '.cds--tag--purple'
    end

    test 'renders blue color' do
      render_inline(Carbon::TagComponent.new(color: :blue)) { 'Blue' }

      assert_selector '.cds--tag--blue'
    end

    test 'renders cyan color' do
      render_inline(Carbon::TagComponent.new(color: :cyan)) { 'Cyan' }

      assert_selector '.cds--tag--cyan'
    end

    test 'renders teal color' do
      render_inline(Carbon::TagComponent.new(color: :teal)) { 'Teal' }

      assert_selector '.cds--tag--teal'
    end

    test 'renders green color' do
      render_inline(Carbon::TagComponent.new(color: :green)) { 'Green' }

      assert_selector '.cds--tag--green'
    end

    test 'renders gray color (default)' do
      render_inline(Carbon::TagComponent.new) { 'Gray' }

      assert_selector '.cds--tag--gray'
    end

    test 'renders cool_gray color' do
      render_inline(Carbon::TagComponent.new(color: :cool_gray)) { 'Cool gray' }

      assert_selector '.cds--tag--cool-gray'
    end

    test 'renders warm_gray color' do
      render_inline(Carbon::TagComponent.new(color: :warm_gray)) { 'Warm gray' }

      assert_selector '.cds--tag--warm-gray'
    end

    test 'renders high_contrast color' do
      render_inline(Carbon::TagComponent.new(color: :high_contrast)) { 'High contrast' }

      assert_selector '.cds--tag--high-contrast'
    end

    test 'renders outline color' do
      render_inline(Carbon::TagComponent.new(color: :outline)) { 'Outline' }

      assert_selector '.cds--tag--outline'
    end

    # -- Sizes --

    test 'renders sm size' do
      render_inline(Carbon::TagComponent.new(size: :sm)) { 'Small' }

      assert_selector '.cds--tag--sm'
    end

    test 'renders md size (default)' do
      render_inline(Carbon::TagComponent.new) { 'Medium' }

      assert_selector '.cds--tag--md'
    end

    test 'renders lg size' do
      render_inline(Carbon::TagComponent.new(size: :lg)) { 'Large' }

      assert_selector '.cds--tag--lg'
    end

    # -- Disabled --

    test 'renders disabled filter tag with disabled attribute' do
      render_inline(Carbon::TagComponent.new(type: :filter, disabled: true)) { 'Disabled' }

      assert_selector 'button.cds--tag[disabled]'
    end

    test 'renders disabled dismissible tag with disabled attribute' do
      render_inline(Carbon::TagComponent.new(type: :dismissible, disabled: true)) { 'Disabled' }

      assert_selector 'button.cds--tag[disabled]'
    end

    test 'disabled does not affect read_only tags' do
      render_inline(Carbon::TagComponent.new(type: :read_only, disabled: true)) { 'Read only' }

      assert_selector 'span.cds--tag'
      assert_no_selector 'span[disabled]'
    end

    # -- System arguments --

    test 'passes through system arguments as HTML attributes' do
      render_inline(Carbon::TagComponent.new(id: 'my-tag', data: { testid: 'tag-1' })) { 'Test' }

      assert_selector "span#my-tag[data-testid='tag-1']"
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::TagComponent.new(class: 'my-custom-class')) { 'Custom' }

      assert_selector 'span.cds--tag.my-custom-class'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid type' do
      assert_raises(ArgumentError) do
        Carbon::TagComponent.new(type: :invalid)
      end
    end

    test 'raises ArgumentError for invalid color' do
      assert_raises(ArgumentError) do
        Carbon::TagComponent.new(color: :invalid)
      end
    end

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::TagComponent.new(size: :invalid)
      end
    end

    # -- String arguments --

    test 'accepts string values for type' do
      render_inline(Carbon::TagComponent.new(type: 'filter')) { 'String Type' }

      assert_selector 'button.cds--tag--filter'
    end

    test 'accepts string values for color' do
      render_inline(Carbon::TagComponent.new(color: 'blue')) { 'String Color' }

      assert_selector '.cds--tag--blue'
    end

    test 'accepts string values for size' do
      render_inline(Carbon::TagComponent.new(size: 'sm')) { 'String Size' }

      assert_selector '.cds--tag--sm'
    end

    # -- Combined variants --

    test 'renders filter tag with custom color and size' do
      render_inline(Carbon::TagComponent.new(type: :filter, color: :red, size: :sm)) { 'Filter' }

      assert_selector 'button.cds--tag--filter.cds--tag--red.cds--tag--sm'
    end
  end
end
